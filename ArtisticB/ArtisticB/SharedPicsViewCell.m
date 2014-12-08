//
//  SharedPicsViewCell.m
//  ArtisticB
//
//  Created by Nicholas Kim on 2014. 11. 24..
//  Copyright (c) 2014년 ___NicholasKim___. All rights reserved.
//

#import "SharedPicsViewCell.h"

@implementation SharedPicsViewCell

@synthesize txtName;
@synthesize txtBirthday;
@synthesize txtNationality;
@synthesize txtProfilePicturePath;
@synthesize profilePicture;
@synthesize container;

static CGSize _extraMargins = {0,0};

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(UIView *)viewForBaselineLayout {
    return self;
}

- (void)setRoundCorners:(BOOL)round {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = round ? 5.0 : 0;
}

- (CGSize)intrinsicContentSize
{
    CGSize size = [self.profilePicture intrinsicContentSize];
    
    if (CGSizeEqualToSize(_extraMargins, CGSizeZero))
    {
        // quick and dirty: get extra margins from constraints
        for (NSLayoutConstraint *constraint in self.constraints)
        {
            if (constraint.firstAttribute == NSLayoutAttributeBottom || constraint.firstAttribute == NSLayoutAttributeTop)
            {
                // vertical spacer
                _extraMargins.height += [constraint constant];
            }
            else if (constraint.firstAttribute == NSLayoutAttributeLeading || constraint.firstAttribute == NSLayoutAttributeTrailing)
            {
                // horizontal spacer
                _extraMargins.width += [constraint constant];
            }
        }
    }
    
    // add to intrinsic content size of label
    size.width += _extraMargins.width;
    size.height += _extraMargins.height;
    
    return size;
}

@end
