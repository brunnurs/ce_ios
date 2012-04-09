//
//  ceOverviewController.m
//  iChallengeEarth
//
//  Created by Administrator on 12/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ceOverviewController.h"
#import "ceChallengeDetailController.h"
#import "Challenge.h"
#import "ChallengeCell.h"
#import "AdressAnnotation.h"
#import "ActivityData.h"
#import "AttemptHash.h"
#import "AchievmentDescription.h"
#import "Image.h"
#import "Position.h"
#import "Category.h"


@implementation ceOverviewController
@synthesize challenges;
@synthesize refreshTimer;
@synthesize timerTicks;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidAppear:(BOOL)animated
{
    //TODO Decide if we should use the timer... and if so, with a button to enable/disable it!
    self.timerTicks = 0;
	self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshPositionOnMap:) userInfo:nil repeats:YES];
}
	
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
  
//    ActivityData* currentActivity = [[ActivityData alloc]init];
//    currentActivity.image = @"testimage";
//    currentActivity.accuracy = [NSNumber numberWithDouble:50.2];
//    currentActivity.longitude = [NSNumber numberWithDouble:47.498147];
//    currentActivity.latitude = [NSNumber numberWithDouble:8.729786];
//    currentActivity.altitude = [NSNumber numberWithDouble:1450.3];
//    currentActivity.velocity = [NSNumber numberWithDouble:34.3];
//    currentActivity.dateTime = [NSNumber numberWithLongLong:1325738282626];
//    currentActivity.challengeId = [NSArray arrayWithObjects:[NSNumber numberWithLong:1],nil];
//    currentActivity.userId = [NSNumber numberWithLong:1];
//    [[RKObjectManager sharedManager] postObject:currentActivity delegate:self ];

    
//    ActivityData *a1 = [ActivityData object];
//    a1.longitude = [NSNumber numberWithDouble:122.122];
//
//    ActivityData *a2 = [ActivityData object];
//    a2.longitude = [NSNumber numberWithDouble:133.133];
//
//    AttemptHash *h1 = [AttemptHash object];
//    h1.attemptHash = @"esel";
//    
//    AttemptHash *h2 = [AttemptHash object];
//    h2.attemptHash = @"hund";
//    
//    [a1 addAttemptHashsObject:h1];
//    [a1 addAttemptHashsObject:h2];
//    
//    [h1 addActivityDatasObject:a1];
//    [h1 addActivityDatasObject:a2];
//    
//    NSError *error;
//    [a1.managedObjectContext save:&error];
//    
//    NSArray *allActivities = [ActivityData allObjects];
//    NSLog(@"All-Activities-Count : (%d)", allActivities.count);
//    
//    ActivityData *a11 = [allActivities objectAtIndex:0];
//    NSLog(@"AttemptHashs in a1: (%d)", a11.attemptHashs.count);
//
//    ActivityData *a22 = [allActivities objectAtIndex:1];
//    NSLog(@"AttemptHashs in a2: (%d)", a22.attemptHashs.count);
//    
//    NSArray *allHashs = [AttemptHash allObjects];
//    NSLog(@"All-Hashs-Count : (%d)", allHashs.count);
//    
//    AttemptHash *h11 = [allHashs objectAtIndex:0];
//    NSLog(@"Activities in h1: (%d)", h11.activityDatas.count);
//    
//    AttemptHash *h22 = [allHashs objectAtIndex:1];
//    NSLog(@"Activities in h2: (%d)", h22.activityDatas.count);
//    
    

    
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/challenge"  objectMapping:[Challenge getMappingForREST] delegate:self];
    
	//Dummydaten erstellen
//	Challenge *c1 = [[Challenge alloc]init];
//    c1.title = @"Zürichseerundfahrt";
//    c1.description = @"Fühlen Sie sich für einmal wie Canchelara! Umfahren Sie den Zürichsee (inklusive Untersee) innerhalb von max. 4h. Sie dürfen dabei jede Art von Velo benutzen. Beachten Sie bitte, dass Sie zwingend die Strassen entlang des Seeufers benutzen müssen. Für weitere Angaben benutzen Sie die Karte.";
//    c1.category = @"Biker";
//    c1.difficulty = 1;
//    c1.startPosition = [[Position alloc]init];
//    c1.startPosition.longitude = 47.4534;
//    c1.startPosition.latitude = 8.444;
//    	
//    Challenge *c2 = [[Challenge alloc]init];
//    c2.title = @"Piz Beverin";
//    c2.description = @"Beschreibung zu Piz Beverin.";
//    c2.category = @"Berge";
//    c2.difficulty = 2;
//    c2.startPosition = [[Position alloc]init];
//    c2.startPosition.longitude = 47.455334;
//    c2.startPosition.latitude = 8.4566;
//    
//    Challenge *c3 = [[Challenge alloc]init];
//    c3.title = @"San Francisco";
//    c3.description = @"Beschreibung zu San Francisco.";
//    c3.category = @"Städte";
//    c3.difficulty = 3;
//    c3.startPosition = [[Position alloc]init];
//    c3.startPosition.longitude = 47.46322;
//    c3.startPosition.latitude = 8.234666;

}

