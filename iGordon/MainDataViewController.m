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
@property (nonatomic, strong) NSIndexPath *indexPathData ;
@property (nonatomic, strong) EndPoint *endPointObj ;

@end



@implementation MainDataViewController


@synthesize userProfile = _userProfile;
@synthesize tableViewData = _tableViewData;
@synthesize endPointsDictionary = _endPointsDictionary;


- (EndPoint *)endPointObj
{
    if (!_endPointObj) _endPointObj = [[EndPoint alloc] init];
    return _endPointObj;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    // Initialize table data
    
    
    NSDictionary *endpointDescriptionsAndNames = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     @"CL&W CREDITS", @"chapelcredits",
                                                     @"MEALPOINTS", @"mealpoints",
                                                     @"MEALPOINTS LEFT/DAY", @"mealpointsperday",
                                                     @"DAYS LEFT IN SEMESTER", @"daysleftinsemester",
                                                     @"STUDENT ID", @"studentid",
                                                     @"TEMPERATURE", @"temperature",nil];
   
    
    NSDictionary *endpointViewColorsAndThumbnails = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  @"blueColor", @"chapel.png",
                                                  @"orangeColor", @"silverware.png",
                                                  @"purpleColor", @"calculator.png",
                                                  @"greenColor", @"calendar.png",
                                                  @"redColor", @"person.png",
                                                  @"blueColor", @"thermometer.png",nil];



   
    //Should initialize here the Dictionary with the Endpoint Objects.
    
    /*
    self.endPointsDictionary = [NSMutableDictionary
            dictionaryWithDictionary:@{
                                       @"chapelcredits" : @"-",
                                       @"mealpoints" : @"-",
                                       @"mealpointsperday" : @"-",
                                       @"daysleftinsemester" : @"-",
                                       @"studentid" : @"-",
                                       @"temperature" : @"-"
                                       
                                       }];
    */
   

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
    /*
    
     [self.tableViewData beginUpdates];
     [self.tableViewData reloadRowsAtIndexPaths:@[temp] withRowAnimation:UITableViewRowAnimationFade];
     [self.tableViewData endUpdates];
    
    
    */
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [studentDataOptions count];
    return 0;
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
    /*
    cell.dataDescriptionLabel.text = [studentDataOptions objectAtIndex:indexPath.row];
    cell.thumbnailImageView.image = [UIImage imageNamed:[thumbnails objectAtIndex:indexPath.row]];
    
    SEL selector = NSSelectorFromString([endPointsViewColors objectAtIndex:indexPath.row]);
    cell.thumbnailImageView.backgroundColor = [UIColor  performSelector:selector];
    cell.backgroundColor = [UIColor performSelector:selector];
    cell.dataDescriptionLabel.textColor = [UIColor whiteColor];
    cell.dataResultFromServerLabel.textColor = [UIColor whiteColor];
    cell.dataResultFromServerLabel.text = [endPointsServerData objectAtIndex:indexPath.row];
    */
    
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
