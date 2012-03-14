//
//  Position.m
//  iChallengeEarth
//
//  Created by Administrator on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Position.h"

@implementation Position

-(CLLocationCoordinate2D)getAsCoordinate
{
	return coordinate;
}

-(void)setLongitude:(double)lon
{
	coordinate.longitude = lon;
}

-(double)longitude
{
	return coordinate.longitude;
}

-(void)setLatitude:(double)lat
{
	coordinate.latitude = lat;
}

-(double)latitude
{
	return coordinate.latitude;
}

+(RKObjectMapping*)getMappingForREST
{
    RKObjectMapping* positionMapping = [RKObjectMapping mappingForClass:[Position class]];
    [positionMapping mapKeyPath:@"latitude" toAttribute:@"latitude"];
    [positionMapping mapKeyPath:@"longitude" toAttribute:@"longitude"];
    
	return positionMapping;
}


@end
