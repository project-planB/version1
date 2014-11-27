//
//  ImagePicker.m
//  ArtisticB
//
//  Created by Nicholas Kim on 2014. 11. 27..
//  Copyright (c) 2014년 ___NicholasKim___. All rights reserved.
//

#import "ImagePicker.h"

@implementation ImagePicker

@synthesize selectedImage;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)setParentViewController:(UIViewController*)parent {
    self.parentView = parent;
}

- (void)addImage
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Take a new photo", @"Choose from existing", nil];
    [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takeNewPhotoFromCamera];
            break;
        case 1:
            [self choosePhotoFromExistingImages];
        default:
            break;
    }
}

- (void)takeNewPhotoFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.allowsEditing = NO;
        self.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
        [self.parentView presentViewController:self animated:YES completion:nil];
    }
}

-(void)choosePhotoFromExistingImages
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.allowsEditing = NO;
        self.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
        [self.parentView presentViewController:self animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)Picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"%@", [info objectForKey:UIImagePickerControllerReferenceURL]);
    [Picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)Picker;
{
    [Picker dismissViewControllerAnimated:YES completion:nil];
}

@end
