//
//  BackgroundSendingStrategy.m
//  iChallengeEarth
//
//  Created by Administrator on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BackgroundSendingStrategy.h"
#import "ActivityData.h"
#import "ChallengeAttempt.h"
#import "AttemptHash.h"
#import "RestKit/RestKit.h"
#import "ceAppDelegate.h"

@implementation BackgroundSendingStrategy

-(void)sendToServer:(CLLocation*)newLocation forChallengeAttempt:(ChallengeAttempt *)currentChallengeAttempt
{
    
    if([[RKClient sharedClient].reachabilityObserver isNetworkReachable])
    {
        //IMPORTANT: if we send data triggered by a background-location-event, we have to use a synchronus-send, because the 
        //queue mechanism doesn't work there (the reason can be found in some of ursin's links). Despite of that, we can not use the
        //main-thread for this work, because when the network-call last too long, the app crashs (even if we don't block the GUI).
        //That's why we have to use here another Thread, where we make the synchronus call.
        //Rest-Kit normaly doesn't allow this, thats why we have to remove the Assert on RKObjectLoader.didFinishLoad.
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            ActivityData *newActivity = [self createNewActivityData:newLocation withChallengeAttempt:currentChallengeAttempt];
            [self postActivityDataSynchronousToServer:newActivity];
        });
    }
    else
    {
        NSLog(@"I have no connectivity, but I don't give a fuck and do nothing!");
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

-(void)postActivityDataSynchronousToServer:(ActivityData*)activityData
{
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderForObject:activityData method:RKRequestMethodPOST delegate:nil];
    loader.targetObject = activityData;
    loader.objectMapping = [ActivityData getMappingForREST];
    [loader sendSynchronously]; 
    [activityData.managedObjectContext deleteObject:activityData];

    NSLog(@"Sended ActivityData synchron to server: %@.",activityData);
}

@end
