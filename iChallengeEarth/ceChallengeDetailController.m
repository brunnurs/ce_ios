//
//  ceChallengeDetailController.m
//  iChallengeEarth
//
//  Created by Administrator on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ceChallengeDetailController.h"
#import "ceChallengeStatusController.h"
#import "LocationTrackingController.h"
#import "Category.h"
#import "AchievmentDescription.h"
#import "Image.h"

@implementation ceChallengeDetailController
@synthesize detailChallenge;
@synthesize allowStart;


- (void)viewDidLoad
{
    [super viewDidLoad]; 
    [self updateValues];
    
    if(!allowStart)
    {
        self.navigationItem.rightBarButtonItems = nil;
    }
}

-(void)updateValues
{
	cTitle.text = detailChallenge.title;
	description.text = detailChallenge.description;
	category.text = detailChallenge.category.title;
    achievement.image = detailChallenge.achievmentDesc.image.realImage;
		
	NSString *pathLED;
	NSString *diffLabel;
	switch (detailChallenge.difficulty) 
	{
		case 1:
			pathLED= [[NSBundle mainBundle]pathForResource:@"greenled" ofType:@"png"];
			diffLabel = @"einfach";
			break;
		case 2:
			pathLED = [[NSBundle mainBundle]pathForResource:@"yellowled" ofType:@"png"];
			diffLabel = @"mittel";
			break;
		case 3:
			pathLED = [[NSBundle mainBundle]pathForResource:@"redled" ofType:@"png"];
			diffLabel = @"schwer";
			break;
		default:
            pathLED= [[NSBundle mainBundle]pathForResource:@"greenled" ofType:@"png"];
			diffLabel = @"unknown";
			break;
	}
	
	difficultyIcon.image = [UIImage imageWithContentsOfFile:pathLED];
	difficultyLabel.text = diffLabel;
}

// *************** switch to the Detail-View ******************
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure we're referring to the correct segue
    if ([[segue identifier] isEqualToString:@"startChallenge"]) {
        
        // Get reference to the destination view controller
        ceChallengeStatusViewController *statusView = [segue destinationViewController];
        LocationTrackingController *trackingController = [[LocationTrackingController alloc]initWithChallenge:detailChallenge];

        statusView.trackingController = trackingController;
    }
}

@end
