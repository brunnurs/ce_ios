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


-(void)postActivityDataToServer:(ActivityData*)activityData
{
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderForObject:activityData method:RKRequestMethodPOST delegate:callbackHandler];
    loader.targetObject = activityData;
    loader.objectMapping = [ActivityData getMappingForREST];
    [loader sendSynchronously]; 
    
    NSLog(@"Sended ActivityData synchron to server: %@.",activityData);

}

-(bool)isBackgroundStrategy
{
    return true;
}


-(void)sendToServer:(CLLocation*)newLocation forChallengeAttempt:(ChallengeAttempt *)currentChallengeAttempt
{
    //IMPORTANT: if we send data triggered by a background-location-event, we have to use a synchronus-send, because the 
    //queue mechanism doesn't work there (the reason can be found in some of ursin's links). Despite of that, we can not use the
    //main-thread for this work, because when the network-call last too long, the app crashs (even if we don't block the GUI).
    //That's why we have to use here another Thread, where we make the synchronus call.
    //Rest-Kit normaly doesn't allow this, thats why we have to remove the Assert on RKObjectLoader.didFinishLoad.
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
        [super sendToServer:newLocation forChallengeAttempt:currentChallengeAttempt];
    });

}




@end
