//
//  Progress.h
//  iChallengeEarth
//
//  Created by Administrator on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@class AttemptHash;

@interface Progress : NSObject{
    NSNumber *percentage;
    AttemptHash *attemptHash;
    NSNumber *userId;
    
    
}

@property(nonatomic,strong) NSNumber *percentage;
@property(nonatomic,strong) AttemptHash *attemptHash;
@property(nonatomic,strong) NSNumber *userId;

+(RKObjectMapping*)getMappingForREST;
+(void)setUpRoutes;

@end
