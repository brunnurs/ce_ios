//
//  SendingStrategy.h
//  iChallengeEarth
//
//  Created by Administrator on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class ChallengeAttempt;

@protocol SendingStrategy <NSObject>
-(void)sendToServer:(CLLocation*)newLocation forChallengeAttempt:(ChallengeAttempt *)currentChallengeAttempt;
@end
