//
//  Image.m
//  iChallengeEarth
//
//  Created by Administrator on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Image.h"

@implementation Image
@synthesize fileName;
@synthesize filePath;
@synthesize realImage;

+(RKObjectMapping*)getMappingForREST
{
    RKObjectMapping* imageMapping = [RKObjectMapping mappingForClass:[Image class]];
    [imageMapping mapKeyPath:@"fileName" toAttribute:@"fileName"];
    [imageMapping mapKeyPath:@"filePath" toAttribute:@"filePath"];
    
	return imageMapping;
}

-(NSURL*)getURLToRemoteImage
{
    NSLog(@"%@/%@/%@", BASEURL, filePath, fileName);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@", BASEURL, filePath, fileName]];

    return url;
}


-(void)loadImage{
    NSLog(@"%@/%@/%@", BASEURL, filePath, fileName);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@", BASEURL, filePath, fileName]];
    self.realImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]]; 
}

@end
