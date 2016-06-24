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


-(void)runTimer{
    // Create the stop watch timer that fires every 100 ms
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(timerSubstract)
                                                userInfo:nil
                                                 repeats:YES];
}

-(void)stopTimer{
    [self.timer invalidate];
}


-(void)timerSubstract{
    
    NSString *timeString = _gameTimer;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"hh:mm:ss";
    NSDate *timeDate = [formatter dateFromString:timeString];
    
    formatter.dateFormat = @"hh";
    int hours = [[formatter stringFromDate:timeDate] intValue];
    formatter.dateFormat = @"mm";
    int minutes = [[formatter stringFromDate:timeDate] intValue];
    formatter.dateFormat = @"ss";
    int seconds = [[formatter stringFromDate:timeDate] intValue];
    
    int timeInSeconds = seconds + minutes * 60 + hours * 3600;
    timeInSeconds ++;
    
    int updatedSeconds = timeInSeconds%3600%60;
    int updatedHours = updatedSeconds/3600;
    int updatedMinutes = updatedSeconds/60 % 60;
    _gameTimer = [NSString stringWithFormat:@"%.2d:%.2d:%.2d", updatedHours, updatedMinutes, updatedSeconds];
//    NSLog(@"%@",_gameTimer);
    
}










@end
