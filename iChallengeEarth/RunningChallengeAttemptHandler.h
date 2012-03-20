//
//  ChallengeAttemptCrashHandler.h
//  iChallengeEarth
//
//  Created by Administrator on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@protocol RunningAttemptsHandlerDelegate
- (void)finishedUpdatingChallengeAttempts;
@end


@interface RunningChallengeAttemptHandler : NSObject <RKObjectLoaderDelegate,RKRequestDelegate>
{
    id<RunningAttemptsHandlerDelegate> delegateToInform;
    NSArray *runningChallengeAttempts;
}

@property (strong,nonatomic) NSArray *runningChallengeAttempts;
@property (strong,nonatomic) id<RunningAttemptsHandlerDelegate> delegateToInform; 

-(BOOL)areThereRunningChallengeAttempts;
-(void)reloadChallengesForRunningChallengeAttempts;



@end
