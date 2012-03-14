//
//  AchievmentDescription.m
//  iChallengeEarth
//
//  Created by Administrator on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AchievmentDescription.h"

@implementation AchievmentDescription
@synthesize image;

+(RKObjectMapping*)getMappingForREST
{
    RKObjectMapping* achievmentDescMapping = [RKObjectMapping mappingForClass:[AchievmentDescription class]];
    [achievmentDescMapping mapRelationship:@"image" withMapping:[Image getMappingForREST]];
    
	return achievmentDescMapping;
}

@end
