//
//  singInViewController.h
//  TheGreatHunt
//
//  Created by ling toby on 6/13/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface singInViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userEmailInputField;
@property (weak, nonatomic) IBOutlet UITextField *passwordInputField;

@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@end
