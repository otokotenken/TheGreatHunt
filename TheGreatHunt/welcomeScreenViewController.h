//
//  welcomeScreenViewController.h
//  TheGreatHunt
//
//  Created by ling toby on 6/13/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameController.h"

@interface welcomeScreenViewController : UIViewController <GameController>
@property (weak, nonatomic) IBOutlet UIImageView *welcomeImage;

@end
