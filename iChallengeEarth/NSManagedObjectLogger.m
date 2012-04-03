//
//  NSManagedObjectLogger.m
//  iChallengeEarth
//
//  Created by Administrator on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSManagedObjectLogger.h"

@implementation NSManagedObjectLogger


+(void)logSavingError:(NSError*)error whenSaveFails:(bool)hasSaved
{
    if(!hasSaved)
    {
        NSDictionary *userInfo = [error userInfo];
        NSArray *errors = [userInfo valueForKey:@"NSDetailedErrors"];
        if (errors) {
            for (NSError *detailedError in errors) {
                NSDictionary *subUserInfo = [detailedError userInfo];
                NSLog(@"Core Data Save Error\n \
                      NSLocalizedDescription:\t\t%@\n \
                      NSValidationErrorKey:\t\t\t%@\n \
                      NSValidationErrorPredicate:\t%@\n \
                      NSValidationErrorObject:\n%@\n",
                      [subUserInfo valueForKey:@"NSLocalizedDescription"], 
                      [subUserInfo valueForKey:@"NSValidationErrorKey"], 
                      [subUserInfo valueForKey:@"NSValidationErrorPredicate"], 
                      [subUserInfo valueForKey:@"NSValidationErrorObject"]);
            }
        }
        else {
            NSLog(@"Core Data Save Error\n \
                  NSLocalizedDescription:\t\t%@\n \
                  NSValidationErrorKey:\t\t\t%@\n \
                  NSValidationErrorPredicate:\t%@\n \
                  NSValidationErrorObject:\n%@\n", 
                  [userInfo valueForKey:@"NSLocalizedDescription"],
                  [userInfo valueForKey:@"NSValidationErrorKey"], 
                  [userInfo valueForKey:@"NSValidationErrorPredicate"], 
                  [userInfo valueForKey:@"NSValidationErrorObject"]);
        }
    }
}

@end
