//
//  Challenge.m
//  ChallengeEarthIClient
//
//  Created by Administrator on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Challenge.h"
#import "Position.h"
#import "AchievmentDescription.h"
#import "Category.h"


@implementation Challenge
@synthesize challengeId;
@synthesize title;
@synthesize category;
@synthesize description;
@synthesize difficulty;
@synthesize achievmentDesc;
@synthesize startPosition;



+(RKObjectMapping*)getMappingForREST
{
    RKObjectMapping* objectMapping = [RKObjectMapping mappingForClass:[Challenge class]];
    [objectMapping mapKeyPath:@"challengeId" toAttribute:@"challengeId"];
    [objectMapping mapKeyPath:@"title" toAttribute:@"title"];
    [objectMapping mapKeyPath:@"description" toAttribute:@"description"];

    [objectMapping mapRelationship:@"startPosition" withMapping:[Position getMappingForREST]];
    [objectMapping mapRelationship:@"achievmentDesc" withMapping:[AchievmentDescription getMappingForREST]];
    [objectMapping mapRelationship:@"category" withMapping:[Category getMappingForREST]];

	return objectMapping;
}

+(void)setUpRoutes
{
    RKObjectRouter *router = [RKObjectManager sharedManager].router;
    
    [router routeClass:[Challenge class] toResourcePath:@"/challenge/:challengeId" forMethod:RKRequestMethodGET];
}

@end
