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

- (id)initWithChallenge:(Challenge *)chall
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
    
    self.currentChallengeAttempt = [[ChallengeAttempt alloc]initWithNewHashAndChallenge:chall];
    
    //register myself on the app-delegate to detect background mode
    ceAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.trackingController = self;
    
	return self;
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

-(void)handlePositionUpdate:(CLLocation*)newLocation
{
    ActivityData *newActivity = [self createNewActivityData:newLocation];
    
    int r = (arc4random() % 3) + 2;
    NSLog(@"r is: %d",r);
    if(r == 3)
//    if([[RKClient sharedClient].reachabilityObserver isNetworkReachable])
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
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderForObject:activityData method:RKRequestMethodPOST delegate:callbackHandler];
    loader.targetObject = activityData;
	loader.objectMapping = [ActivityData getMappingForREST];
    RKResponse* response = [loader sendSynchronously];
    
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
    [currentChallengeAttempt.attemptHash.managedObjectContext deleteObject:currentChallengeAttempt.attemptHash];
    bool hasSaved = [currentChallengeAttempt.attemptHash.managedObjectContext save:&error];
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
