//
//  AlbumListViewController.m
//  ArtisticB
//
//  Created by Nicholas Kim on 2014. 11. 30..
//  Copyright (c) 2014년 ___NicholasKim___. All rights reserved.
//

#import "AlbumListViewController.h"
#import "AlbumListViewCell.h"
#import "PhotoViewController.h"
#import "DBManager.h"

@interface AlbumListViewController ()

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrPhotos;

@end

@implementation AlbumListViewController

@synthesize tblPhotos;
@synthesize labelNoPhotos;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.imagePicker = [[ImagePicker alloc] init];
    [self.imagePicker setParentView:self];
    
    // Make self the delegate and datasource of the table view.
    self.tblPhotos.delegate = self;
    self.tblPhotos.dataSource = self;
    
    // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"albumdb.sql"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Load the data.
    [self loadData];
    
    if(self.addMode) {
        [self addPhoto:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    
    // Form the query.
    NSString *query = [NSString stringWithFormat:@"select * from %@", self.dbName];
    
    // Get the results.
    if (self.arrPhotos != nil) {
        self.arrPhotos = nil;
    }
    self.arrPhotos = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.tblPhotos reloadData];
}

- (void)savePhoto {
    
    long currentTime = (long)(NSTimeInterval)([[NSDate date] timeIntervalSince1970]);
    
    // Then get the file name.
    NSString *imageName = [NSString stringWithFormat:@"%ld", currentTime];
    NSString *path = [self documentsPathForFileName:[NSString stringWithFormat:@"%@.png", imageName]];
    if(self.imagePicker.selectedImage != nil) {
        NSData *pngData = UIImagePNGRepresentation(self.imagePicker.selectedImage);
        [pngData writeToFile:path atomically:YES]; //Write the file
        self.imagePicker.selectedImage = nil;
    }
    
    NSString *query;
    query = [NSString stringWithFormat:@"insert into %@ values(null, '%@', '%@', '%@')", self.dbName, path, @"TITLE", @"STORY"];
    [self.dbManager executeQuery:query];
    [self loadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"%@", segue.identifier);
    if([segue.identifier compare:@"idSegueShowPhoto"] == 0) {
        PhotoViewController *photoViewController = [segue destinationViewController];
        NSInteger indexOfFileName = [self.dbManager.arrColumnNames indexOfObject:@"filename"];

        NSInteger idx = [[self.tblPhotos indexPathForSelectedRow] row];
        NSLog(@"%@", [[self.arrPhotos objectAtIndex:idx] objectAtIndex:indexOfFileName]);
        photoViewController.sentImage = [UIImage imageWithContentsOfFile:[[self.arrPhotos objectAtIndex:idx] objectAtIndex:indexOfFileName]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.delegate backFromAlbumList];
}

- (IBAction)addPhoto:(id)sender {
    [self.imagePicker addImage];
}

- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}

-(void)viewDidAppear:(BOOL)animated {
    if(self.imagePicker.selected) {
        self.imagePicker.selected = NO;
        [self savePhoto];
    }
    [self loadData];
    [super viewDidAppear:YES];
}


#pragma mark - UITableView method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.arrPhotos.count > 0) {
        [self.labelNoPhotos setHidden:YES];
    } else {
        [self.labelNoPhotos setHidden:NO];
    }
    return self.arrPhotos.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    AlbumListViewCell *cell = (AlbumListViewCell *)[tableView dequeueReusableCellWithIdentifier:@"idCellPhoto" forIndexPath:indexPath];
    
    NSInteger indexOfFileName = [self.dbManager.arrColumnNames indexOfObject:@"filename"];
    NSInteger indexOfTitle = [self.dbManager.arrColumnNames indexOfObject:@"title"];
    cell.txtName.text = [[self.arrPhotos objectAtIndex:indexPath.row] objectAtIndex:indexOfTitle];
    cell.profilePicture.image = [UIImage imageWithContentsOfFile:[[self.arrPhotos objectAtIndex:indexPath.row] objectAtIndex:indexOfFileName]];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}


@end
