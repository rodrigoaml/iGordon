//
//  ViewController.h
//  iGordon
//
//  Created by Rodrigo Amaral on 5/19/15.
//  Copyright (c) 2015 Gordon College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainDataViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,NSURLConnectionDelegate>

@property (retain,nonatomic) NSDictionary* userProfile;
  
@property (nonatomic, strong) NSMutableDictionary *endPointsDictionary;

- (IBAction)btnShowPopoverOptions:(UIBarButtonItem *)sender;

- (IBAction)btnShowPopoverAddRemove:(UIBarButtonItem *)sender;


@end
