//
//  FirstViewController.m
//  ArtisticB
//
//  Created by Nicholas Kim on 2014. 11. 22..
//  Copyright (c) 2014년 ___NicholasKim___. All rights reserved.
//

#import "FirstViewController.h"
#import "SharedPicsViewCell.h"
#import "DBManager.h"

@interface FirstViewController ()

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrTest;
@property (nonatomic) CGRect cellRect;
@property (nonatomic) SharedPicsViewCell *datasetCell;
@property (nonatomic, strong) NSMutableArray *cellSizes;

@end

@implementation FirstViewController

@synthesize tblSharedPics;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initializeDatabase];
    self.content = (ContentViewController*)[self.storyboard
                                            instantiateViewControllerWithIdentifier:@"contentView"];
    [self addChildViewController:self.content];
    self.content.view.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrTest.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"picCell";
    
    SharedPicsViewCell *cell = (SharedPicsViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSInteger indexOfProfile = [self.dbManager.arrColumnNames indexOfObject:@"profile"];
    UIImage *img = [UIImage imageNamed:[[self.arrTest objectAtIndex:indexPath.row] objectAtIndex:indexOfProfile]]; //For Test
    [cell setImage:img];
    [cell setRoundCorners:YES];
    NSLog(@"%f  %f" , cell.profilePicture.frame.size.width, cell.profilePicture.frame.size.height);
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self itemSelected:indexPath];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSMutableArray *)cellSizes {
    if (!_cellSizes) {
        NSInteger indexOfProfile = [self.dbManager.arrColumnNames indexOfObject:@"profile"];
        _cellSizes = [NSMutableArray array];
        for (NSInteger i = 0; i < self.arrTest.count; i++) {
            UIImage *img = [UIImage imageNamed:[[self.arrTest objectAtIndex:i] objectAtIndex:indexOfProfile]]; //For Test
            CGSize size = CGSizeMake(140, img.size.height*140/img.size.width);
            
            _cellSizes[i] = [NSValue valueWithCGSize:size];
        }
    }
    return _cellSizes;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [self.cellSizes[indexPath.item] CGSizeValue];
//}

- (NSInteger)col

- (void)initializeDatabase {
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"albumdb.sql"];
    
    NSString *query = @"delete from albumInfo";
    [self.dbManager executeQuery:query];
    NSArray *imgs = [[NSArray alloc] initWithObjects:@"IMG_0009.JPG", @"IMG_0091.jpg",@"IMG_0851.JPG", @"sample.png", nil];
    for(int i=0;i<100;i++) {
        query = [NSString stringWithFormat:@"insert into albumInfo values(null, '%@', '%@', '%@', '%@')", @"Who", @"Where", @"1980-11-05", [imgs objectAtIndex:i%3]];
        // Execute the query.
        [self.dbManager executeQuery:query];
    }
    query = @"select * from albumInfo";
    
    // Get the results.
    if (self.arrTest != nil) {
        self.arrTest = nil;
    }
    self.arrTest = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
}

- (void)itemSelected:(NSIndexPath*)idx {
    self.datasetCell = (SharedPicsViewCell *)[self.tblSharedPics cellForItemAtIndexPath:idx];
    self.cellRect = self.datasetCell.frame;
    [self.view addSubview:self.content.view];
    [self.tblSharedPics bringSubviewToFront:self.datasetCell];
    [self animateContent:YES];
    [self.datasetCell setRoundCorners:NO];
}

- (IBAction)goBack:(id)sender {
    [self.datasetCell setRoundCorners:YES];
    [self animateContent:NO];
}

- (void)animateContent:(BOOL)expand {
    [self.content.menuBar setHidden:NO];
    CGRect frame = self.content.container.frame;
    CGRect frameForPic = CGRectMake(0, 0, frame.size.width, frame.size.height);
    CGFloat opacity = self.content.menuBar.alpha;
    if(expand) {
        frame.origin.x = 0;
        frame.origin.y = self.content.menuBar.frame.size.height + self.tblSharedPics.contentOffset.y;
        frame.size.width = self.view.frame.size.width;
        frame.size.height = self.view.frame.size.height;
        opacity = 1;
    } else {
        frame = self.cellRect;
        frameForPic = CGRectMake(0, 0, frame.size.width, frame.size.height);
        opacity = 0;
    }
    
    [UIView animateWithDuration:0.6
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:4
                        options:0
                     animations:^{
                         self.datasetCell.frame = frame;
                         self.datasetCell.profilePicture.frame = frameForPic;
                         self.content.menuBar.alpha = opacity;
                     }
                     completion:^(BOOL finished){
                         if(expand) {
                         } else {
                             [self.content.view removeFromSuperview];
                             [self.content.menuBar setHidden:YES];
                         }
                     }];
}

@end
