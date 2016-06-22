//
//  Game.h
//  TheGreatHunt
//
//  Created by DetroitLabs on 6/14/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Game : NSObject
// current clue
//array of clues

@property(nonatomic, strong) NSArray *cluesArray;
@property(nonatomic, strong) NSString *currentClue;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *gameTimer;

+(instancetype)getInstance;

-(void)timerSubstract;


@end
