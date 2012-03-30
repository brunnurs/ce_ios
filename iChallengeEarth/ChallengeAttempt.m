//
//  ChallengeAttempt.m
//  iChallengeEarth
//
//  Created by Administrator on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChallengeAttempt.h"
#import "AttemptHash.h"
#import "Challenge.h"


@implementation ChallengeAttempt
@dynamic attemptHash;
@dynamic startDate;
@synthesize challenge;



-(void)initializeNewHashWithChallenge:(Challenge *)chall
{
    self.challenge = chall;
    
    self.attemptHash = [AttemptHash object];
    self.attemptHash.challengeId = chall.challengeId;
    
    [self.attemptHash createNewAttemptHash];
    
    NSError* error;
    BOOL hasSaved = [self.managedObjectContext save:&error];
    NSLog(@"Created and saved new ChallengeAttempt with new Attempt Hash. %@ has saved: (%@)",self.attemptHash,(hasSaved) ? @"YES" : @"NO");
}



-(long)getElapsedTime
{
	if(self.startDate > 0)  
	{
		NSDate *now = [NSDate date];
		return [now timeIntervalSince1970] - [self.startDate timeIntervalSince1970];
	}
	else 
		return -1;
}

@end
