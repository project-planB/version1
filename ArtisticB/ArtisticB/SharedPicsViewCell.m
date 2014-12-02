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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
    }
    return self;
}

-(UIView *)viewForBaselineLayout {
    
    
    
    
    return self;
}


@end
