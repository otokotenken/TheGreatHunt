//
//  Clue.h
//  TheGreatHunt
//
//  Created by DetroitLabs on 6/14/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface Clue : NSObject

@property (strong, nonatomic) NSString *textHint;
@property (strong, nonatomic) UIImage *imageHint;

@property CLLocationCoordinate2D  locationHint;
@property float locationHintRadius;


@end
