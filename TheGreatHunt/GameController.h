//
//  GameController.h
//  TheGreatHunt
//
//  Created by tstone10 on 6/20/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Clue.h"
#import "Game.h"

@protocol GameController <NSObject>

-(Clue *)getCurrentClue;

@end
