//
//  AdressAnnotation.h
//  iChallengeEarth
//
//  Created by Administrator on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface AddressAnnotation : NSObject<MKAnnotation> 
{
	CLLocationCoordinate2D coordinate;
	NSString *challengeTitle;
}

@property (nonatomic,strong) NSString *challengeTitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c;

@end
