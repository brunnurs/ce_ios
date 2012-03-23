//
//  ceRunningChallengesController.m
//  iChallengeEarth
//
//  Created by Administrator on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ceRunningChallengesController.h"
#import "Challenge.h"
#import "ChallengeList.h"
#import "ChallengeAttempt.h"
#import "ChallengeAttemptCell.h"
#import "AchievmentDescription.h"
#import "Category.h"
#import "Image.h"
#import "ceChallengeStatusController.h"
#import "LocationTrackingController.h"

@implementation ceRunningChallengesController
@synthesize runningChallengeHandler;
@synthesize dateFormatter;

-(void)viewDidLoad
{   
    
    self.dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm"];
    
    self.runningChallengeHandler = [[RunningChallengeAttemptHandler alloc]init];
    runningChallengeHandler.delegateToInform = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.runningChallengeHandler reloadChallengesForRunningChallengeAttempts];
    NSLog(@"found %d running attempts. Reload the Challenge-detailinformation from server",self.runningChallengeHandler.runningChallengeAttempts.count);
    
    [runningChallengesTable reloadData];
}

- (void)finishedUpdatingChallengeAttempts
{
    [runningChallengesTable reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [runningChallengeHandler.runningChallengeAttempts count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    
	ChallengeAttempt *challengeAttempt = [runningChallengeHandler.runningChallengeAttempts objectAtIndex:indexPath.row];
    Challenge *currentChallenge = challengeAttempt.challenge;
	
	ChallengeAttemptCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChallengeAttemptCell"];
	
    cell.challengeImage.image = currentChallenge.achievmentDesc.image.realImage;
	cell.attemptStartTime.text = [self.dateFormatter stringFromDate:challengeAttempt.startDate];
	cell.challengeTitle.text = currentChallenge.title;
	cell.challengeCategorie.text = currentChallenge.category.title;
    
	return cell;
}


// *************** switch to Status-View ******************
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure we're referring to the correct segue
    if ([[segue identifier] isEqualToString:@"resumeChallenge"]) {
        
        // Get reference to the destination view controller
        ceChallengeStatusViewController *statusView = [segue destinationViewController];
        
        ceAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        LocationTrackingController *trackingController = delegate.trackingController;

        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [runningChallengesTable indexPathForCell:cell];
        
        ChallengeAttempt *selectedChallengeAttempt = [self.runningChallengeHandler.runningChallengeAttempts objectAtIndex:indexPath.row];

        [trackingController initializeChallengeAttempt:selectedChallengeAttempt];
        
        statusView.trackingController = trackingController;
    }
}

@end
