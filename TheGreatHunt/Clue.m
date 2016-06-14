//
//  Clue.m
//  TheGreatHunt
//
//  Created by DetroitLabs on 6/14/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "Clue.h"

@implementation Clue

-(id)initWithTextHint: (NSString *)textHint andImageHint: (UIImage *)imageHint andLocationHint: (CLLocationCoordinate2D)locationHint andlocationHintRadius: (float)locationHintRadius{
    self = [super init];
    if (self){
        _textHint = textHint;
        _imageHint = imageHint;
        _locationHint = locationHint;
        _locationHintRadius = locationHintRadius;
    }
    return self;
}


@end
