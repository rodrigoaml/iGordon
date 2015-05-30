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

@interface MainDataViewController () <UIPopoverPresentationControllerDelegate>


@property (nonatomic, weak) UITableView *tableViewData ;

@property (nonatomic, strong) NSMutableArray *userTablePreferences;

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
    [self.userTablePreferences addObjectsFromArray:@[@"chapelcredits",@"mealpoints", @"mealpointsperday", @"daysleftinsemester", @"studentid", @"temperature"]];
    
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
                                       
                                       
                                       @"chapelcredits" : chapelCreditEndPoint,
                                       @"mealpoints" : mealPointsEndPoint,
                                       @"mealpointsperday" : mealPointsPerDayEndPoint,
                                       @"daysleftinsemester" : daysleftInSemesterEndPoint,
                                       @"studentid" : studentIdEndPoint,
                                       @"temperature" : temperatureEndPoint
                                       
                                       }];
    
   
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateViewWithNotification:)
                                                 name:@"dataRetrievedFromServer"
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

     NSIndexPath* indexPath1 = [NSIndexPath indexPathForRow:(long)[self.userTablePreferences indexOfObject:[keyUserInfo objectAtIndex:0]]inSection:0];

    
     NSArray* indexArray = [NSArray arrayWithObjects:indexPath1, nil];
    
    
    
    
    
     [self.tableViewData beginUpdates];
    
     [self.tableViewData reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
    
     [self.tableViewData endUpdates];
    
    
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.endPointsDictionary count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
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




//configure the object to show the popover "Options"
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showViewOptions"])
    {
      
        UIViewController *destNav = (PopoverViewController *)segue.destinationViewController;
        destNav.preferredContentSize = CGSizeMake(200, 170);
       
        
        
        UIPopoverPresentationController *popPC = destNav.popoverPresentationController;

        
        popPC.sourceRect = CGRectMake(270, 15, 5, 10);
       
        popPC.delegate = self;
        
        
        
    }
}



- (UIModalPresentationStyle) adaptivePresentationStyleForPresentationController: (UIPresentationController * ) controller {
    return UIModalPresentationNone;
}


- (IBAction)btnShowPopover:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"showViewOptions" sender:self];
}
@end
