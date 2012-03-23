//
//  ForegroundSendingStrategy.m
//  iChallengeEarth
//
//  Created by Administrator on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ForegroundSendingStrategy.h"
#import "ActivityData.h"
#import "Progress.h"
#import "Challenge.h"
#import "ChallengeAttempt.h"
#import "LocationRKCallbackHandler.h"
#import "ceAppDelegate.h"
#import "RestKit/RestKit.h"
#import "LocationRKCallbackHandler.h"


@implementation ForegroundSendingStrategy 
@synthesize callbackHandler;

-(void)sendToServer:(CLLocation*)newLocation forChallengeAttempt:(ChallengeAttempt *)currentChallengeAttempt
{
    ActivityData *newActivity = [self createNewActivityData:newLocation withChallengeAttempt:currentChallengeAttempt];
    
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
        
        [self postActivityDataAsynchronousToServer:activityData];
        
        currentIndex++;
    }
}


-(void)postActivityDataAsynchronousToServer:(ActivityData*)activityData
{
    [[RKObjectManager sharedManager] postObject:activityData mapResponseWith:[ActivityData getMappingForREST] delegate:callbackHandler];
    NSLog(@"Send ActivityData asynchron to server: %@.",activityData);
}

-(bool)shouldWeAskForProgress:(int)currentIndex whenActivityDataCount:(int)count
{
    
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

-(ActivityData *)createNewActivityData:(CLLocation*)newLocation withChallengeAttempt:(ChallengeAttempt*)currentChallengeAttempt
{
    ActivityData *newActivity = [ActivityData object];
    
    [newActivity initializeLocation:newLocation];
    [newActivity addAttemptHashsObject:currentChallengeAttempt.attemptHash];
    newActivity.userId = [NSNumber numberWithLong:USERID];
    
    return newActivity;
}


@end
