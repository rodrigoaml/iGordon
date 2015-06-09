//
//  ViewController.m
//  iGordon
//
//  Class main functions are: Show the Results on a tableView ;
//  Offer to Popover: AddEdit ; Options
//                    Add/Edit - Gives the user a chance to select
//                     only the relevant endpoints from server,
//                     i.e: Chapel Credits, Meal Points, etc.
//
//                     Option - Show options as links to Gordon
//                      websites, logout and reorder the table.
//
//  Created by Rodrigo Amaral on 5/19/15.
//  Copyright (c) 2015 Gordon College. All rights reserved.
//

#import "MainDataViewController.h"
#import "TableViewCellUserData.h"
#import "PopoverViewController.h"
#import "EndPoint.h"
#import "UserPreferencesViewController.h"

@interface MainDataViewController () <UIPopoverPresentationControllerDelegate>


@property (nonatomic, weak) UITableView *tableViewData ;

@property (nonatomic, strong) NSMutableArray *userTablePreferences;
@property (nonatomic) UIBarButtonItem *btnShowAddOption;
@property (nonatomic) UIBarButtonItem *btnReorder;
@end



@implementation MainDataViewController


@synthesize userProfile = _userProfile;
@synthesize tableViewData = _tableViewData;
@synthesize endPointsDictionary = _endPointsDictionary;
@synthesize userTablePreferences = _userTablePreferences;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.btnShowAddOption = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
                                                                          action:@selector(btnShowPopoverAddRemove:)];

    
   // UIButton *btnCustomReorder=[UIButton buttonWithType:UIButtonTypeCustom];
   // [btnCustomReorder setFrame:CGRectMake(10.0, 2.0, 45.0, 40.0)];
    
   // [btnCustomReorder setImage:[UIImage imageNamed:@"listIcon.png"] forState:UIControlStateNormal];
   // [btnCustomReorder addTarget:self action:@selector(activateReorder) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.btnReorder = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self
                                                                 action:@selector(activateReorder)];
   
    
    
    // self.btnReorder = [[UIBarButtonItem alloc] initWithCustomView:btnCustomReorder];
    
    
     
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:self.btnShowAddOption, self.btnReorder, nil]];
    
    
    
    
    
    self.userTablePreferences = [[NSMutableArray alloc] init];
    [self.userTablePreferences addObjectsFromArray:@[@"chapelcredits",
                                                        @"mealpoints",
                                                        @"mealpointsperday",
                                                        @"daysleftinsemester",
                                                        @"studentid",
                                                        @"temperature"]];
    
    EndPoint *chapelCreditEndPoint = [[EndPoint alloc]init];
    
    chapelCreditEndPoint.name = @"chapelcredits";
    chapelCreditEndPoint.cellDescription = @"CL&W credits" ;
    chapelCreditEndPoint.color = @"blueColor" ;
    chapelCreditEndPoint.colorRGB = @[[NSNumber numberWithDouble:11/255.0],[NSNumber numberWithDouble:54/255.0],[NSNumber numberWithDouble:112/255.0]];
    chapelCreditEndPoint.image= @"chapel.png" ;
    
    EndPoint *mealPointsEndPoint = [[EndPoint alloc]init];
    
    mealPointsEndPoint.name = @"mealpoints";
    mealPointsEndPoint.cellDescription = @"MEALPOINTS" ;
    mealPointsEndPoint.color = @"orangeColor" ;
    mealPointsEndPoint.colorRGB = @[[NSNumber numberWithDouble:236/255.0],[NSNumber numberWithDouble:147/255.0],[NSNumber numberWithDouble:34/255.0]];
    mealPointsEndPoint.image= @"silverware.png" ;
    
    EndPoint *mealPointsPerDayEndPoint = [[EndPoint alloc]init];
    
    mealPointsPerDayEndPoint.name = @"mealpointsperday";
    mealPointsPerDayEndPoint.cellDescription = @"MEALPOINTS LEFT/DAY" ;
    mealPointsPerDayEndPoint.color = @"purpleColor" ;
    mealPointsPerDayEndPoint.colorRGB = @[[NSNumber numberWithDouble:130/255.0],[NSNumber numberWithDouble:54/255.0],[NSNumber numberWithDouble:178/255.0]];
    mealPointsPerDayEndPoint.image= @"calculator.png" ;
    
    EndPoint *daysleftInSemesterEndPoint = [[EndPoint alloc]init];
    
    daysleftInSemesterEndPoint.name = @"daysleftinsemester";
    daysleftInSemesterEndPoint.cellDescription = @"DAYS LEFT IN SEMESTER" ;
    daysleftInSemesterEndPoint.color = @"greenColor" ;
    daysleftInSemesterEndPoint.colorRGB = @[[NSNumber numberWithDouble:88/255.0],[NSNumber numberWithDouble:248/255.0],[NSNumber numberWithDouble:151/255.0]];
    daysleftInSemesterEndPoint.image= @"calendar.png" ;
    
    EndPoint *studentIdEndPoint = [[EndPoint alloc]init];
    
    studentIdEndPoint.name = @"studentid";
    studentIdEndPoint.cellDescription = @"STUDENT ID" ;
    studentIdEndPoint.color = @"redColor" ;
    studentIdEndPoint.colorRGB = @[[NSNumber numberWithDouble:236/255.0],[NSNumber numberWithDouble:90/255.0],[NSNumber numberWithDouble:91/255.0]];
    studentIdEndPoint.image= @"person.png" ;
    
    EndPoint *temperatureEndPoint = [[EndPoint alloc]init];
    
    temperatureEndPoint.name = @"temperature";
    temperatureEndPoint.cellDescription = @"TEMPERATURE" ;
    temperatureEndPoint.color = @"blueColor" ;
    temperatureEndPoint.colorRGB = @[[NSNumber numberWithDouble:71/255.0],[NSNumber numberWithDouble:212/255.0],[NSNumber numberWithDouble:201/255.0]];
    temperatureEndPoint.image= @"thermometer.png" ;
    
    self.endPointsDictionary = [NSMutableDictionary
            dictionaryWithDictionary:@{
                                      [NSString stringWithFormat:@"%@",chapelCreditEndPoint.name ]: chapelCreditEndPoint,
                                      [NSString stringWithFormat:@"%@",mealPointsEndPoint.name] : mealPointsEndPoint,
                                      [NSString stringWithFormat:@"%@",mealPointsPerDayEndPoint.name] : mealPointsPerDayEndPoint,
                                      [NSString stringWithFormat:@"%@", daysleftInSemesterEndPoint.name] : daysleftInSemesterEndPoint,
                                      [NSString stringWithFormat:@"%@", studentIdEndPoint.name ]: studentIdEndPoint,
                                      [NSString stringWithFormat:@"%@", temperatureEndPoint.name ]: temperatureEndPoint
                                       
                                       }];
    
   

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateViewWithNotification:)
                                                 name:@"dataRetrievedFromServer"
                                               object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTableAfterChangesAtUserPreferences:)
                                                 name:@"userPreferencesUpdated"
                                               object:nil];
    
    
    //used to make the table get closer to the navigation bar
    self.automaticallyAdjustsScrollViewInsets = NO;
        
}



