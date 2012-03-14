//
//  AttemptHash.m
//  iChallengeEarth
//
//  Created by Administrator on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AttemptHash.h"


@implementation AttemptHash

@dynamic attemptHash;
@dynamic challengeId;
@dynamic activityDatas;

-(void)createNewAttemptHash
{
    // create a new UUID which representates a unique-identifier for this challenge-attempt
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    self.attemptHash = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
}

- (NSString *)description 
{
    NSString *log = [NSString stringWithFormat:@"AttemptHash: [challengeId: %@, attemptHash: %@]",self.challengeId,self.attemptHash];
    return log;
}

//-(AttemptHash*)cloneMe
//{
//    AttemptHash *newAttHash = [AttemptHash object];
//    newAttHash.challengeId = self.challengeId;
//    newAttHash.attemptHash = self.attemptHash;
//    newAttHash.activityDatas = nil;
//    return newAttHash;
//}



+(RKManagedObjectMapping*)getMappingForREST
{
    RKManagedObjectMapping* objectMapping = [RKManagedObjectMapping mappingForClass:[AttemptHash class]];
    [objectMapping mapKeyPath:@"attemptHash" toAttribute:@"attemptHash"];
    [objectMapping mapKeyPath:@"challengeId" toAttribute:@"challengeId"];
    
    objectMapping.primaryKeyAttribute = @"attemptHash";
    
	return objectMapping;
}

@end
