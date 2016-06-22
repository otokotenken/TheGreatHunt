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
#import "LocationClueViewController.h"
@import Firebase;
@interface singInViewController ()
@end
@implementation singInViewController
FIRDatabaseReference *ref;
//MARK: life cycle Methods
- (void)viewDidLoad {
	[super viewDidLoad];
	ref = [[FIRDatabase database] reference];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

-(void)retrieveGameDataFromDBRef:(FIRDatabaseReference *)ref {
	[ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		NSDictionary *postDict = snapshot.value;
		//NSLog(@" ++++++++++++++++++++++++++++++++++++++++++++++++++++++++The JSON type of dictionary is %@", postDict);
		[self formatJSON:postDict];
	}];
}
//MARK:Interactivity Methods

//format data to NSObject
-(void)formatJSON: (NSDictionary *)dict {
    NSMutableArray *unfilteredCluesArray = [[NSMutableArray alloc]init];
    NSMutableArray *unsortedClueArray;
    NSArray *sortedClueArray;
    
    //loop in first layer of dictionary
    for (id dictKey in dict){
        NSDictionary *clueOrMaybeGameDict = dict[dictKey];
        //filter Game and Clue, game saved to Singleton, Clue saved to Clues Array.
        if ([dictKey rangeOfString:@"game"].location != NSNotFound){
            [self formatGameWith:clueOrMaybeGameDict];
        } else if ([dictKey rangeOfString:@"clue"].location != NSNotFound){
            Clue *tempClue = [self formatClueDictToOjc:clueOrMaybeGameDict];
            [unfilteredCluesArray addObject:tempClue];
            unsortedClueArray = [self filterArray:unfilteredCluesArray];
            sortedClueArray = [self sortArray:unsortedClueArray];
        }
    }
    [Game getInstance].cluesArray = sortedClueArray;
    
    /*
     NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++ Game's first text hint is %@",[[[[Game getInstance] cluesArray] objectAtIndex:0] textHint] );
     NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++ Game's first text hint is %@",[[[[Game getInstance] cluesArray] objectAtIndex:1] textHint] );
     NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++ Game's first text hint is %@",[[[[Game getInstance] cluesArray] objectAtIndex:2] textHint] );*/
    
}

//formate game object
-(Game *)formatGameWith: (NSDictionary *)oneDictionary{
    [Game getInstance].name = oneDictionary[@"name"];
    [Game getInstance].currentClue = oneDictionary[@"currentClue"];
    return [Game getInstance];
}


// filer Clue Array by gameRef
-(NSMutableArray *)filterArray: (NSMutableArray *)oneArray{
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    //filter clue array with gameRef
    for (id obj in oneArray){
        if ([[obj gameRef] isEqualToString:@"game1"]){
            [tempArray addObject:obj];
        }else{
            NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++alert!Does not find any game1 clue in the array");
        }
    }
    return tempArray;
}


//Sort Clue Array by order
-(NSArray *)sortArray: (NSMutableArray *)oneArray{
    NSArray *sortedArray;
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]];
    sortedArray = [oneArray sortedArrayUsingDescriptors:sortDescriptors];
    return sortedArray;
}

//Formate clue dictionary to NSObject type
-(Clue *)formatClueDictToOjc: (NSDictionary *)clueDict {
    Clue *clue = [[Clue alloc]initWithTextHint:clueDict[@"textHint"] andImageHint:clueDict[@"imageHint"] andLocationHint:clueDict[@"locationHint"] andlocationHintRadius:clueDict[@"locationHintRadius"] :clueDict[@"gameRef"] :clueDict[@"order"] :clueDict[@"name"]];
    return clue;
}


//Sign in , Sign up and Sign out
- (IBAction)signInSignUpButtonPress:(id)sender {
    [[FIRAuth auth] signInWithEmail:_userEmailInputField.text
                           password:_passwordInputField.text
                         completion:^(FIRUser *user, NSError *error) {
                             NSLog(@"%@, %@" ,user.description, error);
                             [self decideSignInOrSignUp: error];
                         }];
}

-(void)decideSignInOrSignUp :(NSError *)error {
    if(error){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Not Registered Yet?"
                                                                       message:@" Would You Like To Sign Up? "
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Sign Up"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  if (error.code == 17007){
                                                                      _errorDisplayLabel.text = @"This email is already in use.";
                                                                      NSLog(@"email in use");
                                                                  } else if (error.code == 17009){
                                                                      _errorDisplayLabel.text = @"Incorrect Password";
                                                                      NSLog(@"wrong password");
                                                                  } else if (error.code == 17026){
                                                                      _errorDisplayLabel.text = @"Please enter a 6 character password.";
                                                                      NSLog(@"weak password");
                                                                  } else {
                                                                      [self signUpUser];}
                                                              }];
        
        NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"\n Not Registered Yet?\n\n"];
        [hogan addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:34.0]
                      range:NSMakeRange(1, 21)];
        [alert setValue:hogan forKey:@"attributedTitle"];
        
        NSMutableAttributedString *messageChange = [[NSMutableAttributedString alloc] initWithString:@"Would You Like to Sign Up? "];
        [messageChange addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:18.0]
                      range:NSMakeRange(0, 26)];
        [alert setValue:messageChange forKey:@"attributedMessage"];
        
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   _userEmailInputField.text = @"";
                                                                   _passwordInputField.text = @"";
                                                               }];
        
        [alert addAction:firstAction];
        [alert addAction:secondAction];
//        alert.view.backgroundColor = [UIColor blueColor];
        alert.view.tintColor = [UIColor purpleColor];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
		[self retrieveGameDataFromDBRef:ref];
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
