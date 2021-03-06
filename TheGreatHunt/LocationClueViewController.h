//
//  LocationClueViewController.h
//  TheGreatHunt
//
//  Created by ling toby on 6/13/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GameController.h"

@interface LocationClueViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, GameController>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UILabel *textHintLabel;
@property (weak, nonatomic) IBOutlet UIImageView *locationBackImage;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;


@end