-(void)showChallengesAsPins
{
	for (Challenge *c in self.challenges.items) 
	{
		//Just for Challenges which have a start-Position
		if (c.startPosition) 
		{
			//Show Position in Map
			AddressAnnotation *addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:[c.startPosition getAsCoordinate]];
			addAnnotation.challengeTitle = c.title;	
			[mapView addAnnotation:addAnnotation];
		}
	}
}

-(void)refreshPositionOnMap:(NSTimer*)timer
{
    if(timerTicks >= 3)
    {
        [self.refreshTimer invalidate];
    }
    else
    {
        timerTicks++;
    }
    
	//Zoom and Center Map if auto-follow is on
    MKCoordinateRegion region;
		
	region.center = mapView.userLocation.location.coordinate;
		
	region.span.latitudeDelta = .01;
	region.span.longitudeDelta = .01;
		
	[mapView setRegion:region animated:YES];
}


// ************ RestKit-Callback *************

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    
    [self refreshPositionOnMap:nil];
    self.challenges = [[ChallengeList alloc]init];
    self.challenges.items = objects;
//    [self.challenges loadChallengeImages];
    [self showChallengesAsPins];
    [challengeTable reloadData];
}

//- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjectDictionary:(NSDictionary*)dictionary
//{
//}
//
//-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object{
//    
//    NSLog(@"Test %@",object);
//    if([object class] == [Progress class])
//    {
//        NSLog(@"Esel %@",[object description]);
//    }
//    else
//    {
//        tempProgress = [[Progress alloc]init];
//        tempProgress.challengeId = [NSNumber numberWithLong:1];
//        tempProgress.userId = [NSNumber numberWithLong:1];
//        [[RKObjectManager sharedManager] getObject:tempProgress mapResponseWith:[Progress getMappingForREST] delegate:self ];
//    }
//            
//        
//}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Rats!" otherButtonTitles:nil];
    [alert show];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{  
    NSLog(@"gesendet: %@",[request HTTPBodyString]);
    for (NSString* key in [request additionalHTTPHeaders]) {
        NSLog(@"Header: %@",[request.additionalHTTPHeaders objectForKey:key]);
    }
	NSLog(@"empfangen: %@",[response bodyAsString]);
}


// ************ Table-Callback *************

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Challenges";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [challenges.items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
	Challenge *actChallenge = [challenges.items objectAtIndex:indexPath.row];
	
	ChallengeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChallengeCell"];
	
	NSString *pathLED;
	switch (actChallenge.difficulty) 
	{
		case 1:
			pathLED= [[NSBundle mainBundle]pathForResource:@"greenled" ofType:@"png"];
			break;
		case 2:
			pathLED = [[NSBundle mainBundle]pathForResource:@"yellowled" ofType:@"png"];
			break;
		case 3:
			pathLED = [[NSBundle mainBundle]pathForResource:@"redled" ofType:@"png"];
			break;
		default:
            //TODO remove this and throw an exception. Is only it looks nicely atm.
            pathLED= [[NSBundle mainBundle]pathForResource:@"greenled" ofType:@"png"];
			break;
	}
	
    
    [cell.challengeImage setImageWithURL:[actChallenge.achievmentDesc.image getURLToRemoteImage]
                   placeholderImage:[UIImage imageNamed:@"noImageCell.png"]];

    
    cell.challengeDifficulty.image = [UIImage imageWithContentsOfFile:pathLED];
	cell.challengeTitle.text = actChallenge.title;
	cell.challengeCategorie.text = actChallenge.category.title;
    
	return cell;
}


// *************** switch to the Detail-View ******************

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure we're referring to the correct segue
    if ([[segue identifier] isEqualToString:@"showChallengeDetails"]) {
        
        // Get reference to the destination view controller
        ceChallengeDetailController *detailView = [segue destinationViewController];
        
        // get the selected index
        NSInteger selectedIndex = [[challengeTable indexPathForSelectedRow] row];
        
        // hand the detail-challenge to the destination-controller
        detailView.detailChallenge = [challenges.items objectAtIndex:selectedIndex];
        detailView.allowStart = YES;
    }
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
