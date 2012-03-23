//
//  ChallengeAttempt.h
//  iChallengeEarth
//
//  Created by Administrator on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AttemptHash;
@class Challenge;

@interface ChallengeAttempt : NSManagedObject
{
    AttemptHash *attemptHash;
    NSDate *startDate;
    
    Challenge *challenge;
}

@property (strong,nonatomic) AttemptHash *attemptHash;
@property (nonatomic,strong) NSDate *startDate;
@property (nonatomic,strong) Challenge *challenge;

-(void)initializeNewHashWithChallenge:(Challenge *)chall;
-(long)getElapsedTime;

@end
