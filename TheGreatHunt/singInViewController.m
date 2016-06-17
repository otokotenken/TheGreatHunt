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
- (void)viewDidLoad {
    [super viewDidLoad];
    // pull data
    ref = [[FIRDatabase database] reference];
    [ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *postDict = snapshot.value;
        NSLog(@" ++++++++++++++++++++++++++++++++++++++++++++++++++++++++The JSON type of dictionary is %@", postDict);
        [self formatJSON:postDict];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)formatJSON: (NSDictionary *)dict {
    NSArray *clueArray;
    NSMutableArray *unfilteredCluesArray = [[NSMutableArray alloc]init];
    
    //loop in first layer of dictionary
    for (id dictKey in dict){
        NSDictionary *clueOrMaybeGame = dict[dictKey];
        NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++The dictionary name for the game is %@ ", dictKey);  //grab key in first layer. Checked
        
        //filter Game and Clue
        if ([dictKey rangeOfString:@"game"].location != NSNotFound){
            [Game getInstance].name = dictKey;
            NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++%@", [Game getInstance].name); //grab key, then assign to Game.name. Checked
        } else if ([dictKey rangeOfString:@"clue"].location != NSNotFound){
            NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++The dictionary name for the clue is %@ ", dictKey);  //grab clue title. Checked
            
            
            Clue *tempClue = [self formatClue:clueOrMaybeGame];
            NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++%@", tempClue.textHint); //grab clue object detail, Checked.
            [unfilteredCluesArray addObject:tempClue];
        }
        NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++%lu",[unfilteredCluesArray count]);//clues array before filter has 3 clues, Checked
        clueArray = [self filterArray:unfilteredCluesArray];
        
        [Game getInstance].cluesArray = clueArray;
        NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++%lu",(unsigned long)[[Game getInstance].cluesArray count]);
        for (id clueKey in clueOrMaybeGame){
            NSLog(@"The dictionary details is as following:\n Key:%@\n Value: %@ ",clueKey, clueOrMaybeGame[clueKey]);
            
        }
    }
}
-(NSArray *)filterArray: (NSMutableArray *)unfilteredCluesArray{
    NSMutableArray *tempArrey = [[NSMutableArray alloc]init];
    //filter clue array with gameRef
    for (id obj in unfilteredCluesArray){
        if ([[obj gameRef] isEqualToString:@"game1"]){
            NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++%@",[obj textHint]); //Clues filtered. Checked
            [tempArrey addObject:obj];
        }
    }
    NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++%lu", [tempArrey count]);
    
    //NSArray *resultsArray = [tempArrey copy];
    NSArray *resultsArray = [NSArray arrayWithArray:tempArrey];
    NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++%lu", [resultsArray count]); //Clues for current game is popularted fine. Checked.
    return resultsArray;
}
-(Clue *)formatClue: (NSDictionary *)clueDict {
    Clue *clue = [[Clue alloc]initWithTextHint:clueDict[@"textHint"] andImageHint:clueDict[@"imageHint"] andLocationHint:clueDict[@"locationHint"] andlocationHintRadius:clueDict[@"locationHintRadius"] :clueDict[@"gameRef"] :clueDict[@"order"]];
    NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++%@",[clue textHint]); // double check if clue object built successfully, checked
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
