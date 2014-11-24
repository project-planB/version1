//
//  UIViewController+EditInfoView.h
//  ArtisticBaby
//
//  Created by Nicholas Kim on 2014. 11. 10..
//  Copyright (c) 2014년 ___NicholasKim___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditInfoViewControllerDelegate

-(void)editingInfoWasFinished;

@end


@interface EditInfoViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) id<EditInfoViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *txtFirstname;

@property (weak, nonatomic) IBOutlet UITextField *txtLastname;

@property (weak, nonatomic) IBOutlet UITextField *txtAge;

@property (nonatomic) int recordIDToEdit;


- (IBAction)saveInfo:(id)sender;

@end
