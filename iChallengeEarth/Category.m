//
//  Category.m
//  iChallengeEarth
//
//  Created by Administrator on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Category.h"

@implementation Category
@synthesize title;
@synthesize description;

+(RKObjectMapping*)getMappingForREST
{
    RKObjectMapping* objectMapping = [RKObjectMapping mappingForClass:[Category class]];
    [objectMapping mapKeyPath:@"title" toAttribute:@"title"];
    [objectMapping mapKeyPath:@"description" toAttribute:@"description"];

	return objectMapping;
}

@end
