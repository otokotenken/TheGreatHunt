//
//  Clue.m
//  TheGreatHunt
//
//  Created by DetroitLabs on 6/14/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "Clue.h"

@implementation Clue

-(id)initWithTextHint: (NSString *)textHint andImageHint: (NSString *)imageHint andLocationHint: (NSDictionary *)locationHint andlocationHintRadius: (NSString *)locationHintRadius{
    self = [super init];
    if (self){
        _textHint = textHint;
        _imageHint = [UIImage imageNamed:imageHint];
        _locationHint.latitude = [locationHint[@"lat"] doubleValue];
        _locationHint.longitude = [locationHint[@"long"] doubleValue];
        _locationHintRadius = [locationHintRadius floatValue];
    }
    return self;
}


@end
