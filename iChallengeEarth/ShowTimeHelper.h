//
//  ShowTimeHelper.h
//  iChallengeEarth
//
//  Created by Administrator on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowTimeHelper : NSObject

// Turns a second-Count into a well-readable Time-Span String
+(NSString*)getTimeFromSeconds:(int)secs;
@end
