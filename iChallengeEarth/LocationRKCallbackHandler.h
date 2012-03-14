//
//  LocationRKCallbackHandler.h
//  iChallengeEarth
//
//  Created by Administrator on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "Progress.h"
#import "TrackingControllerDelegate.h"

@class LocationTrackingController;

@interface LocationRKCallbackHandler : NSObject<RKObjectLoaderDelegate,RKRequestDelegate>
{
    bool askForProgressAfterActivitySent;
    Progress *currentProgress;    
    id <TrackingControllerDelegate> challengeView;
    
    LocationTrackingController *trackingController;
}

@property bool askForProgressAfterActivitySent;
@property (nonatomic,strong) Progress *currentProgress;
@property (nonatomic,strong) id <TrackingControllerDelegate> challengeView;
@property (nonatomic,strong) LocationTrackingController *trackingController;

-(id)initWithTrackingController:(LocationTrackingController *)controller;
-(void)askForCurrentProgress;

@end
