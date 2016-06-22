//
//  PhotoClueViewController.m
//  TheGreatHunt
//
//  Created by ling toby on 6/13/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "PhotoClueViewController.h"
@import Firebase;

@interface PhotoClueViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageHintImageView;
@end

@implementation PhotoClueViewController
FIRDatabaseReference *dbRef;

- (void)viewDidLoad {
    [super viewDidLoad];
	dbRef = [[FIRDatabase database] reference];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
	_imageHintImageView.image = [self getCurrentClue].imageHint;
}

-(Clue *)getCurrentClue {
	NSString *currentClueName = [Game getInstance].currentClue;
	for (Clue *obj in [[Game getInstance] cluesArray]){
		if ([[obj name] isEqualToString:currentClueName]){
			return obj;
		}
	}
	
	return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)determineActionButton:(id)sender {
	if([self moveToNextClue]) {
		[self performSegueWithIdentifier:@"unwindToLocation" sender:sender];
	}
	else {
        NSLog(@"Michael help meeeeee***************************");
//        [self performSegueWithIdentifier:@"unwindToWelcome" sender:sender];
	}
}
- (IBAction)restartGameButton:(id)sender {
	[self moveToFirstClue];
	[self performSegueWithIdentifier:@"unwindToWelcome" sender:sender];
}

-(void)moveToFirstClue {
	NSUInteger index = 0;
	Clue *firstClue = [[Game getInstance].cluesArray objectAtIndex:index];
	[Game getInstance].currentClue = firstClue.name;
	
	[self updateCurrentClueInFirebaseWithName:firstClue.name];
}

-(BOOL)moveToNextClue {
	Clue *current = [self getCurrentClue];
	
	NSUInteger index = [[Game getInstance].cluesArray indexOfObject:current];
	
	if(index == [[Game getInstance].cluesArray count]-1) {
		//we done!
        [self alertUserHasWon];
		return NO;
	}
	else {
		index++;
		Clue *nextClue = [[Game getInstance].cluesArray objectAtIndex:index];
		[Game getInstance].currentClue = nextClue.name;
		
		[self updateCurrentClueInFirebaseWithName:nextClue.name];
		
		return YES;
	}
}

-(void)updateCurrentClueInFirebaseWithName:(NSString *) newClueName {
	//update in firebase
	[dbRef updateChildValues:@{[NSString stringWithFormat:@"%@/currentClue", [Game getInstance].name]: newClueName}
		 withCompletionBlock:^(NSError *error, FIRDatabaseReference *ref) {
			 if (error) {
				 NSLog(@"Data could not be saved: %@", error);
			 } else {
				 NSLog(@"Data saved successfully.");
			 }
		 }];
}


- (void)alertUserHasWon{
   
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Win" message:@"Your the Best!!!!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Play Again?"
                                                    style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        [self moveToFirstClue];
//                                                        [self updateCurrentClueInFirebaseWithName:firstClue.name];
                                                        [self performSegueWithIdentifier:@"unwindToWelcome" sender: self];
                                                    }];
        [alert addAction:firstAction];
    alert.view.backgroundColor = [UIColor redColor];
    alert.view.tintColor = [UIColor orangeColor];
//    alert.view.layer.cornerRadius = 0.5 * [alert.view.bounds.size.width];
        [self presentViewController:alert animated:YES completion:nil];
    
}

@end
