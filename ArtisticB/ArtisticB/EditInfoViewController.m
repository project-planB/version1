//
//  EditInfoViewController.m
//  ArtisticBaby
//
//  Created by Nicholas Kim on 2014. 11. 10..
//  Copyright (c) 2014년 ___NicholasKim___. All rights reserved.
//

#import "EditInfoViewController.h"
#import "DBManager.h"


@interface EditInfoViewController ()

@property (nonatomic, strong) DBManager *dbManager;

-(void)loadInfoToEdit;

@end


@implementation EditInfoViewController

@synthesize datePicker;
@synthesize toolBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Make self the delegate of the textfields.
    self.txtName.delegate = self;
    self.txtNationality.delegate = self;
    self.txtBirthday.delegate = self;

    self.datePicker = [[UIDatePicker alloc]init];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    self.txtBirthday.inputView = self.datePicker;
    
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.toolBar.barStyle = UIBarStyleDefault;
    [self.toolBar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
    [barItems addObject:doneBtn];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
    [barItems addObject:cancelBtn];
    
    [self.toolBar setItems:barItems animated:YES];
    
    self.txtBirthday.inputAccessoryView = self.toolBar;
    
    // Set the navigation bar tint color.
    self.navigationController.navigationBar.tintColor = self.navigationItem.rightBarButtonItem.tintColor;
    
    // Initialize the dbManager object.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"albumdb.sql"];
    NSLog(@"selected id in editview %d", self.recordIDToEdit);
    // Check if should load specific record for editing.
    if (self.recordIDToEdit != -1) {
        // Load the record with the specific ID from the database.
        [self loadInfoToEdit];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark - UITextFieldDelegate method implementation

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}


#pragma mark - IBAction method implementation

- (IBAction)saveInfo:(id)sender {
    // Prepare the query string.
    // If the recordIDToEdit property has value other than -1, then create an update query. Otherwise create an insert query.
    NSString *query;
    if (self.recordIDToEdit == -1) {
        query = [NSString stringWithFormat:@"insert into albumInfo values(null, '%@', '%@', '%@')", self.txtName.text, self.txtNationality.text, self.txtBirthday.text];
    }
    else{
        query = [NSString stringWithFormat:@"update albumInfo set name='%@', nationality='%@', birthday='%@' where albumInfoID=%d", self.txtName.text, self.txtNationality.text, self.txtBirthday.text, self.recordIDToEdit];
    }
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        // Inform the delegate that the editing was finished.
        [self.delegate editingInfoWasFinished];
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
}


#pragma mark - Private method implementation

-(void)loadInfoToEdit {
    // Create the query.
    NSString *query = [NSString stringWithFormat:@"select * from albumInfo where albumInfoID=%d", self.recordIDToEdit];
    
    // Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    if(results.count > 0) {
    // Set the loaded data to the textfields.
    self.txtName.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"name"]];
    self.txtNationality.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"nationality"]];
    self.txtBirthday.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"birthday"]];
    } else {
        NSLog(@"%d", self.recordIDToEdit);
        NSLog(@"No results");
    }
}

- (IBAction)deleteFromDB:(id)sender {
    // Create the query.
    NSString *query = [NSString stringWithFormat:@"delete from albumInfo where albumInfoID=%d", self.recordIDToEdit];
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);

        // Inform the delegate that the editing was finished.
        [self.delegate editingInfoWasFinished];
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
}

#pragma mark- UITextField with UIDatePicker

- (void)dateChanged {
    NSDate *date = self.datePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    self.txtBirthday.text = [dateFormat stringFromDate:date];
}

- (IBAction)setDefaultDate:(id)sender {
    
    if([self.txtBirthday.text compare:@"Birthday"]) {
        [self dateChanged];
    } else {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateStyle:NSDateFormatterMediumStyle];
        self.datePicker.date = [dateFormat dateFromString:self.txtBirthday.text];
    }
    
}

- (void)doneButtonPressed {
    [self.txtBirthday resignFirstResponder];
}

- (void)cancelButtonPressed {
    [self.txtBirthday resignFirstResponder];
}

@end
