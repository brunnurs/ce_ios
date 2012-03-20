//
//  ceChallengeStatusController.m
//  iChallengeEarth
//
//  Created by Administrator on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ceChallengeStatusController.h"
#import "ceChallengeDetailController.h"
#import "ShowTimeHelper.h"
#import "Progress.h"
#import "Challenge.h"
#import "ChallengeAttempt.h"
#import "LocationTrackingController.h"

@implementation ceChallengeStatusViewController
@synthesize refreshTimer;
@synthesize trackingController;

- (void)viewDidLoad 
{
    [super viewDidLoad];	
	[self initializeView];
   
    self.trackingController.challengeView = self;
    [trackingController startTracking];
}

-(void)viewDidAppear:(BOOL)animated
{
	//Update Tracking-Infos in 1 Second. Necessary because Tracking may not have started yet (Timer do not immediately start)
	self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshMe:) userInfo:nil repeats:YES];

}

-(void)viewDidDisappear:(BOOL)animated
{
	[self.refreshTimer invalidate];
	self.refreshTimer = nil;
}

-(void)initializeView
{
	challengeTitle.text = trackingController.currentChallengeAttempt.challenge.title;
	challengeStatus.text = @"Challenge zu 0% erfüllt";
	challengeProgress.progress = 0.0;
	challengeTime.text = @"0s";
}   

-(void)refreshMe:(NSTimer *)timer
{
	//Zoom and Center Map if auto-follow is on
	if ([autoFollowSwitch isOn]) 
	{
		MKCoordinateRegion region;
		
		region.center = mapView.userLocation.location.coordinate; 
		
		region.span.latitudeDelta = .005;
		region.span.longitudeDelta = .005;
		
		[mapView setRegion:region animated:YES];
	}
	
	//actualize Time
	challengeTime.text = [ShowTimeHelper getTimeFromSeconds:[trackingController.currentChallengeAttempt getElapsedTime]];
}


-(IBAction)cancelChallenge:(id)sender
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Challenge" 
													message:@"Wollen Sie diese Challenge wirklich beenden?"
												   delegate:self 
										  cancelButtonTitle:@"Ja" 
											  otherButtonTitles:@"Nein",nil];
	[alert show];
}

// ********* Cancel-Messagebox Delegate Method ************
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	//Stopp Challenge and go back to Overview
	if (buttonIndex == 0)
    {
        [self stopTrackingAndLeaveScreen];
    }
}

// *************** switch to the Detail-View ******************
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure we're referring to the correct segue
    if ([[segue identifier] isEqualToString:@"showFurtherDetails"]) {
        
        // Get reference to the destination view controller			
        ceChallengeDetailController *detailView = [segue destinationViewController];
        
        detailView.detailChallenge = trackingController.currentChallengeAttempt.challenge;
        detailView.allowStart = NO;
    }
}

-(void)stopTrackingAndLeaveScreen
{
    [self.trackingController stopTracking];
    [self.trackingController removeCurrentChallengeAttempt];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)positionUpdateWithConnectivity:(bool)hasConnectivity
{
    int pointCount = [lastUpdateLabel.text length];
    pointCount = ++pointCount % 4;
    
    NSString * pointString = [NSString new];
    for (int i = 0; i<pointCount; i++) {
        pointString = [NSString stringWithFormat:@"%@.",pointString];
    }
    lastUpdateLabel.text = pointString;
    
    NSString *pathConnectivityLED;
    if (hasConnectivity) 
    {
        pathConnectivityLED= [[NSBundle mainBundle]pathForResource:@"greenled" ofType:@"png"];
    }
    else
    {
        pathConnectivityLED = [[NSBundle mainBundle]pathForResource:@"yellowled" ofType:@"png"];
    }
	
    connectionStateIcon.image = [UIImage imageWithContentsOfFile:pathConnectivityLED];
}
	
-(void)challengeUpdated:(Progress*)newProgress;
{	
//    NSLog(@"%@",[NSString stringWithFormat:@"Progress-update: is %@ %% completed",newProgress.percentage]);
    challengeProgress.progress = [newProgress.percentage intValue] / 100.0f;
    
	if([newProgress.percentage intValue] < 100)
	{
		challengeStatus.text = [NSString stringWithFormat:@"Challenge zu %@ %% erfüllt",newProgress.percentage];
	}
	else
	{
        [trackingController stopTracking];
		challengeStatus.text = @"Glückwunsch! Challenge erfüllt!";
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Challenge beenden" style:UIBarButtonItemStylePlain target:self action:@selector(stopTrackingAndLeaveScreen)];
		[self.refreshTimer invalidate];
	}
}


@end
