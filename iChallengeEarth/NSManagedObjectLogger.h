//
//  NSManagedObjectLogger.h
//  iChallengeEarth
//
//  Created by Administrator on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSManagedObjectLogger : NSObject

+(void)logSavingError:(NSError*)error whenSaveFails:(bool)hasSaved;
@end
