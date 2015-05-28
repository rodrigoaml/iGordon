//
//  ViewController.m
//  iGordon
//
//  Created by Rodrigo Amaral on 5/19/15.
//  Copyright (c) 2015 Gordon College. All rights reserved.
//

#import "LoginViewController.h"
#import "MainDataViewController.h"

@interface LoginViewController () <NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSString *userGordonName;
@property (nonatomic, strong) NSString *userGordonPassword;



@end

@implementation LoginViewController
@synthesize userGordonName = _userGordonName;
@synthesize userGordonPassword = _userGordonPassword ;
@synthesize imgGocoChapel   = _imgGocoChapel ;
@synthesize txtUserPassword = _txtUserPassword ;
@synthesize txtUserName =   _txtUserName ;
@synthesize lblEnterYourUserPass = _lblEnterYourUserPass ;
@synthesize mainDataViewController = _mainDataViewController ;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSURLSessionConfiguration *config =
    [NSURLSessionConfiguration defaultSessionConfiguration];
    
    _session = [NSURLSession sessionWithConfiguration:config
                                             delegate:self
                                        delegateQueue:nil];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (IBAction)btnLogin {
  
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.lblEnterYourUserPass performSelectorOnMainThread : @selector(setText:) withObject:@"" waitUntilDone:NO];
        
    });
    
    
    
    NSData *nsdata = [self.txtUserPassword.text
                      dataUsingEncoding:NSUTF8StringEncoding];
    
    
    self.userGordonName = [NSString stringWithFormat:@"%@", self.txtUserName.text] ;
    
    // Get NSString from NSData object in Base64
    self.userGordonPassword = [nsdata base64EncodedStringWithOptions:0];
    
    [self performLoginAtServer];
    
    // necessary for the error response that takes a long time when the credentials don't exist
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(returnsErrorMessageBadLogin) userInfo:nil repeats:NO];
  
}

-(void)performLoginAtServer
{
    
    
    NSString *requestString = @"http://api.adamvig.com/gocostudent/2.2/checklogin?username=";
    requestString  = [requestString stringByAppendingFormat:@"%@%@%@",self.userGordonName,@"&password=",self.userGordonPassword];
    
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
  
        NSURLSessionDataTask *dataTask =
        [self.session dataTaskWithRequest:req
                        completionHandler:
         ^(NSData *data, NSURLResponse *response, NSError *error) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;

                 
                 if([httpResponse statusCode] == HTTP_STATUS_CODE_OK_LOGIN){
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         [self performSegueWithIdentifier:@"goMainDataTableView" sender:self.mainDataViewController];
                         
                     });
                 }
                 else{
                   [self  returnsErrorMessageBadLogin];
                 }

             });
             
             
         }];
    
      [dataTask resume];
      
}


-(void)viewDidDisappear:(BOOL)animated
{
    [self.lblEnterYourUserPass performSelectorOnMainThread : @selector(setTextColor:) withObject:[UIColor whiteColor] waitUntilDone:NO];
    [self.lblUsername performSelectorOnMainThread : @selector(setTextColor:) withObject:[UIColor whiteColor] waitUntilDone:NO];
    [self.lblPassword performSelectorOnMainThread : @selector(setTextColor:) withObject:[UIColor whiteColor] waitUntilDone:NO];
    [self.lblEnterYourUserPass performSelectorOnMainThread : @selector(setText:) withObject:@"Enter your credentials for Go Gordon" waitUntilDone:NO];
}



-(void)returnsErrorMessageBadLogin
{
 
        [self.lblEnterYourUserPass performSelectorOnMainThread : @selector(setTextColor:) withObject:[UIColor orangeColor] waitUntilDone:NO];
        [self.lblUsername performSelectorOnMainThread : @selector(setTextColor:) withObject:[UIColor redColor] waitUntilDone:NO];
        [self.lblPassword performSelectorOnMainThread : @selector(setTextColor:) withObject:[UIColor redColor] waitUntilDone:NO];
        [self.lblEnterYourUserPass performSelectorOnMainThread : @selector(setText:) withObject:@"User/password incorrect" waitUntilDone:NO];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        //Defines where the segue goes
        self.mainDataViewController  = (MainDataViewController *)segue.destinationViewController;
    
        //creates a NSDictionary with the user profile data ( username and password )
        NSDictionary *normalDict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat: @"%@", self.userGordonName],@"username",[NSString stringWithFormat: @"%@", self.userGordonPassword],@"password",nil];
    
    
        //Store the user data in the next ViewControlles for search purposes
        self.mainDataViewController.userProfile = normalDict;
    

    
    
}




@end
