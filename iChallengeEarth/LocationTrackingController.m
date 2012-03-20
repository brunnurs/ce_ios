//
//  LocationTrackingController.m
//  iChallengeEarth
//
//  Created by Administrator on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationTrackingController.h"
#import "ActivityData.h"
#import "Progress.h"
#import "Challenge.h"
#import "ChallengeAttempt.h"
#import "LocationRKCallbackHandler.h"
#import "ceAppDelegate.h"
#include <stdlib.h>



@implementation LocationTrackingController
@synthesize locationManager;
@synthesize callbackHandler;
@synthesize currentChallengeAttempt;
@synthesize isInBackgroundMode;

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
    
    self.callbackHandler = [[LocationRKCallbackHandler alloc] initWithTrackingController:self];
    self.callbackHandler.askForProgressAfterActivitySent = YES;
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    locationManager.distanceFilter = 50.0f;
    
    self.isInBackgroundMode = false;

	return self;
}

-(void)initializeNewChallengeAttemptWithChallenge:(Challenge*)challenge
{
    ChallengeAttempt *newChallengeAttempt = [ChallengeAttempt object];
    [newChallengeAttempt initializeNewHashWithChallenge:challenge];
    self.currentChallengeAttempt = newChallengeAttempt;
}

-(void)initializeChallengeAttempt:(ChallengeAttempt*)challengeAttempt
{
    self.currentChallengeAttempt = challengeAttempt;

}

-(void)setChallengeView:(id <TrackingControllerDelegate>)challengeView
{
	self.callbackHandler.challengeView = challengeView;
}

-(id <TrackingControllerDelegate>)challengeView
{
	return self.callbackHandler.challengeView;
}


-(void)startTracking
{
    currentChallengeAttempt.startDate = [NSDate date];
    [locationManager startUpdatingLocation];
}

-(void)stopTracking
{
    [locationManager stopUpdatingLocation];
}

-(float)distanceFilter
{
	return locationManager.distanceFilter;
}

-(void)setDistanceFilter:(float)distance
{
	locationManager.distanceFilter = distance;
}

-(BOOL)askSpontaneousForProgress
{
    if(self.currentChallengeAttempt != nil)
    {
        [callbackHandler askForCurrentProgress];
        return true;
    }
    else
    {
        return false;
    }
}


-(void)handlePositionUpdate:(CLLocation*)newLocation
{
    ActivityData *newActivity = [self createNewActivityData:newLocation];
    
//    int r = (arc4random() % 3) + 2;
//    NSLog(@"r is: %d",r);
//    if(r == 3)
    if([[RKClient sharedClient].reachabilityObserver isNetworkReachable])
    {
        [self postCachedAndTheNewActivityToServer];
        [callbackHandler.challengeView positionUpdateWithConnectivity:true];
    }
    else
    {
        [self saveToDatabase:newActivity];
        [callbackHandler.challengeView positionUpdateWithConnectivity:false];
    }

}

-(void)removeOldActivityDataFromDatabase
{
    NSArray *activitiesToRemove = [ActivityData findByAttribute:@"toRemove" withValue:[NSNumber numberWithBool:YES]];
    NSNumber *currentTimeAsNumber = [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000];

    for (ActivityData* activity in activitiesToRemove) 
    {
        //we remove activityData only if they are older than 1min to avoid problems with the RequestQueue.
        long long timeDiff = currentTimeAsNumber.longLongValue - activity.dateTime.longLongValue;
        NSLog(@"Timedifference is: %lld",timeDiff);
        if(timeDiff > 1000)
        {
            [activity.managedObjectContext deleteObject:activity];
        }
    }
    
    if(activitiesToRemove.count > 0)
    {
        NSError* error;
        [((ActivityData*)[activitiesToRemove objectAtIndex:0]).managedObjectContext save:&error];
        NSLog(@"Removed %d old activities from database \nerror:%@ | %@ | %@",activitiesToRemove.count, error, [error userInfo],[error localizedDescription]);

    }
}

