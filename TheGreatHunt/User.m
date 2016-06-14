//
//  User.m
//  TheGreatHunt
//
//  Created by DetroitLabs on 6/14/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "User.h"

@implementation User

+(instancetype)getInstance{
    static User *applicationUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        applicationUser = [[User alloc]initPrivately];
    });
    return applicationUser;
}

-(instancetype)initPrivately {
    self = [super init];
    return self;
}

@end
