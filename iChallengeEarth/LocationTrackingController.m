//
//  LocationTrackingController.m
//  iChallengeEarth
//
//  Created by Administrator on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationTrackingController.h"
#import "ActivityData.h"
#import "Progress.h"
#import "Challenge.h"
#import "ChallengeAttempt.h"
#import "LocationRKCallbackHandler.h"
#import "ceAppDelegate.h"
#import "SendingStrategyFactory.h"
#import "SendingStrategy.h"

#include <stdlib.h>



@implementation LocationTrackingController
@synthesize locationManager;
@synthesize callbackHandler;
@synthesize currentChallengeAttempt;
@synthesize isInBackgroundMode;
@synthesize sendingStrategyFactory;

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
    
    self.sendingStrategyFactory = [[SendingStrategyFactory alloc]init];
    self.callbackHandler = [[LocationRKCallbackHandler alloc] initWithTrackingController:self];
    self.callbackHandler.askForProgressAfterActivitySent = YES;
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    locationManager.distanceFilter = 80.0f;
    
    self.isInBackgroundMode = false;

	return self;
}

-(void)initializeNewChallengeAttemptWithChallenge:(Challenge*)challenge
{
    ChallengeAttempt *newChallengeAttempt = [ChallengeAttempt object];
    [newChallengeAttempt initializeNewHashWithChallenge:challenge];
    self.currentChallengeAttempt = newChallengeAttempt;
}

-(void)initializeChallengeAttempt:(ChallengeAttempt*)challengeAttempt
{
    self.currentChallengeAttempt = challengeAttempt;

}

-(void)setChallengeView:(id <TrackingControllerDelegate>)challengeView
{
	self.callbackHandler.challengeView = challengeView;
}

-(id <TrackingControllerDelegate>)challengeView
{
	return self.callbackHandler.challengeView;
}


-(void)startTracking
{
    currentChallengeAttempt.startDate = [NSDate date];
    [locationManager startUpdatingLocation];
}

-(void)stopTracking
{
    [locationManager stopUpdatingLocation];
}

-(float)distanceFilter
{
	return locationManager.distanceFilter;
}

-(void)setDistanceFilter:(float)distance
{
	locationManager.distanceFilter = distance;
}

-(void)removeCurrentChallengeAttempt
{
    NSError* error;
    [currentChallengeAttempt.managedObjectContext deleteObject:currentChallengeAttempt];
    bool hasSaved = [currentChallengeAttempt.managedObjectContext save:&error];
    NSLog(@"Removed curentChallengeAttempt with AttemptHash. Save worked? (%@)",(hasSaved) ? @"YES" : @"NO");
    
    self.currentChallengeAttempt = nil;
}

-(BOOL)askSpontaneousForProgress
{
    if(self.currentChallengeAttempt != nil)
    {
        [callbackHandler askForCurrentProgress];
        return true;
    }
    else
    {
        return false;
    }
}


-(void)handlePositionUpdate:(CLLocation*)newLocation
{
    SendingStrategy* sendingStrategy = [sendingStrategyFactory getSendingStrategyByBackgroundForeground:isInBackgroundMode withLocationTrackingController:self];

    [sendingStrategy sendToServer:newLocation];
}


-(void)reloadCurrentChallengeAttempt
{
    if(self.currentChallengeAttempt != NULL)
    {
        NSManagedObjectContext *contextForCurrThread = [RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread;
        AttemptHash *reloadedAttemptHash = [AttemptHash findFirstByAttribute:@"attemptHash" withValue:currentChallengeAttempt.attemptHash.attemptHash inContext:contextForCurrThread];
        self.currentChallengeAttempt = reloadedAttemptHash.challengeAttempt;
        NSLog(@"Current Challenge %@ (attemptHash=%@) reloaded because of threading-issues",(self.currentChallengeAttempt != NULL) ? @"successfully" : @"NOT successfully!",currentChallengeAttempt.attemptHash.attemptHash);

    }
}



#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager 
	didUpdateToLocation:(CLLocation *)newLocation 
		   fromLocation:(CLLocation *)oldLocation
{
//    NSLog(@"New Position-Update: %@",newLocation);
    [self handlePositionUpdate:newLocation];
} 

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"got an error while position changed x%@",error);
}

@end
