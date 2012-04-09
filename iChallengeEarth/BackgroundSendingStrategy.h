//
//  BackgroundSendingStrategy.h
//  iChallengeEarth
//
//  Created by Administrator on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendingStrategy.h"

@class LocationRKCallbackHandler;
@class ActivityData;
@class ChallengeAttempt;

@interface BackgroundSendingStrategy : SendingStrategy



-(void)removeActivityDataFromDB:(ActivityData*)toRemove;


@end
