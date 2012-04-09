//
//  ForegroundSendingStrategy.m
//  iChallengeEarth
//
//  Created by Administrator on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ForegroundSendingStrategy.h"
#import "ActivityData.h"
#import "LocationRKCallbackHandler.h"
#import "LocationTrackingController.h"


//we don't need much code here because we're derived from SendingStrategy
@implementation ForegroundSendingStrategy 


-(void)postActivityDataToServer:(ActivityData*)activityData
{
    [[RKObjectManager sharedManager] postObject:activityData mapResponseWith:[ActivityData getMappingForREST] delegate:locationTrackingController.callbackHandler];
    NSLog(@"Sended ActivityData asynchron to server: %@.",activityData);

}

-(bool)sendToServer:(CLLocation*)newLocation
{
    bool connectivity = [super sendToServer:newLocation];
    [locationTrackingController.callbackHandler.challengeView positionUpdateWithConnectivity:connectivity];
    
    return connectivity;
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


@end
