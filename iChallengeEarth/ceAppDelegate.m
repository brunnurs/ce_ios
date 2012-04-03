//
//  ceAppDelegate.m
//  iChallengeEarth
//
//  Created by Administrator on 12/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ceAppDelegate.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "Challenge.h"
#import "ActivityData.h"
#import "Progress.h"
#import "LocationTrackingController.h"

@implementation ceAppDelegate

@synthesize window = _window;
@synthesize trackingController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupRestKit];
    
    self.trackingController = [[LocationTrackingController alloc]init];
    
    return YES;
}


-(void)setupRestKit
{
    // initiate base-url
    NSLog(@"BaseUrl: %@",BASEURL_REST);
    RKObjectManager* manager = [RKObjectManager managerWithBaseURLString:BASEURL_REST];
    
    // Enable automatic network activity indicator management
    manager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    // make Restkit working with core data to save objects, if we have no connection.
    manager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"iChallengeEarth.sqlite"];
    
    //Set serialize-mime to mime-type json (standard would be formURLEncoded!)
    [RKObjectManager sharedManager].serializationMIMEType = RKMIMETypeJSON;
    
    //load routes for all classes which are used for RestKit calls
    [Challenge setUpRoutes];
    [ActivityData setUpRoutes];
    [Progress setUpRoutes];
    
    
    //load all serializing-mappings(important to understand, not the same as deserializing-mappings!)for the Restkit MappingProvider
    RKObjectMapping* activityDataSerializationMapping = [[ActivityData getMappingForREST] inverseMapping];    
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:activityDataSerializationMapping forClass:[ActivityData class]];
    RKObjectMapping* attemptHashSerializationMapping = [[AttemptHash getMappingForREST] inverseMapping];    
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:attemptHashSerializationMapping forClass:[AttemptHash class]];
    

}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    if(self.trackingController != nil)
    {
        self.trackingController.isInBackgroundMode = true;
        NSLog(@"Change to background-mode and notify LocationTrackingController.");
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    if(self.trackingController != nil)
    {
        self.trackingController.isInBackgroundMode = false;
        
        //reload CoreData-objects because we are now in another thread
        [trackingController reloadCurrentChallengeAttempt];
        
        if([trackingController askSpontaneousForProgress])
        {
            NSLog(@"Change to foreground-mode and notify LocationTrackingController. Ask spontaneous for current Progress");
        }
        else
        {
            NSLog(@"Change to foreground-mode and notify LocationTrackingController. No ChallengeAttempt to ask for Progress");
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
