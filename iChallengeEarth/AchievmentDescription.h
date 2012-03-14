//
//  AchievmentDescription.h
//  iChallengeEarth
//
//  Created by Administrator on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"
#import <RestKit/RestKit.h>

@interface AchievmentDescription : NSObject
{
    Image *image;
}

@property (nonatomic,strong) Image *image;

+(RKObjectMapping*)getMappingForREST;

@end
