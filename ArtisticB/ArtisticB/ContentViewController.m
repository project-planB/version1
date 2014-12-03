//
//  ContentViewController.m
//  ArtisticB
//
//  Created by Nicholas Kim on 2014. 12. 3..
//  Copyright (c) 2014년 ___NicholasKim___. All rights reserved.
//

#import "ContentViewController.h"
#import "FirstViewController.h"

@implementation ContentViewController

@synthesize picture;
@synthesize container;
@synthesize menuBar;
@synthesize backButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.container setAutoresizesSubviews:YES];
    [self.picture setAutoresizesSubviews:YES];
    [self.view setAutoresizesSubviews:YES];
    
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.container setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.picture setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)goBack:(id)sender {
    FirstViewController *parent = (FirstViewController*)[self parentViewController];
    [parent goBack:nil];
}


@end
