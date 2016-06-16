//
//  singInViewController.m
//  TheGreatHunt
//
//  Created by ling toby on 6/13/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "singInViewController.h"
@import Firebase;

@interface singInViewController ()

@end

@implementation singInViewController
FIRDatabaseReference *ref;

- (void)viewDidLoad {
    [super viewDidLoad];
    //signup for an account
//    [[FIRAuth auth]
//     createUserWithEmail:@"asklingtoby@gmail.com"
//     password:@"password"
//     completion:^(FIRUser *_Nullable user,
//                  NSError *_Nullable error) {
//         NSLog(@"%@, %@" ,user, error);
//     }];
//    [[FIRAuth auth] signInWithEmail:@"otokonotenken13@gmail.com"
//                           password:@"password"
//                         completion:^(FIRUser *user, NSError *error) {
//                            NSLog(@"%@, %@" ,user.description, error);
//                         }];
    
//    NSError *error;
//    [[FIRAuth auth] signOut:&error];
//    if (!error) {
//        // Sign-out succeeded
//    }
    
    // Do any additional setup after loading the view.
    ref = [[FIRDatabase database] reference];
    
    //FIRDatabaseReference *childRef = [ref child:@"game1"];
    
     [ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *postDict = snapshot.value;
         
         NSLog(@"%@", postDict);
        // ...
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)signInSignUpButtonPress:(id)sender {
        [[FIRAuth auth] signInWithEmail:_userEmailInputField.text
                               password:_passwordInputField.text
                             completion:^(FIRUser *user, NSError *error) {
                                NSLog(@"%@, %@" ,user.description, error);
                                 [self decideSignInOrSignUp:error];
                                 }];
}

-(void)decideSignInOrSignUp :(NSError *)error {
    if(error){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Not Registered Yet?"
                                                                           message:@"Would You Like To Sign Up?"
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Sign Up"
                                                                  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                      [self signUpUser];
                                                                  }];
            UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                   style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                       _userEmailInputField.text = @"";
                                                                       _passwordInputField.text = @"";
                                                                   }];
            [alert addAction:firstAction];
            [alert addAction:secondAction];
            [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self performSegueWithIdentifier:@"toWelcome" sender:nil];
    }
}

-(void)signUpUser {
            [[FIRAuth auth]
             createUserWithEmail:_userEmailInputField.text
             password:_passwordInputField.text
             completion:^(FIRUser *_Nullable user,
                          NSError *_Nullable error) {
                 NSLog(@"%@, %@" ,user, error);
             }];
}

- (IBAction)signOutSwitchUser:(id)sender {
    NSError *error;
    [[FIRAuth auth] signOut:&error];
        if (!error) {
            NSLog(@"signed out  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
        } else {
            NSLog(@"%@", error);
        }
}

@end
