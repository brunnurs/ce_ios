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
@class LocationTrackingController;

//take care, this class is abstract!
@interface SendingStrategy : NSObject
{
    LocationTrackingController *locationTrackingController;
}

@property (strong,nonatomic) LocationTrackingController *locationTrackingController;


//methods u have to override

//The actual sending-call. Can, for example, be implemented synchronous or asynchronous
-(void)postActivityDataToServer:(ActivityData*)activityData;
//importent to decide if we have to call the server for current progress
-(bool)shouldWeAskForProgress:(int)currentIndex whenActivityDataCount:(int)activityDataCount;


//methods which can be overriden

//the entry-point for the sending process. Can be overriden to start it in a new thread, for example
-(bool)sendToServer:(CLLocation*)newLocation;



//private methods
-(ActivityData*)createNewActivityData:(CLLocation*)newLocation withChallengeAttempt:(ChallengeAttempt*)currentChallengeAttempt;
-(void)postCachedAndTheNewActivityToServer;
-(void)saveToDatabase:(ActivityData *)activityData;

@end
