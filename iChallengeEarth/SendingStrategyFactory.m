//
//  SendingStrategyFactory.m
//  iChallengeEarth
//
//  Created by Administrator on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SendingStrategyFactory.h"
#import "SendingStrategy.h"

@implementation SendingStrategyFactory
@synthesize backgroundStrategy;
@synthesize foregroundStrategy;


-(id)init
{
    self = [super init];
	if(!self)
		return nil;

    self.backgroundStrategy = [[BackgroundSendingStrategy alloc]init];
    self.foregroundStrategy = [[ForegroundSendingStrategy alloc]init];
    
	return self;
}

-(SendingStrategy*)getSendingStrategyByBackgroundForeground:(bool)isInBackground withCallbackHandler:(LocationRKCallbackHandler*)callbackHandler
{
    if(isInBackground)
    {
        backgroundStrategy.callbackHandler = callbackHandler;
        return backgroundStrategy;
    }
    else
    {
        foregroundStrategy.callbackHandler = callbackHandler;
        return foregroundStrategy;
    }
    
}

@end
