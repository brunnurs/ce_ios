//
//  TrackingControllerDelegate.h
//  iChallengeEarth
//
//  Created by Administrator on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TrackingControllerDelegate.h"
#import <UIKit/UIKit.h>
#import "Progress.h"

//have to be implemented by an object wich want's to be called by a TrackingController
@protocol TrackingControllerDelegate
@required
//challenge-attempt has been updated on the Server
-(void)challengeUpdated:(Progress*)newProgress;
-(void)positionUpdateWithConnectivity:(bool)hasConnectivity;

@end