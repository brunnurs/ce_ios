//
//  ChallengeAttemptCrashHandler.m
//  iChallengeEarth
//
//  Created by Administrator on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RunningChallengeAttemptHandler.h"
#import "RestKit/RestKit.h"
#import "ChallengeAttempt.h"
#import "ChallengeList.h"
#import "Challenge.h"
#import "AttemptHash.h"
#import "AchievmentDescription.h"
#import "Image.h"


@implementation RunningChallengeAttemptHandler
@synthesize runningChallengeAttempts;
@synthesize delegateToInform;

-(BOOL)areThereRunningChallengeAttempts
{   
    self.runningChallengeAttempts = [ChallengeAttempt allObjects];

    
    if(runningChallengeAttempts.count == 0)
    {
        return false;
    }
    else
    {
        return true;
    }
}

-(void)reloadChallengesForRunningChallengeAttempts
{
    self.runningChallengeAttempts = [ChallengeAttempt allObjects];
    
    for (ChallengeAttempt *attempt in runningChallengeAttempts) {
        Challenge *challenge = [[Challenge alloc]init];
        challenge.challengeId = attempt.attemptHash.challengeId;
        attempt.challenge = challenge;
        
        [[RKObjectManager sharedManager] getObject:challenge mapResponseWith:[Challenge getMappingForREST] delegate:self];
    }
}


// ************ RestKit-Callback *************
-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object{
    if([object class] == [Challenge class])
    {
        //We don't have to reassign the loaded object, because the Challenge is allready connected to the ChallengeAttempt
        Challenge *challenge = (Challenge*)object;
        [challenge.achievmentDesc.image loadImage];
        
        //inform a delegate (normaly a view) about the changes
        [delegateToInform finishedUpdatingChallengeAttempts];
    }
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{  
    NSLog(@"gesendet: %@",[request HTTPBodyString]);
	NSLog(@"empfangen: %@",[response bodyAsString]);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Huston, we got a problem! %@",error);
}

@end
