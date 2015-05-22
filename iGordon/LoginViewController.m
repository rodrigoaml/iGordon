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
@property (nonatomic) NSString *testDataFromServer ;


@end

@implementation LoginViewController
@synthesize userGordonName = _userGordonName;
@synthesize userGordonPassword = _userGordonPassword ;
@synthesize imgGocoChapel   = _imgGocoChapel ;
@synthesize txtUserPassword = _txtUserPassword ;
@synthesize txtUserName =   _txtUserName ;
@synthesize lblEnterYourUserPass = _lblEnterYourUserPass ;
@synthesize mainDataViewController = _mainDataViewController ;
@synthesize testDataFromServer  = _testDataFromServer ;

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



- (IBAction)btnLogin {
  
    NSData *nsdata = [self.txtUserPassword.text
                      dataUsingEncoding:NSUTF8StringEncoding];
    
    
    self.userGordonName = [NSString stringWithFormat:@"%@", self.txtUserName.text] ;
    
    // Get NSString from NSData object in Base64
    self.userGordonPassword = [nsdata base64EncodedStringWithOptions:0];
    
    [self loginGoco];
    // necessary for the error response that takes a long time when the credentials don't exist
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(validatesUserLogin) userInfo:nil repeats:NO];
  
}

-(void)loginGoco
{
    //test with /checklogin?username......
    
    NSString *requestString = @"http://api.adamvig.com/gocostudent/2.2/chapelcredits?username=";
    requestString  = [requestString stringByAppendingFormat:@"%@%@%@",self.userGordonName,@"&password=",self.userGordonPassword];
    
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
  
        NSURLSessionDataTask *dataTask =
        [self.session dataTaskWithRequest:req
                        completionHandler:
         ^(NSData *data, NSURLResponse *response, NSError *error) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                 
                 self.testDataFromServer = jsonObject[@"data"];
                 
                 [self  validatesUserLogin];
             });
             
             
         }];
    
    
      [dataTask resume];

}



-(void)validatesUserLogin
{
   
    if(self.testDataFromServer != nil){
  
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self performSegueWithIdentifier:@"goMainDataViewController" sender:self.mainDataViewController];
            
        });
    }
    else{
        
        [self.lblEnterYourUserPass performSelectorOnMainThread : @selector(setText:) withObject:@"User/password incorrect" waitUntilDone:NO];
        
        
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        //Define the where the segue goes
        self.mainDataViewController  = (MainDataViewController *)segue.destinationViewController;
    
        //create a NSDictionary with the user profile data ( username and password )
        NSDictionary *normalDict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat: @"%@", self.userGordonName],@"username",[NSString stringWithFormat: @"%@", self.userGordonPassword],@"password",nil];
    
    
        //Store the user data in the next ViewControlles for search purposes
        self.mainDataViewController.userProfile = normalDict;
}



@end
