//
//  Progress.m
//  iChallengeEarth
//
//  Created by Administrator on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Progress.h"
#import "AttemptHash.h"

@implementation Progress
@synthesize percentage;
@synthesize attemptHash;
@synthesize userId;

+(RKObjectMapping*)getMappingForREST
{
    RKObjectMapping* objectMapping = [RKObjectMapping mappingForClass:[Progress class]];
    [objectMapping mapKeyPath:@"progress" toAttribute:@"percentage"];
    
	return objectMapping;
}

- (NSString *)description 
{
    NSString *log = [NSString stringWithFormat:@"Progress:[percentage: %@, userId: %@, AttemptHash: %@]",self.percentage,self.userId,self.attemptHash];
    return log;
}

+(void)setUpRoutes
{
    RKObjectRouter *router = [RKObjectManager sharedManager].router;
    
    [router routeClass:[Progress class] toResourcePath:@"/progress/:attemptHash.challengeId/:userId/:attemptHash.attemptHash" forMethod:RKRequestMethodGET];
}

@end
