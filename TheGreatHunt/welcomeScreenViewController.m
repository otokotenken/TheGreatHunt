//
//  welcomeScreenViewController.m
//  TheGreatHunt
//
//  Created by ling toby on 6/13/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "welcomeScreenViewController.h"

@interface welcomeScreenViewController ()

@end

@implementation welcomeScreenViewController

Clue *currentClue;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	currentClue = [self getCurrentClue];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(Clue *)getCurrentClue {
	NSString *currentClueName =[[Game getInstance] currentClue];
	for (Clue *obj in [[Game getInstance] cluesArray]){
		if ([[obj name] isEqualToString:currentClueName]){
			return obj;
		}
	}
	
	return nil;
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