-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    
     self.navigationItem.hidesBackButton = YES;
    
}



-(void)updateViewWithNotification:(NSNotification *)notification
{
    
     NSArray *keyUserInfo = [[notification userInfo] allKeys];

     NSIndexPath* indexPath = [NSIndexPath indexPathForRow:(long)[self.userTablePreferences
                                                                  indexOfObject:[keyUserInfo objectAtIndex:0]]inSection:0];

    
     NSArray* indexArray = [NSArray arrayWithObjects:indexPath, nil];
    
    
     [self.tableViewData beginUpdates];
    
     [self.tableViewData reloadRowsAtIndexPaths:indexArray
                                                withRowAnimation:UITableViewRowAnimationFade];
    
     [self.tableViewData endUpdates];
    
}



-(void)activateReorder{
    if([self.tableViewData isEditing]){
        
        [self.tableViewData setEditing:NO animated:YES];
        
    }else{
        
        [self.tableViewData setEditing:YES animated:YES];
        
    }
}



-(void)updateTableAfterChangesAtUserPreferences:(NSNotification *)notification{
    
   
    NSMutableArray *tempUserPreferencesChanges = [[notification userInfo] objectForKey:@"userPreferences"];
    
    NSMutableArray *copyOfUserTablePreferences = [self.userTablePreferences mutableCopy];
    
    //adding new Options
    for(NSObject *obj in tempUserPreferencesChanges){
        
        
        
        if(![copyOfUserTablePreferences containsObject:obj]) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:(long)[tempUserPreferencesChanges
                                                                         indexOfObject:obj]inSection:0];
            
            [self.userTablePreferences insertObject:obj atIndex:indexPath.row];
            [self.tableViewData insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
    //removing unchecked/deleted options
    for(NSObject *obj in copyOfUserTablePreferences){
        
        
        if(![tempUserPreferencesChanges containsObject:obj]){
            
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:(long)[self.userTablePreferences
                                                                              indexOfObject:obj]inSection:0];
            
            
            [self.userTablePreferences removeObjectAtIndex:indexPath.row];
            [self.tableViewData deleteRowsAtIndexPaths:@[indexPath]
                                      withRowAnimation:UITableViewRowAnimationFade];
            
        }
    }
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


- (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableViewData = tableView;
    return [self.userTablePreferences count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *simpleTableIdentifier = @"tableCellDesignUserDataOptions";
    
    TableViewCellUserData *cell = (TableViewCellUserData *)[tableView dequeueReusableCellWithIdentifier:
                                                                                  simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"tableCellDesignForUserDataOptions" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    EndPoint  *tempEndPoint =  [self.endPointsDictionary objectForKey:[self.userTablePreferences objectAtIndex:indexPath.row]];
 
    cell.activRequestOnServer.hidden = YES ;
    cell.dataDescriptionLabel.text = tempEndPoint.cellDescription;
    cell.thumbnailImageView.image = [UIImage imageNamed:tempEndPoint.image];
    
    UIColor *backGroundCellImg = [UIColor colorWithRed:[[tempEndPoint.colorRGB objectAtIndex:0] doubleValue]
                                                 green:[[tempEndPoint.colorRGB objectAtIndex:1] doubleValue]
                                                  blue:[[tempEndPoint.colorRGB objectAtIndex:2] doubleValue]
                                                 alpha:1];
    

    cell.thumbnailImageView.backgroundColor = backGroundCellImg;

    cell.backgroundColor = backGroundCellImg;
    
    cell.dataDescriptionLabel.textColor = [UIColor whiteColor];
    
    cell.dataResultFromServerLabel.textColor = [UIColor whiteColor];
    cell.dataResultFromServerLabel.text = [NSString stringWithFormat:@"%@",tempEndPoint.value == nil
                                                                        ? @"-" : tempEndPoint.value];
        
    
    return cell;


}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.tableViewData.frame.size.height / [self.userTablePreferences count])-5;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[self.endPointsDictionary objectForKey:[self.userTablePreferences objectAtIndex:indexPath.row]]
                                             loadDataFromServer:self.userProfile];
    
    
    TableViewCellUserData *cell = (TableViewCellUserData *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"tableCellDesignForUserDataOptions" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.activRequestOnServer.hidden = NO ;
    [cell.activRequestOnServer startAnimating];
    
}


- (void)   tableView:(UITableView *)tableView
  moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
         toIndexPath:(NSIndexPath *)destinationIndexPath
{
   
    id object = [self.userTablePreferences objectAtIndex:sourceIndexPath.row] ;
    [self.userTablePreferences removeObjectAtIndex:sourceIndexPath.row];
    [self.userTablePreferences insertObject:object atIndex:destinationIndexPath.row];
    
}



//configure the object to show the popover "Options or Add"
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showViewOptions"])
    {
      
        UIViewController *destNav = (PopoverViewController *)segue.destinationViewController;
        destNav.preferredContentSize = CGSizeMake(200, 170);
       
        
        UIPopoverPresentationController *popPC = destNav.popoverPresentationController;

        
        popPC.sourceRect = CGRectMake(270, 15, 5, 10);
       
        popPC.delegate = self;
        
        
        
    }else if([segue.identifier isEqualToString:@"showAddOptions"])
    {
        
        UserPreferencesViewController *destNav = (UserPreferencesViewController *)segue.destinationViewController;
        destNav.preferredContentSize = CGSizeMake(270, 300);
        destNav.userSelectedOptions = [self.userTablePreferences mutableCopy] ;
        
        
        UIPopoverPresentationController *popPC = destNav.popoverPresentationController;
        
        popPC.barButtonItem = self.btnShowAddOption;
        popPC.sourceRect = CGRectMake(270, 15, 5, 10);
        
        popPC.delegate = self;
        
        
        
    }
   
    
    
}



- (UIModalPresentationStyle) adaptivePresentationStyleForPresentationController: (UIPresentationController * ) controller {
    return UIModalPresentationNone;
}


- (IBAction)btnShowPopoverOptions:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"showViewOptions" sender:self];
    
}

- (IBAction)btnShowPopoverAddRemove:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"showAddOptions" sender:self];
}

//dismiss the popover before updating the table
- (IBAction)dismissFromAddPopover:(UIStoryboardSegue *)segue {
    
    if (![segue.sourceViewController isBeingDismissed]) {
        [segue.sourceViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    
    
}



@end
