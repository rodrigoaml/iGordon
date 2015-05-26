//
//  ViewController.h
//  iGordon
//
//  Created by Rodrigo Amaral on 5/19/15.
//  Copyright (c) 2015 Gordon College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainDataViewController : UIViewController<NSURLSessionDelegate,UITableViewDelegate, UITableViewDataSource>

@property (retain,nonatomic) NSDictionary* userProfile;




@end
