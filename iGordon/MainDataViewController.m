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

@interface MainDataViewController () <UIActionSheetDelegate, UIPopoverPresentationControllerDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSString *userDataDownload;
@property (nonatomic, strong) NSMutableArray *userFetchedData;
@property (nonatomic, strong) UIPopoverPresentationController *userOptionsPopover;
@property (nonatomic, strong) PopoverViewController *PopoverView;


@end



@implementation MainDataViewController


@synthesize userProfile = _userProfile;
@synthesize session = _session;
@synthesize userDataDownload = _userDataDownload ;
@synthesize userFetchedData = _userFetchedData ;
@synthesize userOptionsPopover = _userOptionsPopover;


NSArray *studentDataOptions;
NSArray *thumbnails;
NSArray *endPointsServerDescription;
NSArray *endPointsViewColors;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURLSessionConfiguration *config =
    [NSURLSessionConfiguration defaultSessionConfiguration];
    
    _session = [NSURLSession sessionWithConfiguration:config
                                             delegate:self
                                        delegateQueue:nil];
    
    
    
    // Initialize table data
    studentDataOptions = [NSArray arrayWithObjects:@"CL&W CREDITS", @"MEALPOINTS", @"MEALPOINTS LEFT/DAY", @"DAYS LEFT IN SEMESTER", @"STUDENT ID", @"TEMPERATURE", nil];
    
    endPointsServerDescription = [NSArray arrayWithObjects:@"chapelcredits", @"mealpoints", @"mealpointsperday", @"daysleftinsemester", @"studentid", @"temperature", nil];
    
    endPointsViewColors = [NSArray arrayWithObjects:@"blueColor", @"orangeColor", @"purpleColor", @"greenColor", @"redColor", @"yellowColor", nil];
    
    thumbnails = [NSArray arrayWithObjects:@"chapel.png", @"silverware.png", @"calculator.png", @"calendar.png", @"person.png",@"thermometer", nil];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    
     self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *optionsBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Options" style:UIBarButtonItemStylePlain target:self action:@selector(showActionSheetOptions)];
    
    [[self navigationItem] setRightBarButtonItem:optionsBarButton];
    
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
    cell.dataResultFromServerLabel.text = self.userDataDownload == nil ? @"-" : self.userDataDownload;
    self.userDataDownload = nil ;
    
    
    return cell;


}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self loadDataFromServer:[NSString stringWithFormat:@"%@",[endPointsServerDescription objectAtIndex:indexPath.row]]];
    
    while (self.userDataDownload == nil) {
       
        
    }
    
    
    //move line to the loadDataFromServer
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];

}

-(void)loadDataFromServer: (NSString *)param
{
    
    
        
    NSString *requestString = @"http://api.adamvig.com/gocostudent/2.2/";
    requestString  = [requestString stringByAppendingFormat:@"%@%@%@%@%@",param,@"?username=",[self.userProfile objectForKey:@"username"],@"&password=",[self.userProfile objectForKey:@"password"]];
    
    
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithRequest:req
                    completionHandler:
     ^(NSData *data, NSURLResponse *response, NSError *error) {
         
         NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:0
                                                                      error:nil];
         
         self.userDataDownload = [NSString stringWithFormat:@"%@", jsonObject[@"data"]];
         
         
     }];
    [dataTask resume];
        
   
    
}


-(void)showActionSheetOptions
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Options"
                                                             delegate:self
                                                    cancelButtonTitle:@"Back"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Logout", @"Gordon.com", @"cs.gordon", nil];
    
   
    [actionSheet showInView:self.view];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
   
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSString *url;
    
    
    
    switch (buttonIndex) {
        case 0:
            NSLog(@"Not implemented yet");
            
            break;
        case 1:
            url = @"http://www.gordon.edu";
            break;
        case 2:
            url = @"http://www.cs.gordon.edu";
            break;
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
    
    
}



- (IBAction)btnSelectDatePressed:(UIBarButtonItem *)sender
{
    
    
    
    self.PopoverView =[[PopoverViewController alloc] initWithNibName:nil bundle:nil];
    
    self.PopoverView.modalPresentationStyle = UIModalPresentationPopover;
    
    
    // Present the view controller using the popover style.
    
    [self presentViewController:self.PopoverView animated: YES completion: ^{
    }];
    
    // Get the popover presentation controller and configure it.
    UIPopoverPresentationController *presentationController =
    [self.PopoverView popoverPresentationController];
    
    presentationController.permittedArrowDirections =
    UIPopoverArrowDirectionDown | UIPopoverArrowDirectionLeft;
    
    
    presentationController.sourceView = self.view;
    presentationController.barButtonItem = sender;
    //presentationController.delegate = self ;
    presentationController.sourceRect = CGRectMake(5, 5, 5, 5);
    
    
    
    
}

- (UIModalPresentationStyle) adaptivePresentationStyleForPresentationController: (UIPresentationController * ) controller {
    return UIModalPresentationPopover;
}




@end
