//
//  Category.h
//  iChallengeEarth
//
//  Created by Administrator on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface Category : NSObject
{
	NSString *title;
	NSString *description;
}
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *description;

+(RKObjectMapping*)getMappingForREST;

@end
