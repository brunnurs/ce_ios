//
//  SendingStrategyFactory.h
//  iChallengeEarth
//
//  Created by Administrator on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ForegroundSendingStrategy.h"
#import "BackgroundSendingStrategy.h"
#import "SendingStrategy.h"

@interface SendingStrategyFactory : NSObject
{
    BackgroundSendingStrategy *backgroundStrategy;
    ForegroundSendingStrategy *foregroundStrategy;
}

@property (strong,nonatomic) BackgroundSendingStrategy *backgroundStrategy;
@property (strong,nonatomic) ForegroundSendingStrategy *foregroundStrategy;

-(id<SendingStrategy>)getSendingStrategyByBackgroundForeground:(bool)isForeground withCallbackHandler:(LocationRKCallbackHandler*)callbackHandler;

@end
