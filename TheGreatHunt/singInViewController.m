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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
