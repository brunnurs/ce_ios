//
//  Position.h
//  iChallengeEarth
//
//  Created by Administrator on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <RestKit/RestKit.h>

@interface Position : NSObject 
{
	CLLocationCoordinate2D coordinate;
}

@property double longitude;
@property double latitude;

-(CLLocationCoordinate2D)getAsCoordinate;

+(RKObjectMapping*)getMappingForREST;
@end
