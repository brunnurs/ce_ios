//
//  ShowTimeHelper.m
//  iChallengeEarth
//
//  Created by Administrator on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShowTimeHelper.h"

@implementation ShowTimeHelper


+(NSString*)getTimeFromSeconds:(int)secs
{
    NSString *result = @"";
	
    // Int variables for calculation.
    int tempHour    = 0;
    int tempMinute  = 0;
    int tempSecond  = 0;
	
    NSString *hour      = @"";
    NSString *minute    = @"";
    NSString *second    = @"";
	
    // Convert the seconds to hours, minutes and seconds.
    tempHour    = secs / 3600;
    tempMinute  = secs / 60 - tempHour * 60;
    tempSecond  = secs - (tempHour * 3600 + tempMinute * 60);
    
    hour    = [[NSNumber numberWithInt:tempHour] stringValue];
    minute  = [[NSNumber numberWithInt:tempMinute] stringValue];
    second  = [[NSNumber numberWithInt:tempSecond] stringValue];
    
    
    if (tempMinute == 0) 
        result = [NSString stringWithFormat:@"%@sec", second];
	else if (tempHour == 0)
        result = [NSString stringWithFormat:@"%@min %@sec",minute, second];
	else
		result = [NSString stringWithFormat:@"%@std %@min %@sec",hour, minute, second];
	
    return result;
	
}
@end
