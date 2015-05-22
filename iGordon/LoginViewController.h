//
//  ViewController.h
//  iGordon
//
//  Created by Rodrigo Amaral on 5/19/15.
//  Copyright (c) 2015 Gordon College. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainDataViewController ;
@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblEnterYourUserPass;

@property (strong, nonatomic) IBOutlet UITextField *txtUserName;
@property (strong, nonatomic) IBOutlet UITextField *txtUserPassword;
@property (retain, nonatomic) IBOutlet UIImageView *imgGocoChapel;

@property (nonatomic, strong) MainDataViewController *mainDataViewController;
- (IBAction)btnLogin;

@end

