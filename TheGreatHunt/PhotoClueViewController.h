//
//  PhotoClueViewController.h
//  TheGreatHunt
//
//  Created by ling toby on 6/13/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameController.h"

@interface PhotoClueViewController : UIViewController <GameController, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoBackImage;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@end
