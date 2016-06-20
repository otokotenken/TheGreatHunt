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

@end

@implementation LocationClueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    [_mapView setShowsUserLocation:YES];
    [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    // Do any additional setup after loading the view.
}

- (void)clueRegionSetup{
    float spanX = 0.05; // span of the map this is a 20mile radius. 1 degree == 69 miles, do math accordingly.
    float spanY = 0.05;
    _currentLocation = _locationManager.location; //current location
    NSLog(@"Current location: %@", _currentLocation.description);
    MKCoordinateRegion region; // the following lines define the region we want to zoom in on
    region.center.latitude = _locationManager.location.coordinate.latitude;
    region.center.longitude = _locationManager.location.coordinate.longitude;
    region.span = MKCoordinateSpanMake(spanX, spanY);
    [self.mapView setRegion:region animated:YES];
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(42.457972, 83.135071);
    CLRegion *clueArea = [[CLCircularRegion alloc]initWithCenter:center radius:100.0 identifier:@"Clue Area"];
    [_locationManager startMonitoringForRegion:clueArea];
    [_locationManager requestStateForRegion:clueArea];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSLog(@"Entered region %@ \n", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    NSLog(@"EXITED region %@ \n", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    NSLog(@"Now monitoring %@ \n\n ", region.identifier);
}

// Determine current state - if person is already inside the Region
- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
