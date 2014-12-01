//
//  PhotoViewController.m
//  ArtisticB
//
//  Created by Nicholas Kim on 2014. 12. 1..
//  Copyright (c) 2014년 ___NicholasKim___. All rights reserved.
//

#import "PhotoViewController.h"

@implementation PhotoViewController

@synthesize selectedImage;
@synthesize title;
@synthesize sentImage;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.selectedImage.image = self.sentImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
