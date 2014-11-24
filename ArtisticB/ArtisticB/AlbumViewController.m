//
//  ViewController.m
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

@property (nonatomic, strong) NSArray *arrPeopleInfo;

@property (nonatomic) int recordIDToEdit;

-(void)loadData;

@end

@implementation AlbumViewController

@synthesize albumCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Make self the delegate and datasource of the table view.
    self.tblPeople.delegate = self;
    self.tblPeople.dataSource = self;
    
    // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sampledb.sql"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tblPeople.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
    
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


#pragma mark - Private method implementation

-(void)loadData{
    // Form the query.
    NSString *query = @"select * from peopleInfo";
    
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.tblPeople reloadData];
}


#pragma mark - UITableView method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrPeopleInfo.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    AlbumViewCell *cell = (AlbumViewCell *)[tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
    
    NSInteger indexOfFirstname = [self.dbManager.arrColumnNames indexOfObject:@"firstname"];
    NSInteger indexOfLastname = [self.dbManager.arrColumnNames indexOfObject:@"lastname"];
    NSInteger indexOfAge = [self.dbManager.arrColumnNames indexOfObject:@"age"];
    
    // Set the loaded data to the appropriate cell labels.
//    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfFirstname], [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfLastname]];
//    
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"Age: %@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfAge]];
//    cell.frame = CGRectMake(0, 0, 320, 320);
    cell.txtFirstname = [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfFirstname];
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
}


@end
