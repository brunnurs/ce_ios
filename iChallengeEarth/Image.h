//
//  Image.h
//  iChallengeEarth
//
//  Created by Administrator on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "ceAppDelegate.h"

@interface Image : NSObject
{
    NSString *fileName;
    NSString *filePath;
    UIImage *realImage;
}

@property (nonatomic,strong) NSString *fileName;
@property (nonatomic,strong) NSString *filePath;
@property (nonatomic,strong) UIImage *realImage;

+(RKObjectMapping*)getMappingForREST;

-(void)loadImage;

@end
