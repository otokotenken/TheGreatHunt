//
//  singInViewController.m
//  TheGreatHunt
//
//  Created by ling toby on 6/13/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "singInViewController.h"
#import "Game.h"
#import "Clue.h"
#import "User.h"
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
    [_passwordInputField setDelegate:self];
    [_userEmailInputField setDelegate:self];
    
    _signInButton.layer.cornerRadius = 15;
    _signInButton.layer.borderColor = [[UIColor colorWithRed:249.0/255.0f green:190.0/255.0f blue:2.0/255.0f  alpha:1.0]CGColor];
    _signInButton.layer.borderWidth = 3.0f;

    _switchUserButton.layer.cornerRadius = 15;
    _switchUserButton.layer.borderColor = [[UIColor colorWithRed:249.0/255.0f green:190.0/255.0f blue:2.0/255.0f  alpha:1.0]CGColor];
    _switchUserButton.layer.borderWidth = 3.0f;
//    _signInImageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blocksBackground.jpg"]];
//    _signInImageView.layer.backgroundColor = [[UIColor clearColor]CGColor];
    _signInImageView.alpha = 0.5;
    
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

-(void)retrieveGameDataFromDBRef:(FIRDatabaseReference *)ref {
	[ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		[self processGameDataObjects:snapshot.value];
	}];
}

-(void)processGameDataObjects:(NSDictionary *)data {
	
	[self getCurrentUserObjectForEmail:_userEmailInputField.text fromData:data andOnComplete:^(NSDictionary *userObject, NSDictionary *data){
		//now that we have the user instance info, set up the game object appropriately
		[self configureGameWithData:userObject andName:data[userObject[@"currentGame"]]];
		
		[Game getInstance].cluesArray = [self buildCluesArrayForCurrentGame:userObject[@"currentGame"] fromData:data];
		[self performSegueWithIdentifier:@"toWelcome" sender:nil];
	}];
}

-(void)getCurrentUserObjectForEmail:(NSString *)userEmail fromData:(NSDictionary *)data andOnComplete:(void(^)(NSDictionary *, NSDictionary *))callbackBlock {
	NSMutableString *sanitizedUserEmail = [userEmail mutableCopy];
	
	//firebase won't accept '/' '.' '#' '$' '[' or ']' in keys. these can be valid in emails.
	//switch their occurrences to valid options.
	
	[sanitizedUserEmail replaceOccurrencesOfString:@"/" withString:@"slash" options:0 range:NSMakeRange(0, sanitizedUserEmail.length)];
	[sanitizedUserEmail replaceOccurrencesOfString:@"." withString:@"dot" options:0 range:NSMakeRange(0, sanitizedUserEmail.length)];
	[sanitizedUserEmail replaceOccurrencesOfString:@"#" withString:@"hash" options:0 range:NSMakeRange(0, sanitizedUserEmail.length)];
	[sanitizedUserEmail replaceOccurrencesOfString:@"$" withString:@"dollar" options:0 range:NSMakeRange(0, sanitizedUserEmail.length)];
	[sanitizedUserEmail replaceOccurrencesOfString:@"[" withString:@"left" options:0 range:NSMakeRange(0, sanitizedUserEmail.length)];
	[sanitizedUserEmail replaceOccurrencesOfString:@"]" withString:@"right" options:0 range:NSMakeRange(0, sanitizedUserEmail.length)];
	
	[User getInstance].sanitizedUserName = [sanitizedUserEmail copy];
	
	NSDictionary *userObject = data[[User getInstance].sanitizedUserName];
	//if we don't get one, create one, save it, and use it
	if(!userObject) {
		NSLog(@"user object for %@ doesn't exist in the db, creating one and using it.", [User getInstance].sanitizedUserName);
		
		userObject = @{[User getInstance].sanitizedUserName: @{@"currentGame": @"game1", @"currentClue": @"clue1", @"gameTimer": @"00:00:00"}};
		
		[ref updateChildValues:userObject withCompletionBlock:^(NSError * err, FIRDatabaseReference *ref){
			callbackBlock(userObject[[User getInstance].sanitizedUserName], data);
		}];
	}
	else {
		NSLog(@"user object for %@ exists, using it.", [User getInstance].sanitizedUserName);
		callbackBlock(userObject, data);
	}
}

-(NSArray *)buildCluesArrayForCurrentGame:(NSString *)gameId fromData:(NSDictionary *)data {
	NSMutableArray *arr = [[NSMutableArray alloc] init];
	
	for(id key in data) {
		if([key rangeOfString:@"clue"].location != NSNotFound && [data[key][@"gameRef"] isEqualToString:gameId]) {
			[arr addObject:[self formatClueDictToOjc:data[key]]];
		}
	}
	
	//we now have the array, but sort it before we return it so it's in clue order
	return [self sortArray:arr];
}

-(void)configureGameWithData:(NSDictionary *)userGameData andName:(NSString *)gameName {
	[Game getInstance].name = gameName;
	[Game getInstance].currentClue = userGameData[@"currentClue"];
	//[Game getInstance].gameTimer = userGameData[@"currentClue"];
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
- (IBAction)signOutSwitchUser:(id)sender {
    [[FIRAuth auth] signInWithEmail:_userEmailInputField.text
                           password:_passwordInputField.text
                         completion:^(FIRUser *user, NSError *error) {
                             NSLog(@"%@, %@" ,user.description, error);
                             [self decideSignInOrSignUp: error];
                         }];
}
-(void)signUpUser:(NSString*)userName password:(NSString*)password {
    [[FIRAuth auth]
     createUserWithEmail:userName
     password: password
     completion:^(FIRUser *_Nullable user,
                  NSError *_Nullable error) {
         NSLog(@"%@, %@" ,user, error);
         [self decideSignInOrSignUp:error];
     }];
}
-(void)decideSignInOrSignUp :(NSError *)error {
    if(error){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Not Registered Yet?"
                                                                       message:@" Would You Like To Sign Up? "
                                                                preferredStyle:UIAlertControllerStyleAlert];
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
                                                                      NSString *email = [[[alert textFields]firstObject]text];
                                                                      NSString *password = [[[alert textFields] objectAtIndex:1]text];
																	  NSLog(@"--------------------using password '%@'", password);
                                                                      [self signUpUser:email password:password];}
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
        
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Username";
        }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Password";
            textField.secureTextEntry = YES;
        }];
        
        alert.view.tintColor = [UIColor purpleColor];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
		[User getInstance].userName = _userEmailInputField.text;
		[self retrieveGameDataFromDBRef:ref];
        //[self performSegueWithIdentifier:@"toWelcome" sender:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_passwordInputField resignFirstResponder];
    [_userEmailInputField resignFirstResponder];
    return YES;
}
@end

