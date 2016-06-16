//
//  singInViewController.m
//  TheGreatHunt
//
//  Created by ling toby on 6/13/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "singInViewController.h"
#import "Game.h"
#import "Clue.h"
@import Firebase;

@interface singInViewController ()

@end

@implementation singInViewController
FIRDatabaseReference *ref;
//NSDictionary *postDict;


- (void)viewDidLoad {
    [super viewDidLoad];
    ref = [[FIRDatabase database] reference];
    
    //FIRDatabaseReference *childRef = [ref child:@"game1"];
    
     [ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *postDict = snapshot.value;
//         
         NSLog(@"%@", postDict);
         NSLog(@"+++%@", [[postDict objectForKey:@"clue2"] objectForKey:@"name"]);
         [self formatJSON:postDict];

    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)formatJSON: (NSDictionary *)dict {
    NSLog(@"FormatJSON function has been called!!!!!!!!!!!!!!!!!!!!!!!");

    for (id dictKey in dict){
        NSDictionary *clueMaybeGame = dict[dictKey];
        NSLog(@"The dictionary name is %@ ", dictKey);
            if ([dictKey rangeOfString:@"game1"].location != NSNotFound){
            [Game getInstance].name = dictKey;
            NSLog(@"******************%@", [Game getInstance].name);
            } else if ([dictKey rangeOfString:@"clue"].location != NSNotFound){
                NSLog(@"^^^^%@", [Game getInstance].name);
                NSMutableArray *unfilteredCluesArray = [[NSMutableArray alloc]init];
                Clue *tempClue = [self formatClue:clueMaybeGame];
                NSLog(@"####################### %@", tempClue.textHint);
            }
        for (id clueKey in clueMaybeGame){
            NSLog(@"The dictionary details is as following:\n Key:%@\n Value: %@ ",clueKey, clueMaybeGame[clueKey]);
        
        }
    }
}

-(Clue *)formatClue: (NSDictionary *)clueDict {
    Clue *clue = [[Clue alloc]initWithTextHint:clueDict[@"textHint"] andImageHint:clueDict[@"imageHint"] andLocationHint:clueDict[@"locationHint"] andlocationHintRadius:clueDict[@"locationHintRadius"]];
    return clue;
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
        //[self formatJSON:postDict];
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
