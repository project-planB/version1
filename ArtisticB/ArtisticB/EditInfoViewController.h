//
//  EditInfoViewController.h
//  ArtisticBaby
//
//  Created by Nicholas Kim on 2014. 11. 10..
//  Copyright (c) 2014년 ___NicholasKim___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePicker.h"

@protocol EditInfoViewControllerDelegate

-(void)editingInfoWasFinished;

@end


@interface EditInfoViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) id<EditInfoViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *txtName;

@property (weak, nonatomic) IBOutlet UITextField *txtNationality;

@property (weak, nonatomic) IBOutlet UITextField *txtBirthday;

@property (strong, nonatomic) NSString *txtProfilePicturePath;

@property (nonatomic) int recordIDToEdit;

@property (nonatomic, strong) ImagePicker *imagePicker;
@property (weak, nonatomic) IBOutlet UIButton *profilePicture;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar;

- (IBAction)saveInfo:(id)sender;
- (IBAction)textFieldReturn:(id)sender;
- (IBAction)deleteFromDB:(id)sender;

@end
