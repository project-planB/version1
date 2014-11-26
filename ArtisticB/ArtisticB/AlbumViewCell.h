//
//  AlbumViewCell.h
//  ArtisticB
//
//  Created by Nicholas Kim on 2014. 11. 24..
//  Copyright (c) 2014년 ___NicholasKim___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *txtName;
@property (weak, nonatomic) IBOutlet UILabel *txtBirthday;
@property (weak, nonatomic) IBOutlet UILabel *txtNationality;

@end
