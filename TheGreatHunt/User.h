//
//  User.h
//  TheGreatHunt
//
//  Created by DetroitLabs on 6/14/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject


//user name
//login token
//status of current game
//reference of current game

@property(strong, nonatomic) NSString *userName;
@property(strong, nonatomic) NSString *userToken;
@property(strong, nonatomic) NSString *userCurrentGame;
@property(strong, nonatomic) NSString *userGameReference;

+(instancetype)getInstance;

//getter or setters for token variables

@end
