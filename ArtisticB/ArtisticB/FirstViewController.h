//
//  FirstViewController.h
//  ArtisticB
//
//  Created by Nicholas Kim on 2014. 11. 22..
//  Copyright (c) 2014년 ___NicholasKim___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"

@interface FirstViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *tblSharedPics;
@property (nonatomic) ContentViewController *content;

- (IBAction)goBack:(id)sender;

@end

