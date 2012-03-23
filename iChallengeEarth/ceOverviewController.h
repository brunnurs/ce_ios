//
//  ceOverviewController.h
//  iChallengeEarth
//
//  Created by Administrator on 12/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ChallengeList.h"
#import <RestKit/RestKit.h>

@interface ceOverviewController : UIViewController<UITableViewDataSource,RKObjectLoaderDelegate,RKRequestDelegate>{
    ChallengeList *challenges;
    IBOutlet MKMapView *mapView;
    IBOutlet UITableView *challengeTable;
    
    NSTimer *refreshTimer;
    int timerTicks; 
}

@property (nonatomic,strong) NSTimer *refreshTimer;
@property (nonatomic,strong) ChallengeList *challenges;
@property int timerTicks;

-(void)showChallengesAsPins;
-(void)refreshPositionOnMap:(NSTimer*)timer;

@end
