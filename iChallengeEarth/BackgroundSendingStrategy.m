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
#import "LocationTrackingController.h"

@implementation BackgroundSendingStrategy


-(void)postActivityDataToServer:(ActivityData*)activityData
{
    RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderForObject:activityData method:RKRequestMethodPOST delegate:nil];
    loader.targetObject = activityData;
    loader.objectMapping = [ActivityData getMappingForREST];
    RKResponse *response = [loader sendSynchronously]; 
    NSLog(@"Sended ActivityData synchron to server: %@.",activityData);
    
    
    //It's necessery to remove the data instantly, because otherwise we get in trouble with the different threads we start for every Server-call
    if([response statusCode] < 500)
    {
        [self removeActivityDataFromDB:activityData];
    }
    else
    {
        NSLog(@"We don't remove the ActivityData because we got an server-error");
    }
}

-(void)removeActivityDataFromDB:(ActivityData*)toRemove
{
    [toRemove.managedObjectContext deleteObject:toRemove];
    NSError* error;
    [toRemove.managedObjectContext save:&error];
    NSLog(@"Instantly removed the ActivityData \nerror:%@ | %@ | %@", error, [error userInfo],[error localizedDescription]);
    
}


-(bool)shouldWeAskForProgress:(int)currentIndex whenActivityDataCount:(int)count
{
    //  never, because we are in background-mode...
    return false;

}


-(bool)sendToServer:(CLLocation*)newLocation
{
    //IMPORTANT: if we send data triggered by a background-location-event, we have to use a synchronus-send, because the 
    //queue mechanism doesn't work there (the reason can be found in some of ursin's links). Despite of that, we can not use the
    //main-thread for this work, because when the network-call last too long, the app crashs (even if we don't block the GUI).
    //That's why we have to use here another Thread, where we make the synchronus call.
    //Rest-Kit normaly doesn't allow this, thats why we have to remove the Assert on RKObjectLoader.didFinishLoad.
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //We reload the core-data objects because NSManagedObject's and context are not threadsafe
        [locationTrackingController reloadCurrentChallengeAttempt];
        [super sendToServer:newLocation];
    });

    //TODO not realy correct, but we don't care atm...
    return true;
}




@end
