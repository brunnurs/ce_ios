    //
//  Challenge.h
//  ChallengeEarthIClient
//
//  Created by Administrator on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <Foundation/Foundation.h>

@class Position;
@class AchievmentDescription;
@class Category;

@interface Challenge : NSObject 
{
	NSNumber *challengeId;
	NSString *title;
	Category *category;
	NSString *description;
	AchievmentDescription *achievmentDesc;
    Position *startPosition;
	
	int difficulty;
}

@property (nonatomic,strong) NSNumber *challengeId;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) Category *category;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) AchievmentDescription *achievmentDesc;
@property (nonatomic,strong) Position *startPosition;
@property int difficulty;

+(RKObjectMapping*)getMappingForREST;
+(void)setUpRoutes;

@end
