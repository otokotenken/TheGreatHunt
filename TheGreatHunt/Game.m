//
//  Game.m
//  TheGreatHunt
//
//  Created by DetroitLabs on 6/14/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "Game.h"

@implementation Game

+(instancetype)getInstance{
    static Game *applicationGame = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        applicationGame = [[Game alloc]initPrivately];
    });
    return applicationGame;
}

-(instancetype)initPrivately {
    self = [super init];
    return self;
}



@end
