//
//  AlbumViewCell.h
//  ArtisticB
//
//  Created by Nicholas Kim on 2014. 11. 24..
//  Copyright (c) 2014년 ___NicholasKim___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumViewCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtFirstname;

@end
