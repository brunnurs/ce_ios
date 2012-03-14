//
//  AttemptHash.h
//  iChallengeEarth
//
//  Created by Administrator on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>

@class ActivityData;

@interface AttemptHash : NSManagedObject

@property (nonatomic, retain) NSString * attemptHash;
@property (nonatomic, retain) NSNumber * challengeId;
@property (nonatomic, retain) NSSet *activityDatas;

+(RKManagedObjectMapping*)getMappingForREST;

-(void)createNewAttemptHash;
//-(AttemptHash*)cloneMe;
-(NSString *)description;

@end

@interface AttemptHash (CoreDataGeneratedAccessors)

- (void)addActivityDatasObject:(ActivityData *)value;
- (void)removeActivityDatasObject:(ActivityData *)value;
- (void)addActivityDatas:(NSSet *)values;
- (void)removeActivityDatas:(NSSet *)values;
@end


