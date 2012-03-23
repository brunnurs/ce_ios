//
//  LocationTrackingController.h
//  iChallengeEarth
//
//  Created by Administrator on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <RestKit/RestKit.h>
#import "TrackingControllerDelegate.h"



@class Progress;
@class Challenge;
@class ChallengeAttempt;
@class TrackingControllerDelegate;
@class LocationRKCallbackHandler;
@class ActivityData;
@class SendingStrategyFactory;

@interface LocationTrackingController : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    LocationRKCallbackHandler *callbackHandler;
    ChallengeAttempt *currentChallengeAttempt;
    SendingStrategyFactory *sendingStrategyFactory;
    bool isInBackgroundMode;
}

@property (nonatomic,strong) LocationRKCallbackHandler *callbackHandler;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) ChallengeAttempt *currentChallengeAttempt;
@property (nonatomic,strong) id <TrackingControllerDelegate> challengeView;
@property (nonatomic,strong) SendingStrategyFactory *sendingStrategyFactory;
@property float distanceFilter;
@property bool isInBackgroundMode;


-(void)initializeNewChallengeAttemptWithChallenge:(Challenge*)challenge;
-(void)initializeChallengeAttempt:(ChallengeAttempt*)challengeAttempt;
-(void)startTracking;
-(void)stopTracking;
-(void)removeCurrentChallengeAttempt;
-(BOOL)askSpontaneousForProgress;


//private methods
-(void)postActivityDataSynchronousToServer:(ActivityData *)activityData;
-(void)postActivityDataAsynchronousToServer:(ActivityData *)activityData;
-(bool)shouldWeAskForProgress:(int)currentIndex whenActivityDataCount:(int)activityDataCount;
-(ActivityData*)createNewActivityData:(CLLocation*)newLocation;
-(void)postCachedAndTheNewActivityToServer;
-(void)saveToDatabase:(ActivityData *)activityData;

@end
