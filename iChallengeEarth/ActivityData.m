//
//  ActivityData.m
//  iChallengeEarth
//
//  Created by Administrator on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivityData.h"


@implementation ActivityData

@dynamic accuracy;
@dynamic altitude;
@dynamic dateTime;
@dynamic image;
@dynamic latitude;
@dynamic longitude;
@dynamic toRemove;
@dynamic userId;
@dynamic velocity;
@dynamic attemptHashs;


-(void)initializeLocation:(CLLocation*)location 
{	
    self.toRemove = [NSNumber numberWithBool:NO];
	self.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
	self.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
	self.velocity = [NSNumber numberWithDouble:location.speed];
	self.accuracy = [NSNumber numberWithDouble:location.horizontalAccuracy];
	self.altitude = [NSNumber numberWithDouble:location.altitude];
	NSDate *currentDate = [NSDate date];
	self.dateTime = [NSNumber numberWithLongLong:[currentDate timeIntervalSince1970] * 1000];
}

- (NSString *)description 
{
    NSString *log = [NSString stringWithFormat:@"ActivityData: [userId: %@, dateTime: %@, longitude: %@, latitude: %@]",self.userId,self.dateTime,self.longitude,self.latitude];
    
    if(self.attemptHashs.count > 0){
        NSArray *attemptHashs = [self.attemptHashs allObjects];
        AttemptHash *firstObject = [attemptHashs objectAtIndex:0];
        log = [NSString stringWithFormat:@"%@. First attemptHash: %@",log,firstObject];
    }
    return log;
}


+(RKManagedObjectMapping*)getMappingForREST
{
    RKManagedObjectMapping* objectMapping = [RKManagedObjectMapping mappingForClass:[ActivityData class] inManagedObjectStore:[RKObjectManager sharedManager].objectStore];
    [objectMapping mapKeyPath:@"accuracy" toAttribute:@"accuracy"];
    [objectMapping mapKeyPath:@"altitude" toAttribute:@"altitude"];
    [objectMapping mapKeyPath:@"dateTime" toAttribute:@"dateTime"];
    [objectMapping mapKeyPath:@"latitude" toAttribute:@"latitude"];
    [objectMapping mapKeyPath:@"longitude" toAttribute:@"longitude"];
    [objectMapping mapKeyPath:@"userId" toAttribute:@"userId"];
    [objectMapping mapKeyPath:@"image" toAttribute:@"image"];
    [objectMapping mapKeyPath:@"velocity" toAttribute:@"velocity"];
    [objectMapping mapKeyPath:@"challengeId" toRelationship:@"attemptHashs" withMapping:[AttemptHash getMappingForREST]];
    
    //TODO: not very intelligent; the "real" pk is stored in the nested Object AttemptHash
    objectMapping.primaryKeyAttribute = @"dateTime";
    
	return objectMapping;
}


+(void)setUpRoutes
{
    RKObjectRouter *router = [RKObjectManager sharedManager].router;
    
    [router routeClass:[ActivityData class] toResourcePath:@"/challenge" forMethod:RKRequestMethodPOST];
}



@end
