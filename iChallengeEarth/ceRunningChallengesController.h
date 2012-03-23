//
//  ceRunningChallengesController.h
//  iChallengeEarth
//
//  Created by Administrator on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunningChallengeAttemptHandler.h"

@interface ceRunningChallengesController : UIViewController<UITableViewDataSource,RunningAttemptsHandlerDelegate>
{
    IBOutlet UITableView *runningChallengesTable;
    RunningChallengeAttemptHandler *runningChallengeHandler;
    NSDateFormatter *dateFormatter;
}

@property (strong,nonatomic) RunningChallengeAttemptHandler *runningChallengeHandler;
@property (strong,nonatomic) NSDateFormatter *dateFormatter;

@end
