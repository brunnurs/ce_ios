//
//  SendingStrategy.m
//  iChallengeEarth
//
//  Created by Administrator on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SendingStrategy.h"
#import "ActivityData.h"
#import "Progress.h"
#import "Challenge.h"
#import "ChallengeAttempt.h"
#import "LocationRKCallbackHandler.h"
#import "ceAppDelegate.h"
#import "RestKit/RestKit.h"
#import "LocationRKCallbackHandler.h"
#import "NSManagedObjectLogger.h"
#import "LocationTrackingController.h"

#include <stdlib.h>


@implementation SendingStrategy
@synthesize locationTrackingController;

-(void)postActivityDataToServer:(ActivityData*)activityData
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];

}

-(bool)shouldWeAskForProgress:(int)currentIndex whenActivityDataCount:(int)count
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}


-(bool)sendToServer:(CLLocation*)newLocation
{
    ActivityData *newActivity = [self createNewActivityData:newLocation withChallengeAttempt:locationTrackingController.currentChallengeAttempt];
    bool hadConnectivity = false;
    
    int r = (arc4random() % 3) + 2;
    NSLog(@"r is: %d",r);
    if(r == 3 || r == 4)
//    if([[RKClient sharedClient].reachabilityObserver isNetworkReachable])
    {
        [self postCachedAndTheNewActivityToServer];
        hadConnectivity = true;    
    }
    else
    {
        [self saveToDatabase:newActivity];
        hadConnectivity = false;
    }
    
    return hadConnectivity;
}





-(void)removeOldActivityDataFromDatabase
{
    NSArray *activitiesToRemove = [ActivityData findByAttribute:@"toRemove" withValue:[NSNumber numberWithBool:YES]];
    NSNumber *currentTimeAsNumber = [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000];
    
    for (ActivityData* activity in activitiesToRemove) 
    {
        //we remove activityData only if they are older than 1min to avoid problems with the RequestQueue.
        long long timeDiff = currentTimeAsNumber.longLongValue - activity.dateTime.longLongValue;
        NSLog(@"Timedifference is: %lld, longitude: %@",timeDiff,activity.longitude);
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
    [NSManagedObjectLogger logSavingError:error whenSaveFails:hasSaved];
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
        self.locationTrackingController.callbackHandler.askForProgressAfterActivitySent = [self shouldWeAskForProgress:currentIndex whenActivityDataCount:cachedActivityData.count];
        
        [self postActivityDataToServer:activityData];
        
        currentIndex++;
    }
}


-(ActivityData *)createNewActivityData:(CLLocation*)newLocation withChallengeAttempt:(ChallengeAttempt*)currentChallengeAttempt
{
    ActivityData *newActivity = [ActivityData object];
    
    [newActivity initializeLocation:newLocation];
    [newActivity addAttemptHashsObject:currentChallengeAttempt.attemptHash];
    newActivity.userId = [NSNumber numberWithLong:USERID];
    
    return newActivity;
}


@end
