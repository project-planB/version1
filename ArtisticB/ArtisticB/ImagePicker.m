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
@synthesize imageInfo;
@synthesize selected;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.selected = NO;
    }
    return self;
}

- (void)setParentViewController:(UIViewController*)parent {
    self.parentView = parent;
}

- (void)addImage
{
    [self.parentView resignFirstResponder];
    self.selected = NO;
    
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
    self.selected = YES;
    self.imageInfo = info;
    self.selectedImage = [self scaleAndRotateImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    [Picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)Picker;
{
    [Picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)scaleAndRotateImage:(UIImage *)image
{
    
    int width = image.size.width;
    int height = image.size.height;
    CGSize size = CGSizeMake(width, height);
    
    CGRect imageRect;
    
    if(image.imageOrientation==UIImageOrientationUp
       || image.imageOrientation==UIImageOrientationDown)
    {
        imageRect = CGRectMake(0, 0, width, height);
    }
    else
    {
        imageRect = CGRectMake(0, 0, height, width);
    }
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if(image.imageOrientation==UIImageOrientationLeft)
    {
        CGContextRotateCTM(context, M_PI / 2);
        CGContextTranslateCTM(context, 0, -width);
    }
    else if(image.imageOrientation==UIImageOrientationRight)
    {
        CGContextRotateCTM(context, - M_PI / 2);
        CGContextTranslateCTM(context, -height, 0);
    }
    else if(image.imageOrientation==UIImageOrientationUp)
    {
        //DO NOTHING
    }
    else if(image.imageOrientation==UIImageOrientationDown)
    {
        CGContextTranslateCTM(context, width, height);
        CGContextRotateCTM(context, M_PI);
    }
    
    CGContextDrawImage(context, imageRect, image.CGImage);
    CGContextRestoreGState(context);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return (img);
}

@end