-(void)saveToDatabase:(ActivityData*)newActivity
{
    NSError* error;
    BOOL hasSaved = [newActivity.managedObjectContext save:&error];
    NSLog(@"Currently no connection. Saved object to database. %@ has saved: (%@)",newActivity,(hasSaved) ? @"YES" : @"NO");
 }

//The new ActivityData is allready under control of the managedObjectContext, so we don't need to provide a parameter
-(void)postCachedAndTheNewActivityToServer
{
    [self removeOldActivityDataFromDatabase];
    
    //Load objects from the local database (which have been cached because of connectivity-problems)
    NSArray *cachedActivityData = [ActivityData findByAttribute:@"toRemove" withValue:[NSNumber numberWithBool:NO]];
    

    int currentIndex = 0;
    for (ActivityData *activityData in cachedActivityData) 
    {
        self.callbackHandler.askForProgressAfterActivitySent = [self shouldWeAskForProgress:currentIndex whenActivityDataCount:cachedActivityData.count];
        
        if(isInBackgroundMode)
        {
            [self postActivityDataSynchronousToServer:activityData];
        }
        else
        {
            [self postActivityDataAsynchronousToServer:activityData];
        }
        
        currentIndex++;
    }
}


-(void)postActivityDataAsynchronousToServer:(ActivityData*)activityData
{
    [[RKObjectManager sharedManager] postObject:activityData mapResponseWith:[ActivityData getMappingForREST] delegate:callbackHandler];
    NSLog(@"Send ActivityData asynchron to server: %@.",activityData);
}

-(void)postActivityDataSynchronousToServer:(ActivityData*)activityData
{
    //IMPORTANT: if we send data triggered by a background-location-event, we have to use a synchronus-send, because the 
    //queue mechanism doesn't work there (the reason can be found in some of ursin's links). Despite of that, we can not use the
    //main-thread for this work, because when the network-call last too long, the app crashs (even if we don't block the GUI).
    //That's why we have to use here another Thread, where we make the synchronus call.
    //Rest-Kit normaly doesn't allow this, thats why we have to remove the Assert on RKObjectLoader.didFinishLoad.
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderForObject:activityData method:RKRequestMethodPOST delegate:callbackHandler];
        loader.targetObject = activityData;
        loader.objectMapping = [ActivityData getMappingForREST];
        [loader sendSynchronously]; 
    });
    
    NSLog(@"Sended ActivityData synchron to server: %@.",activityData);
}

-(bool)shouldWeAskForProgress:(int)currentIndex whenActivityDataCount:(int)count
{
    if(self.isInBackgroundMode)
    {
        return false;
    }
    
    //  if more than 10 rows to send, ask just every 10th ActivityData or on the last ActivityData for progress
    if(count > 10)
    {
        if(currentIndex % 10 == 0 || currentIndex == (count - 1))
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    else
    {
        return true;
    }
}

-(ActivityData *)createNewActivityData:(CLLocation*)newLocation
{
    ActivityData *newActivity = [ActivityData object];
    
    [newActivity initializeLocation:newLocation];
    [newActivity addAttemptHashsObject:currentChallengeAttempt.attemptHash];
    newActivity.userId = [NSNumber numberWithLong:USERID];
    
    return newActivity;
}

-(void)removeCurrentChallengeAttempt
{
    NSError* error;
    [currentChallengeAttempt.managedObjectContext deleteObject:currentChallengeAttempt];
    bool hasSaved = [currentChallengeAttempt.managedObjectContext save:&error];
    NSLog(@"Removed curentChallengeAttempt with AttemptHash. Save worked? (%@)",(hasSaved) ? @"YES" : @"NO");
    
    self.currentChallengeAttempt = nil;
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager 
	didUpdateToLocation:(CLLocation *)newLocation 
		   fromLocation:(CLLocation *)oldLocation
{
//    NSLog(@"New Position-Update: %@",newLocation);
    [self handlePositionUpdate:newLocation];
} 

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"got an error while position changed x%@",error);
}

@end
