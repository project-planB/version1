//
//  SharedPicsViewCell.h
//  ArtisticB
//
//  Created by Nicholas Kim on 2014. 11. 24..
//  Copyright (c) 2014년 ___NicholasKim___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharedPicsViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *txtName;
@property (weak, nonatomic) IBOutlet UILabel *txtBirthday;
@property (weak, nonatomic) IBOutlet UILabel *txtNationality;
@property (weak, nonatomic) NSString *txtProfilePicturePath;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (nonatomic, strong) IBOutlet UIView *container;

- (void)setRoundCorners:(BOOL)round;
- (CGSize)intrinsicContentSize;

@end
