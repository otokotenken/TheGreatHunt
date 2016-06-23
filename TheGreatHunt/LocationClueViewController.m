//
//  LocationClueViewController.m
//  TheGreatHunt
//
//  Created by ling toby on 6/13/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "LocationClueViewController.h"
#import <AVFoundation/AVFoundation.h>

@import MapKit;


@interface LocationClueViewController ()

{
    AVAudioPlayer *_audioPlayer;
}

@property (strong, nonatomic) CLLocation *currentLocation;
@property (weak, nonatomic) IBOutlet UILabel *debugStatusRegion;
@property (weak, nonatomic) IBOutlet UIButton *cheatButton;

@end

@implementation LocationClueViewController

Clue *currentClue;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cheatButton.layer.cornerRadius = 15;
    _cheatButton.layer.borderColor = [[UIColor colorWithRed:249.0/255.0f green:190.0/255.0f blue:2.0/255.0f  alpha:1.0]CGColor];
    _cheatButton.layer.borderWidth = 3.0f;
    _locationBackImage.alpha = 0.6;
    
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
    // need to refactor and change the name of this label to the status label
    NSString *statusLabelClueCountText = [Game getInstance].currentClue;
    _debugStatusRegion.text = [NSString stringWithFormat:@"%@ of %lu clues", statusLabelClueCountText, [Game getInstance].cluesArray.count];
    _debugStatusRegion.textColor = [UIColor whiteColor];
    
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
    //commented out lines with long and lat are the clue long and lat. 
    
    float spanX = 0.01; // span of the map this is a 20mile radius. 1 degree == 69 miles, do math accordingly.
    float spanY = 0.01;
//    _currentLocation = _locationManager.location; //current location
    NSLog(@"Current location: %@", _currentLocation.description);
    MKCoordinateRegion region; // the following lines define the region we want to zoom in on
    region.center.latitude = currentClue.locationHint.latitude;
    region.center.longitude = currentClue.locationHint.longitude;
//
//    region.center.latitude = 42.363558;
//    region.center.longitude = -83.073359;
    region.span = MKCoordinateSpanMake(spanX, spanY);
    [self.mapView setRegion:region animated:YES];
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(region.center.latitude, region.center.longitude);
    
    //CLLocationCoordinate2D center = CLLocationCoordinate2DMake(42.363558, -83.073359);
    
    CLRegion *clueArea = [[CLCircularRegion alloc]initWithCenter:center radius:50.0 identifier:@"Clue Area"];
    [_locationManager startMonitoringForRegion:clueArea];
    NSLog(@"clue Area: %@", clueArea);
   // [_locationManager requestStateForRegion:clueArea];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    NSLog(@"Now monitoring %@ \n\n ", region.identifier);
    [_locationManager requestStateForRegion: region];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSLog(@"Entered region %@ \n", region.identifier);
    
    [self playSound];
    
    [self performSegueWithIdentifier:@"locationToPhotoSegue" sender:self];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    NSLog(@"EXITED region %@ \n", region.identifier);
}

// Determine current state - if person is already inside the Region
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    // When regions are initialized, see if we are already within the geofence.
    if (state == CLRegionStateInside){
        [self playSound];
        NSLog(@"Already in the region %@ \n", region.identifier);
  
       [self performSegueWithIdentifier:@"locationToPhotoSegue" sender:self];
    }
    
}


-(void)playSound{
    NSString *path = [NSString stringWithFormat:@"%@/ding.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [_audioPlayer play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (IBAction)unwindToLocationClue:(UIStoryboardSegue *)unwindSegue {
	
}

@end
