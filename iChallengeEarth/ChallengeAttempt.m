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
@synthesize attemptHash;
@synthesize startDate;
@synthesize challenge;


-(id)initWithNewHashAndChallenge:(Challenge *)chall;
{
    self = [super init];
	if(!self)
		return nil;
	
    self.challenge = chall;
    
    self.attemptHash = [AttemptHash object];
    self.attemptHash.challengeId = chall.challengeId;
    
    [self.attemptHash createNewAttemptHash];
  
    NSError* error;
    BOOL hasSaved = [self.attemptHash.managedObjectContext save:&error];
    NSLog(@"Created and saved new Attempt Hash. %@ has saved: (%@)",self.attemptHash,(hasSaved) ? @"YES" : @"NO");

	return self;    
}


-(long)getElapsedTime
{
	if(startDate > 0)
	{
		NSDate *now = [NSDate date];
		return [now timeIntervalSince1970] - [startDate timeIntervalSince1970];
	}
	else 
		return -1;
}

@end
