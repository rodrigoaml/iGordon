//
//  ViewController.m
//  iGordon
//
//  Created by Rodrigo Amaral on 5/19/15.
//  Copyright (c) 2015 Gordon College. All rights reserved.
//

#import "MainDataViewController.h"

@interface MainDataViewController ()

@property (nonatomic, strong) NSURLSession *session;

@end



@implementation MainDataViewController
@synthesize lblChapelCredits = _lblChapelCredits;
@synthesize userProfile = _userProfile;
@synthesize session = _session;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnGetStudentInfo:(UIButton *)sender {
    
    [self sendRequestToServer:[sender currentTitle]];

}


-(void)sendRequestToServer:(NSString *)param
{
    
    NSString *requestString = @"http://api.adamvig.com/gocostudent/2.2/";
    requestString  = [requestString stringByAppendingFormat:@"%@%@%@%@%@",param,@"?username=",self.userProfile[@"username"],@"&password=",self.userProfile[@"password"]];
    
    
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithRequest:req
                    completionHandler:
     ^(NSData *data, NSURLResponse *response, NSError *error) {
         
         NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:0
                                                                      error:nil];
         
         
         dispatch_async(dispatch_get_main_queue(), ^{
             
             
             if ([param isEqualToString:@"chapelcredits"]) {
                 self.lblChapelCredits.text = [self.lblChapelCredits.text stringByAppendingFormat:@" %@",jsonObject[@"data"]];
             } else if ([param isEqualToString:@"mealpoints"]) {
                 self.lblTotalMealPoints.text = [self.lblTotalMealPoints.text stringByAppendingFormat:@" $%@",jsonObject[@"data"]];
             } else if ([param isEqualToString:@"mealpointsperday"]) {
                 self.lblMealPointsLeftPerDay.text = [self.lblMealPointsLeftPerDay.text stringByAppendingFormat:@" $%@",jsonObject[@"data"]];
             } else if ([param isEqualToString:@"daysleftinsemester"]) {
                 self.lblDaysLeftSemester.text = [self.lblDaysLeftSemester.text stringByAppendingFormat:@" %@",jsonObject[@"data"]];
             } else if ([param isEqualToString:@"studentid"]){
                 
                 self.lblStudentID.text = [self.lblStudentID.text stringByAppendingFormat:@" %@",jsonObject[@"data"]];
             } else if ([param isEqualToString:@"temperature"]){
                 self.lblTemperature.text = [self.lblTemperature.text stringByAppendingFormat:@" %@ %@",jsonObject[@"data"],@"°F"];
             }
             
             
             
             
             
         });
         
         
     }];
    
    [dataTask resume];
    
}


@end
