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
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 5.0;
    
    NSInteger indexOfProfile = [self.dbManager.arrColumnNames indexOfObject:@"profile"];
    //    UIImage *img = [UIImage imageWithContentsOfFile:[[self.arrTest objectAtIndex:indexPath.row] objectAtIndex:indexOfProfile]]; //For real case
    UIImage *img = [UIImage imageNamed:[[self.arrTest objectAtIndex:indexPath.row] objectAtIndex:indexOfProfile]]; //For Test
    if(img != nil) {
        cell.profilePicture.image = img;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self itemSelected:indexPath];
}

- (void)initializeDatabase {
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"albumdb.sql"];
    
    NSString *query = @"delete from albumInfo";
    [self.dbManager executeQuery:query];
    
    for(int i=0;i<100;i++) {
        query = [NSString stringWithFormat:@"insert into albumInfo values(null, '%@', '%@', '%@', '%@')", @"Who", @"Where", @"1980-11-05", @"sample.jpg"];
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
    UICollectionViewLayoutAttributes *attributes = [self.tblSharedPics layoutAttributesForItemAtIndexPath:idx];
    self.cellRect = CGRectMake(attributes.frame.origin.x, self.tblSharedPics.frame.origin.y + attributes.frame.origin.y - self.tblSharedPics.contentOffset.y, attributes.frame.size.width, attributes.frame.size.height);
    self.content.container.frame = self.cellRect;
    NSInteger indexOfProfile = [self.dbManager.arrColumnNames indexOfObject:@"profile"];
    //    UIImage *img = [UIImage imageWithContentsOfFile:[[self.arrTest objectAtIndex:indexPath.row] objectAtIndex:indexOfProfile]]; //For real case
    UIImage *img = [UIImage imageNamed:[[self.arrTest objectAtIndex:idx.row] objectAtIndex:indexOfProfile]]; //For Test
    if(img != nil) {
        //        self.content.picture.image = img;
    }
    [self.view addSubview:self.content.view];
    [self.view bringSubviewToFront:self.content.container];
    [self animateContent:YES];
}

- (IBAction)goBack:(id)sender {
    [self animateContent:NO];
}

- (void)animateContent:(BOOL)expand {
    [self.content.menuBar setHidden:NO];
    CGRect frame = self.content.container.frame;
    CGFloat opacity = self.content.menuBar.alpha;
    if(expand) {
        frame.origin.x = 0;
        frame.origin.y = 20 + self.content.menuBar.frame.size.height;
        frame.size.width = self.view.frame.size.width;
        opacity = 1;
    } else {
        frame = self.cellRect;
        opacity = 0;
    }
    
    [UIView animateWithDuration:0.25
                          delay:0.0
         usingSpringWithDamping:1.5
          initialSpringVelocity:0.8
                        options:(UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         self.content.container.frame = frame;
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
