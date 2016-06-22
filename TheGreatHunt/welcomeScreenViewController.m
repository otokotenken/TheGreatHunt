//
//  welcomeScreenViewController.m
//  TheGreatHunt
//
//  Created by ling toby on 6/13/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "welcomeScreenViewController.h"

@interface welcomeScreenViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startGameButton;

@end

@implementation welcomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _startGameButton.layer.cornerRadius = 15;
    _startGameButton.layer.borderColor = [[UIColor colorWithRed:249.0/255.0f green:190.0/255.0f blue:2.0/255.0f  alpha:1.0]CGColor];
    _startGameButton.layer.borderWidth = 3.0f;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(Clue *)getCurrentClue {
	NSString *currentClueName =[Game getInstance].currentClue;
	for (Clue *obj in [[Game getInstance] cluesArray]){
		if ([[obj name] isEqualToString:currentClueName]){
			return obj;
		}
	}
	
	return nil;
}

- (IBAction)unwindToWelcome:(UIStoryboardSegue *)unwindSegue {
	
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
