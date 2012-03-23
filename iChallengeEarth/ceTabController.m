//
//  ceTabController.m
//  iChallengeEarth
//
//  Created by Administrator on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ceTabController.h"


@implementation ceTabController

-(void)viewDidLoad
{
    NSString* pathToImageFile1 = [[NSBundle mainBundle] pathForResource:@"star" ofType:@"png"];
    UIImage *tabIcon1 = [UIImage imageWithContentsOfFile:pathToImageFile1];
    
    NSString* pathToImageFile2 = [[NSBundle mainBundle] pathForResource:@"graph" ofType:@"png"];
    UIImage *tabIcon2 = [UIImage imageWithContentsOfFile:pathToImageFile2];

    UITabBarItem *item1 = [self.tabBar.items objectAtIndex:0];
    [item1 setImage:tabIcon1];
    [item1 setTitle:@"new Challenges"];
    
    UITabBarItem *item2 = [self.tabBar.items objectAtIndex:1];
    [item2 setImage:tabIcon2];
    [item2 setTitle:@"running Challenges"];
}

@end