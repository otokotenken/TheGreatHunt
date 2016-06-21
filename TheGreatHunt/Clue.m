//
//  Clue.m
//  TheGreatHunt
//
//  Created by DetroitLabs on 6/14/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "Clue.h"


@implementation Clue

-(id)initWithTextHint: (NSString *)textHint andImageHint: (NSString *)imageHint andLocationHint: (NSDictionary *)locationHint andlocationHintRadius: (NSString *)locationHintRadius :(NSString *)gameRef :(NSString *)order :(NSString *)name{
    self = [super init];
    if (self){
        _textHint = textHint;
        _imageHint = [self createUIImageFromBase64String:imageHint];
        _locationHint.latitude = [locationHint[@"lat"] doubleValue];
        _locationHint.longitude = [locationHint[@"long"] doubleValue];
        _locationHintRadius = [locationHintRadius floatValue];
        _gameRef = gameRef;
        _name = name;
        _order = [order intValue];
    }
    return self;
}

-(UIImage *)createUIImageFromBase64String:(NSString *)string {
	NSURL *url = [NSURL URLWithString:string];
	NSData *imageData = [NSData dataWithContentsOfURL:url];
	UIImage *hintImage = [UIImage imageWithData:imageData];
	
	return hintImage;
}

@end
