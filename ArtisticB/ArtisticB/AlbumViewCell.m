//
//  AlbumViewCell.m
//  ArtisticB
//
//  Created by Nicholas Kim on 2014. 11. 24..
//  Copyright (c) 2014년 ___NicholasKim___. All rights reserved.
//

#import "AlbumViewCell.h"

@implementation AlbumViewCell

@synthesize txtName;
@synthesize txtBirthday;
@synthesize txtNationality;
@synthesize txtProfilePicturePath;
@synthesize profilePicture;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
