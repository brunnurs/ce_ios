//
//  ForegroundSendingStrategy.h
//  iChallengeEarth
//
//  Created by Administrator on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendingStrategy.h"

@class LocationRKCallbackHandler;
@class ActivityData;

@interface ForegroundSendingStrategy : NSObject <SendingStrategy>

@property (strong,nonatomic) LocationRKCallbackHandler *callbackHandler;

//private methods
-(void)postActivityDataAsynchronousToServer:(ActivityData *)activityData;
-(bool)shouldWeAskForProgress:(int)currentIndex whenActivityDataCount:(int)activityDataCount;
-(ActivityData*)createNewActivityData:(CLLocation*)newLocation withChallengeAttempt:(ChallengeAttempt*)currentChallengeAttempt;
-(void)postCachedAndTheNewActivityToServer;
-(void)saveToDatabase:(ActivityData *)activityData;

@end
