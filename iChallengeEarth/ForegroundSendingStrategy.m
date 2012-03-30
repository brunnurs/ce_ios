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


//we don't need much code here because we're derived from SendingStrategy
@implementation ForegroundSendingStrategy 


-(void)postActivityDataToServer:(ActivityData*)activityData
{
    [[RKObjectManager sharedManager] postObject:activityData mapResponseWith:[ActivityData getMappingForREST] delegate:callbackHandler];
    NSLog(@"Sended ActivityData asynchron to server: %@.",activityData);

}

-(bool)isBackgroundStrategy
{
    return false;
}


@end
