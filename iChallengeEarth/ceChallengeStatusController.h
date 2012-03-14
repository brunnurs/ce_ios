//
//  ceChallengeStatusController.h
//  iChallengeEarth
//
//  Created by Administrator on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"
#import "TrackingControllerDelegate.h"

@class TrackingControllerDelegate;
@class LocationTrackingController;
@class Challenge;


@interface ceChallengeStatusViewController : UIViewController<UIAlertViewDelegate,MKMapViewDelegate,TrackingControllerDelegate>
{
    IBOutlet UILabel *challengeStatus;
    IBOutlet UILabel *challengeTitle;
    IBOutlet UILabel *challengeTime;
    IBOutlet UIProgressView *challengeProgress;
    IBOutlet MKMapView *mapView;

    IBOutlet UIImageView *connectionStateIcon;
    IBOutlet UILabel *lastUpdateLabel;
    IBOutlet UISwitch *autoFollowSwitch;

    LocationTrackingController *trackingController;
    NSTimer *refreshTimer;
}

@property (nonatomic,strong) NSTimer *refreshTimer;
@property (nonatomic,strong) LocationTrackingController *trackingController;

-(void)refreshMe:(NSTimer *)timer;
-(void)initializeView;
-(void)stopTrackingAndLeaveScreen;

-(IBAction)cancelChallenge:(id)sender;

@end
