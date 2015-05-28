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

@interface MainDataViewController () <UIPopoverPresentationControllerDelegate>


@property (nonatomic, weak) UITableView *tableViewData ;
@property (nonatomic, strong) NSIndexPath *indexPathData ;


@end



@implementation MainDataViewController


@synthesize userProfile = _userProfile;
@synthesize responseData = _responseData ;
@synthesize tableViewData = _tableViewData;
@synthesize indexPathData  = _indexPathData;


NSArray *studentDataOptions;
NSArray *thumbnails;
NSArray *endPointsServerDescription;
NSMutableArray *endPointsServerData;
NSArray *endPointsViewColors;
NSMutableArray *rowsToBeUpdated;
NSMutableDictionary *endPointServerDescriptionAndData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    // Initialize table data
    studentDataOptions = [NSArray arrayWithObjects:@"CL&W CREDITS", @"MEALPOINTS", @"MEALPOINTS LEFT/DAY", @"DAYS LEFT IN SEMESTER", @"STUDENT ID", @"TEMPERATURE", nil];
    
    endPointsServerDescription = [NSArray arrayWithObjects:@"chapelcredits", @"mealpoints", @"mealpointsperday", @"daysleftinsemester", @"studentid", @"temperature", nil];
    
    endPointsServerData = [NSMutableArray arrayWithObjects:@"-", @"-", @"-", @"-", @"-", @"-", nil];
    
    
    endPointsViewColors = [NSArray arrayWithObjects:@"blueColor", @"orangeColor", @"purpleColor", @"greenColor", @"redColor", @"blueColor", nil];
    
    thumbnails = [NSArray arrayWithObjects:@"chapel.png", @"silverware.png", @"calculator.png", @"calendar.png", @"person.png",@"thermometer",nil];
    
   
    
    endPointServerDescriptionAndData = [NSMutableDictionary
            dictionaryWithDictionary:@{
                                       @"chapelcredits" : @"-",
                                       @"mealpoints" : @"-",
                                       @"mealpointsperday" : @"-",
                                       @"daysleftinsemester" : @"-",
                                       @"studentid" : @"-",
                                       @"temperature" : @"-"
                                       
                                       }];
   

    //used to make the table get closer to the navigation bar
    self.automaticallyAdjustsScrollViewInsets = NO;
        
}



-(void)viewWillAppear:(BOOL)animated
{
     [self.navigationController setNavigationBarHidden:NO];
    
     self.navigationItem.hidesBackButton = YES;
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    self.responseData = [[NSMutableData alloc] init];
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [self.responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:self.responseData
                                                               options:0
                                                                 error:nil];
    
    //self.userDataDownload = [NSString stringWithFormat:@"%@", jsonObject[@"data"]];
    [endPointsServerData replaceObjectAtIndex:self.indexPathData.row withObject:[NSString stringWithFormat:@"%@", jsonObject[@"data"]]];
    
    //check substring of the url connection
    
    NSIndexPath *temp;
    
    if([[connection description] containsString:@"chapelcredits"]){
        temp = [endPointServerDescriptionAndData objectForKey:@"chapelcredits" ];
        
    }else if([[connection description] containsString:@"mealpoints"]){
     temp = [endPointServerDescriptionAndData objectForKey:@"mealpoints" ];
    }
    
    [self.tableViewData beginUpdates];
    [self.tableViewData reloadRowsAtIndexPaths:@[self.indexPathData] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableViewData endUpdates];
    
    
    
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"ERROR - %@" , error);
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [studentDataOptions count];
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
    
    cell.dataDescriptionLabel.text = [studentDataOptions objectAtIndex:indexPath.row];
    cell.thumbnailImageView.image = [UIImage imageNamed:[thumbnails objectAtIndex:indexPath.row]];
    
    SEL selector = NSSelectorFromString([endPointsViewColors objectAtIndex:indexPath.row]);
    cell.thumbnailImageView.backgroundColor = [UIColor  performSelector:selector];
    cell.backgroundColor = [UIColor performSelector:selector];
    cell.dataDescriptionLabel.textColor = [UIColor whiteColor];
    cell.dataResultFromServerLabel.textColor = [UIColor whiteColor];
    cell.dataResultFromServerLabel.text = [endPointsServerData objectAtIndex:indexPath.row];
    
    
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
    self.indexPathData = indexPath;
    
    
    //[endPointServerDescriptionAndData  removeObjectForKey:[endPointsServerDescription objectAtIndex:indexPath.row]];
    [endPointServerDescriptionAndData setObject:indexPath forKey:[endPointsServerDescription objectAtIndex:indexPath.row]];
    
    NSLog(@"%@" , endPointServerDescriptionAndData);
    NSLog(@"%@" , indexPath);
    
    [self loadDataFromServer:[NSString stringWithFormat:@"%@",[endPointsServerDescription objectAtIndex:indexPath.row]]];
    
   
    
    
    
    
}


-(void)loadDataFromServer: (NSString *)param
{
    
    
        
    NSString *requestString = @"http://api.adamvig.com/gocostudent/2.2/";
    requestString  = [requestString stringByAppendingFormat:@"%@%@%@%@%@",param,@"?username=",[self.userProfile objectForKey:@"username"],@"&password=",[self.userProfile objectForKey:@"password"]];
    

    
    // Create the request.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    
    
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"Load DATA Connection: %@" , [conn description]);

    
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
