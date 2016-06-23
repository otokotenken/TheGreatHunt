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

@property (weak, nonatomic) IBOutlet UIButton *nextClueButton;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageHintImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseFromLibraryButton;

@end

@implementation PhotoClueViewController
FIRDatabaseReference *dbRef;
UIImagePickerController *appImagePicker;

- (void)viewDidLoad {
    [super viewDidLoad];
	dbRef = [[FIRDatabase database] reference];
    // Do any additional setup after loading the view.
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        appImagePicker = [self createAppImagePicker];
    } else {
        appImagePicker = [self createAppImagePicker];
    }
    
    
    _nextClueButton.layer.cornerRadius = 15;
    _nextClueButton.layer.borderColor = [[UIColor colorWithRed:249.0/255.0f green:190.0/255.0f blue:2.0/255.0f  alpha:1.0]CGColor];
    _nextClueButton.layer.borderWidth = 3.0f;
    
    _restartButton.layer.cornerRadius = 15;
    _restartButton.layer.borderColor = [[UIColor colorWithRed:249.0/255.0f green:190.0/255.0f blue:2.0/255.0f  alpha:1.0]CGColor];
    _restartButton.layer.borderWidth = 3.0f;
    _photoBackImage.alpha = 0.6;
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
    alert.view.tintColor = [UIColor orangeColor];
//    alert.view.layer.cornerRadius = 0.5 * [alert.view.bounds.size.width];
        [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)takePhoto:(id)sender {
    appImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:appImagePicker animated:YES completion:NULL];
}

- (IBAction)choosePhoto:(id)sender {
    appImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:appImagePicker animated:YES completion:NULL];
}

- (UIImagePickerController *)createAppImagePicker {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    return picker;
}

// imagePicker delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    NSString * b64ImgStrURI = [UIImageJPEGRepresentation(chosenImage, 0.25) base64EncodedStringWithOptions:kNilOptions];
    
    b64ImgStrURI = [NSString stringWithFormat:@"data:image/jpeg;base64,%@", b64ImgStrURI];
    
    NSLog(b64ImgStrURI);
    
    _imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
