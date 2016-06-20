//
//  LocationClueViewController.m
//  TheGreatHunt
//
//  Created by ling toby on 6/13/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "LocationClueViewController.h"
@import MapKit;

@interface LocationClueViewController ()

@property (strong, nonatomic) CLLocation *currentLocation;
@property (weak, nonatomic) IBOutlet UILabel *debugStatusRegion;

@end

@implementation LocationClueViewController

Clue *currentClue;

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *currentClueName =[[Game getInstance] currentClue];
//    for (Clue *obj in [[Game getInstance] cluesArray]){
//        if ([[obj name] isEqualToString:currentClueName]){
//            currentClue = obj;
//        }
//    }
//    _textHintTextView.text = [currentClue textHint];
//    self.locationManager = [[CLLocationManager alloc]init];
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
//    self.locationManager.delegate = self;
//    [self.locationManager requestAlwaysAuthorization];
//    [self.locationManager startUpdatingLocation];
//    [self clueRegionSetup];
//    
//    
//    [_mapView setShowsUserLocation:YES];
//    [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
//
}

- (void)viewWillAppear:(BOOL)animated {
	currentClue = [self getCurrentClue];
	
	_textHintLabel.text = [currentClue textHint];
	self.locationManager = [[CLLocationManager alloc]init];
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
	self.locationManager.delegate = self;
	[self.locationManager requestAlwaysAuthorization];
	[self.locationManager startUpdatingLocation];
    [self clueRegionSetup];
	
	[_mapView setShowsUserLocation:YES];
	[_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

-(Clue *)getCurrentClue {
	NSString *currentClueName = [Game getInstance].currentClue;
	for (Clue *obj in [[Game getInstance] cluesArray]){
		if ([[obj name] isEqualToString:currentClueName]){
			return obj;
		}
	}
	
	return nil;

}

- (void)clueRegionSetup{
    float spanX = 0.01; // span of the map this is a 20mile radius. 1 degree == 69 miles, do math accordingly.
    float spanY = 0.01;
//    _currentLocation = _locationManager.location; //current location
    NSLog(@"Current location: %@", _currentLocation.description);
    MKCoordinateRegion region; // the following lines define the region we want to zoom in on
//    region.center.latitude = currentClue.locationHint.latitude;
//    region.center.longitude = currentClue.locationHint.longitude;
//    
    region.center.latitude = 42.363558;
    region.center.longitude = -83.073359;
    region.span = MKCoordinateSpanMake(spanX, spanY);
    [self.mapView setRegion:region animated:YES];
//    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(region.center.latitude, region.center.longitude);
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(42.363558, -83.073359);
    
    CLRegion *clueArea = [[CLCircularRegion alloc]initWithCenter:center radius:50.0 identifier:@"Clue Area"];
    [_locationManager startMonitoringForRegion:clueArea];
    NSLog(@"clue Area: %@", clueArea);
    [_locationManager requestStateForRegion:clueArea];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    NSLog(@"Now monitoring %@ \n\n ", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSLog(@"Entered region %@ \n", region.identifier);
    _debugStatusRegion.text = @"You Have Entered the Clue Zone";
    _debugStatusRegion.textColor = [UIColor greenColor];
    
    [self performSegueWithIdentifier:@"locationToPhotoSegue" sender:self];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    NSLog(@"EXITED region %@ \n", region.identifier);
    _debugStatusRegion.text = @"You Have left the Clue Zone";
    _debugStatusRegion.textColor = [UIColor redColor];
}

// Determine current state - if person is already inside the Region
- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (IBAction)unwindToLocationClue:(UIStoryboardSegue *)unwindSegue {
	
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
