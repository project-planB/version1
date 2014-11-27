//
//  ImagePicker.h
//  ArtisticB
//
//  Created by Nicholas Kim on 2014. 11. 27..
//  Copyright (c) 2014년 ___NicholasKim___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePicker : UIImagePickerController <UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) UIViewController *parentView;
@property (nonatomic, strong) UIImage *selectedImage;

- (void)addImage;
- (void)setParentViewController:(UIViewController*)parent;

@end
