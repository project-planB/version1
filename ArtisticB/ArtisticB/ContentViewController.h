//
//  ContentViewController.h
//  ArtisticB
//
//  Created by Nicholas Kim on 2014. 12. 3..
//  Copyright (c) 2014년 ___NicholasKim___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UIView *menuBar;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end
