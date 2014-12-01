//
//  AlbumListViewController.h
//  ArtisticB
//
//  Created by Nicholas Kim on 2014. 11. 30..
//  Copyright (c) 2014년 ___NicholasKim___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePicker.h"

@protocol AlbumListViewControllerDelegate

-(void)backFromAlbumList;

@end

@interface AlbumListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) id<AlbumListViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tblPhotos;
@property (weak, nonatomic) IBOutlet UILabel *labelNoPhotos;
@property (nonatomic, strong) ImagePicker *imagePicker;
@property (nonatomic) NSString *dbName;
@property (nonatomic) int recordIDToEdit;
@property (nonatomic) BOOL addMode;

@end
