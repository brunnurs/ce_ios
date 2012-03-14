//
//  AdressAnnotation.m
//  iChallengeEarth
//
//  Created by Administrator on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AdressAnnotation.h"

@implementation AddressAnnotation
@synthesize coordinate;
@synthesize challengeTitle;

- (NSString *)subtitle
{
	return nil;
}

- (NSString *)title
{
	return challengeTitle;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c
{
	coordinate=c;
	return self;
}

@end