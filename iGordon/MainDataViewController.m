//
//  ViewController.m
//  iGordon
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
@property (nonatomic) UIButton *btnDoneReordering;


@end



@implementation MainDataViewController


@synthesize userProfile = _userProfile;
@synthesize tableViewData = _tableViewData;
@synthesize endPointsDictionary = _endPointsDictionary;
@synthesize userTablePreferences = _userTablePreferences;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    
    
    
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
    chapelCreditEndPoint.image= @"chapel.png" ;
    
    EndPoint *mealPointsEndPoint = [[EndPoint alloc]init];
    
    mealPointsEndPoint.name = @"mealpoints";
    mealPointsEndPoint.cellDescription = @"MEALPOINTS" ;
    mealPointsEndPoint.color = @"orangeColor" ;
    mealPointsEndPoint.image= @"silverware.png" ;
    
    EndPoint *mealPointsPerDayEndPoint = [[EndPoint alloc]init];
    
    mealPointsPerDayEndPoint.name = @"mealpointsperday";
    mealPointsPerDayEndPoint.cellDescription = @"MEALPOINTS LEFT/DAY" ;
    mealPointsPerDayEndPoint.color = @"purpleColor" ;
    mealPointsPerDayEndPoint.image= @"calculator.png" ;
    
    EndPoint *daysleftInSemesterEndPoint = [[EndPoint alloc]init];
    
    daysleftInSemesterEndPoint.name = @"daysleftinsemester";
    daysleftInSemesterEndPoint.cellDescription = @"DAYS LEFT IN SEMESTER" ;
    daysleftInSemesterEndPoint.color = @"greenColor" ;
    daysleftInSemesterEndPoint.image= @"calendar.png" ;
    
    EndPoint *studentIdEndPoint = [[EndPoint alloc]init];
    
    studentIdEndPoint.name = @"studentid";
    studentIdEndPoint.cellDescription = @"STUDENT ID" ;
    studentIdEndPoint.color = @"redColor" ;
    studentIdEndPoint.image= @"person.png" ;
    
    EndPoint *temperatureEndPoint = [[EndPoint alloc]init];
    
    temperatureEndPoint.name = @"temperature";
    temperatureEndPoint.cellDescription = @"TEMPERATURE" ;
    temperatureEndPoint.color = @"blueColor" ;
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
    
   
    self.btnDoneReordering = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnDoneReordering.frame = CGRectMake(20, self.view.frame.size.height - 50 + 5, self.view.frame.size.width - 20 - 20, 50 - 10);
    [self.btnDoneReordering setTitle:@"Done" forState:UIControlStateNormal];
    [self.btnDoneReordering setHidden:YES];
    [self.btnDoneReordering addTarget:self action:@selector(deactivateEditionAtTableView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnDoneReordering];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateViewWithNotification:)
                                                 name:@"dataRetrievedFromServer"
                                               object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTableAfterUpdateAtUserPreferences:)
                                                 name:@"userPreferencesUpdated"
                                               object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(activatesReorderingFromPopoverNotification)
                                                 name:@"enableReorderingAtMainView"
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

     NSIndexPath* indexPath = [NSIndexPath indexPathForRow:(long)[self.userTablePreferences indexOfObject:[keyUserInfo objectAtIndex:0]]inSection:0];

    
     NSArray* indexArray = [NSArray arrayWithObjects:indexPath, nil];
    

    
     [self.tableViewData beginUpdates];
    
     [self.tableViewData reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
    
     [self.tableViewData endUpdates];
    
    
    
}

-(void)activatesReorderingFromPopoverNotification{
    
    [self.btnDoneReordering setHidden:NO];
    [self.tableViewData setEditing:YES animated:YES];
    
}

-(void)deactivateEditionAtTableView{
    [self.tableViewData setEditing:NO animated:YES];
    [self.btnDoneReordering setHidden:YES];
}


-(void)updateTableAfterUpdateAtUserPreferences:(NSNotification *)notification{
    
   
    NSMutableArray *tempUserPreferencesChanges = [[notification userInfo] objectForKey:@"userPreferences"];
    
    NSMutableArray *copyOfUserTablePreferences = [self.userTablePreferences mutableCopy];
    
    
    
    for(NSObject *obj in tempUserPreferencesChanges){
        
        
        
        if(![copyOfUserTablePreferences containsObject:obj]) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:(long)[tempUserPreferencesChanges indexOfObject:obj]inSection:0];
            
            [self.userTablePreferences insertObject:obj atIndex:indexPath.row];
            [self.tableViewData insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
    
    for(NSObject *obj in copyOfUserTablePreferences){
        
        
        
        if(![tempUserPreferencesChanges containsObject:obj]){
            
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:(long)[self.userTablePreferences indexOfObject:obj]inSection:0];
            
            
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
    return [self.userTablePreferences count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.tableViewData = tableView;
    static NSString *simpleTableIdentifier = @"tableCellDesignUserDataOptions";
    
    TableViewCellUserData *cell = (TableViewCellUserData *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"tableCellDesignForUserDataOptions" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    EndPoint  *tempEndPoint =  [self.endPointsDictionary objectForKey:[self.userTablePreferences objectAtIndex:indexPath.row]];
 
    cell.activRequestOnServer.hidden = YES ;
    cell.dataDescriptionLabel.text = tempEndPoint.cellDescription;
    cell.thumbnailImageView.image = [UIImage imageNamed:tempEndPoint.image];
    
    SEL selector = NSSelectorFromString(tempEndPoint.color);
    cell.thumbnailImageView.backgroundColor = [UIColor  performSelector:selector];
    cell.backgroundColor = [UIColor performSelector:selector];
    cell.dataDescriptionLabel.textColor = [UIColor whiteColor];
    cell.dataResultFromServerLabel.textColor = [UIColor whiteColor];
    cell.dataResultFromServerLabel.text = [NSString stringWithFormat:@"%@",tempEndPoint.value == nil ? @"-" : tempEndPoint.value];
        
    
    return cell;


}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.tableViewData = tableView;
    
    [[self.endPointsDictionary objectForKey:[self.userTablePreferences objectAtIndex:indexPath.row]] loadDataFromServer:self.userProfile];
    
    
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
  commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
   forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.userTablePreferences removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
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
