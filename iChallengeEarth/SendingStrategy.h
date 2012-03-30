//
//  SendingStrategy.h
//  iChallengeEarth
//
//  Created by Administrator on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class ChallengeAttempt;
@class LocationRKCallbackHandler;
@class ActivityData;

//take care, this class is abstract!
@interface SendingStrategy : NSObject
{
    LocationRKCallbackHandler *callbackHandler;
}

@property (strong,nonatomic) LocationRKCallbackHandler *callbackHandler;


//methods u have to override

//The actual sending-call. Can, for example, be implemented synchronous or asynchronous
-(void)postActivityDataToServer:(ActivityData*)activityData;
//simply to decide if we work in background/foreground
-(bool)isBackgroundStrategy;


//methods which can be overriden

//the entry-point for the sending process. Can be overriden to start it in a new thread, for example
-(void)sendToServer:(CLLocation*)newLocation forChallengeAttempt:(ChallengeAttempt *)currentChallengeAttempt;



//private methods
-(bool)shouldWeAskForProgress:(int)currentIndex whenActivityDataCount:(int)activityDataCount;
-(ActivityData*)createNewActivityData:(CLLocation*)newLocation withChallengeAttempt:(ChallengeAttempt*)currentChallengeAttempt;
-(void)postCachedAndTheNewActivityToServer;
-(void)saveToDatabase:(ActivityData *)activityData;

@end
