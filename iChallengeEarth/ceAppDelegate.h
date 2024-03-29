//
//  ceAppDelegate.h
//  iChallengeEarth
//
//  Created by Administrator on 12/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


//Basic-URL for the REST-Interface
static NSString *BASEURL_REST = @"http://192.168.135.137:8080/com.challengeEarth_ChallengeEarth_war_1.0-SNAPSHOT/rest";
static NSString *BASEURL = @"http://192.168.135.137:8080/com.challengeEarth_ChallengeEarth_war_1.0-SNAPSHOT";
static long USERID = 1;

@class LocationTrackingController;

@interface ceAppDelegate : UIResponder <UIApplicationDelegate>{
    LocationTrackingController *trackingController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LocationTrackingController *trackingController;

@end
