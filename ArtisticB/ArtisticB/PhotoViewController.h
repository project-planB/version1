//
//  PhotoViewController.h
//  ArtisticB
//
//  Created by Nicholas Kim on 2014. 12. 1..
//  Copyright (c) 2014년 ___NicholasKim___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) UIImage *sentImage;
@property (nonatomic, strong) IBOutlet UIImageView *selectedImage;

@end
