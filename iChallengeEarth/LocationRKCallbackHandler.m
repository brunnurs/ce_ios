//
//  LocationRKCallbackHandler.m
//  iChallengeEarth
//
//  Created by Administrator on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationRKCallbackHandler.h"
#import "ceAppDelegate.h"
#import "ChallengeAttempt.h"
#import "LocationTrackingController.h"
#import "ActivityData.h"

@implementation LocationRKCallbackHandler
@synthesize currentProgress;
@synthesize challengeView;
@synthesize askForProgressAfterActivitySent;
@synthesize trackingController;



-(id)initWithTrackingController:(LocationTrackingController *)controller
{
    self = [super init];
	if(!self)
		return nil;
    
    self.trackingController = controller;
    return self;
}

-(void)askForCurrentProgress
{
    self.currentProgress = [[Progress alloc]init];
    currentProgress.attemptHash = trackingController.currentChallengeAttempt.attemptHash;
    currentProgress.userId = [NSNumber numberWithLong:USERID];
    [[RKObjectManager sharedManager] getObject:currentProgress mapResponseWith:[Progress getMappingForREST] delegate:self];
    NSLog(@"Ask for Progress with Progress: %@",currentProgress);
}

//flag this entity to remove on the next sending-cycle. The entity can not be removed here, because the async request-queue still needs it
-(void)flagThisActivityDataToRemove:(ActivityData *)activityToRemove
{
    activityToRemove.toRemove = [NSNumber numberWithBool:YES];
    NSError* error;
    [activityToRemove.managedObjectContext save:&error];
    NSLog(@"INFO: Flaged to remove and saved with CoreData. \nerror:%@ | %@ | %@", error, [error userInfo],[error localizedDescription]);
    
}

// ************ RestKit-Callback *************
-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object{
    if([object class] == [Progress class])
    {
        //send the new progress for displaying to a view
        [challengeView challengeUpdated:object];
        
    }
    else if([object class] == [ActivityData class])
    {
        if(askForProgressAfterActivitySent)
        {
            //when we receive the answer to the activity-update, we ask for the current progress of this challenge.
            [self askForCurrentProgress];
        }
        
        [self flagThisActivityDataToRemove:object];
     }
}




// ************************ just some logging-shit *************************

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Rats!" otherButtonTitles:nil];
    [alert show];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{  
//    NSLog(@"gesendet: %@",[request HTTPBodyString]);
//    for (NSString* key in [request additionalHTTPHeaders]) {
//        NSLog(@"Header: %@",[request.additionalHTTPHeaders objectForKey:key]);
//    }
	NSLog(@"empfangen: %@",[response bodyAsString]);
}


@end
