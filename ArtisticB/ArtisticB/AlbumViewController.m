//
//  AlbumViewController.m
//  ArtisticBaby
//
//  Created by Nicholas Kim on 2014. 10. 29..
//  Copyright (c) 2014년 ___NicholasKim___. All rights reserved.
//

#import "AlbumViewController.h"
#import "AlbumViewCell.h"
#import "DBManager.h"

@interface AlbumViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrAlbumInfo;

@property (nonatomic) int recordIDToEdit;
@property (nonatomic) NSString *dbName;

-(void)loadData;

@end

@implementation AlbumViewController

@synthesize albumCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.imagePicker = [[ImagePicker alloc] init];
    
    // Make self the delegate and datasource of the table view.
    self.tblAlbums.delegate = self;
    self.tblAlbums.dataSource = self;
    
    // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"albumdb.sql"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tblAlbums.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
    
    // Load the data.
    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"%@", segue.identifier);
    if([segue.identifier compare:@"idSegueEditInfo"] == 0) {
        EditInfoViewController *editInfoViewController = [segue destinationViewController];
        editInfoViewController.delegate = self;
        editInfoViewController.recordIDToEdit = self.recordIDToEdit;
    } else {
        NSArray *visible = [self.tblAlbums indexPathsForVisibleRows];
        NSIndexPath *indexpath = (NSIndexPath*)[visible objectAtIndex:0];
        NSInteger indexOfDBName = [self.dbManager.arrColumnNames indexOfObject:@"name"];
        self.dbName = [[self.arrAlbumInfo objectAtIndex:indexpath.row] objectAtIndex:indexOfDBName];
        [self createPhotoAlbum];
        AlbumListViewController *albumListViewController = [segue destinationViewController];
//        albumListViewController.delegate = self;
        albumListViewController.dbName = self.dbName;
        albumListViewController.recordIDToEdit = self.recordIDToEdit;
    }
}

#pragma mark - IBAction method implementation

- (IBAction)addNewRecord:(id)sender {
    // Before performing the segue, set the -1 value to the recordIDToEdit. That way we'll indicate that we want to add a new record and not to edit an existing one.
    self.recordIDToEdit = -1;
    
    // Perform the segue.
    [self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];
}

- (IBAction)editRecord:(id)sender {
    // Before performing the segue, set the -1 value to the recordIDToEdit. That way we'll indicate that we want to add a new record and not to edit an existing one.
    NSArray *visible = [self.tblAlbums indexPathsForVisibleRows];
    NSIndexPath *indexpath = (NSIndexPath*)[visible objectAtIndex:0];
    NSInteger indexOfName = [self.dbManager.arrColumnNames indexOfObject:@"albumInfoID"];
    
    self.recordIDToEdit = (int)[[[self.arrAlbumInfo objectAtIndex:indexpath.row] objectAtIndex:indexOfName] integerValue];
    // Perform the segue.
    [self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];
}



#pragma mark - Private method implementation

-(void)loadData{
    // Form the query.
    NSString *query = @"select * from albumInfo";
    
    // Get the results.
    if (self.arrAlbumInfo != nil) {
        self.arrAlbumInfo = nil;
    }
    self.arrAlbumInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.tblAlbums reloadData];
}


#pragma mark - UITableView method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.arrAlbumInfo.count > 0) {
        [self.labelNoAlbum setHidden:YES];
    } else {
        [self.labelNoAlbum setHidden:NO];
    }
    return self.arrAlbumInfo.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    AlbumViewCell *cell = (AlbumViewCell *)[tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
    
    NSInteger indexOfName = [self.dbManager.arrColumnNames indexOfObject:@"name"];
    NSInteger indexOfNationality = [self.dbManager.arrColumnNames indexOfObject:@"nationality"];
    NSInteger indexOfBirthday = [self.dbManager.arrColumnNames indexOfObject:@"birthday"];
    NSInteger indexOfProfile = [self.dbManager.arrColumnNames indexOfObject:@"profile"];
    
    // Set the loaded data to the appropriate cell labels.
    cell.txtName.text = [[self.arrAlbumInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfName];
    cell.txtBirthday.text = [[self.arrAlbumInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfBirthday];
    cell.txtNationality.text = [[self.arrAlbumInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfNationality];
    
    cell.profilePicture.image = [UIImage imageWithContentsOfFile:[[self.arrAlbumInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfProfile]];
    cell.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 320.0;
}


#pragma mark - EditInfoViewControllerDelegate method implementation

-(void)editingInfoWasFinished{
    
    // Reload the data.
    [self loadData];
    
    if(self.recordIDToEdit == -1) {
        int lastRowNumber = [self.tblAlbums numberOfRowsInSection:0] - 1;
        NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
        [self.tblAlbums scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)addToAlbum:(id)sender {
    
    [self createPhotoAlbum];
    [self.imagePicker setParentView:self];
    [self.imagePicker addImage];
}

- (void) createPhotoAlbum {
    NSString *query = [NSString stringWithFormat:@"create table %@(photoID integer primary key, filename text, title text, story text)", self.dbName];
    // Execute the query.
    [self.dbManager executeQuery:query];
}


@end
