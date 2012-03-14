//
//  ActivityData.h
//  iChallengeEarth
//
//  Created by Administrator on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AttemptHash.h"


@interface ActivityData : NSManagedObject

@property (nonatomic, retain) NSNumber * accuracy;
@property (nonatomic, retain) NSNumber * altitude;
@property (nonatomic, retain) NSNumber * dateTime;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * toRemove;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * velocity;
@property (nonatomic, retain) NSSet *attemptHashs;


-(void)initializeLocation:(CLLocation*)location;
-(NSString *)description;

+(RKManagedObjectMapping*)getMappingForREST;
+(void)setUpRoutes;

@end

@interface ActivityData (CoreDataGeneratedAccessors)

- (void)addAttemptHashsObject:(AttemptHash *)value;
- (void)removeAttemptHashsObject:(AttemptHash *)value;
- (void)addAttemptHashs:(NSSet *)values;
- (void)removeAttemptHashs:(NSSet *)values;
@end
