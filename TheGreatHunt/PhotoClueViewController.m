//
//  PhotoClueViewController.m
//  TheGreatHunt
//
//  Created by ling toby on 6/13/16.
//  Copyright © 2016 DetroitLabs. All rights reserved.
//

#import "PhotoClueViewController.h"

@interface PhotoClueViewController ()

@end

@implementation PhotoClueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
