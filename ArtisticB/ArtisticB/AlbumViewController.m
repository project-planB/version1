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

-(void)loadData;

@end

@implementation AlbumViewController

@synthesize albumCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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
    EditInfoViewController *editInfoViewController = [segue destinationViewController];
    editInfoViewController.delegate = self;
    editInfoViewController.recordIDToEdit = self.recordIDToEdit;
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
    
    self.recordIDToEdit = (NSInteger)indexpath.row + 1;
    
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrAlbumInfo.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    AlbumViewCell *cell = (AlbumViewCell *)[tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
    
    NSInteger indexOfName = [self.dbManager.arrColumnNames indexOfObject:@"name"];
    NSInteger indexOfNationality = [self.dbManager.arrColumnNames indexOfObject:@"nationality"];
    NSInteger indexOfBirthday = [self.dbManager.arrColumnNames indexOfObject:@"birthday"];
    
    // Set the loaded data to the appropriate cell labels.
    cell.txtName.text = [[self.arrAlbumInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfName];
    cell.txtBirthday.text = [[self.arrAlbumInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfBirthday];
    NSLog(@"%@",[[self.arrAlbumInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfBirthday]);
    cell.txtNationality.text = [[self.arrAlbumInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfNationality];
    cell.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 320.0;
}


#pragma mark - EditInfoViewControllerDelegate method implementation

-(void)editingInfoWasFinished{
    // Reload the data.
    NSString *query = @"update albumInfo";

    [self.dbManager loadDataFromDB:query];
    [self.tblAlbums reloadData];
    [self loadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


@end
