//
//  AlbumViewController.h
//  ArtisticBaby
//
//  Created by Nicholas Kim on 2014. 10. 29..
//  Copyright (c) 2014년 ___NicholasKim___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditInfoViewController.h"
#import "AlbumListViewController.h"
#import "AlbumViewCell.h"

@interface AlbumViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, EditInfoViewControllerDelegate, AlbumListViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblAlbums;
@property (nonatomic, retain) IBOutlet AlbumViewCell *albumCell;
@property (weak, nonatomic) IBOutlet UILabel *labelNoAlbum;
@property (nonatomic, strong) ImagePicker *imagePicker;
@property (nonatomic) BOOL showAndAdd;

- (IBAction)addNewRecord:(id)sender;
- (IBAction)editRecord:(id)sender;
@end

