//
//  AlbumViewController.h
//  ArtisticBaby
//
//  Created by Nicholas Kim on 2014. 10. 29..
//  Copyright (c) 2014년 ___NicholasKim___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditInfoViewController.h"

@interface AlbumViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, EditInfoViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblAlbums;
@property (nonatomic, retain) IBOutlet UITableViewCell *albumCell;


- (IBAction)addNewRecord:(id)sender;
- (IBAction)editRecord:(id)sender;
@end

