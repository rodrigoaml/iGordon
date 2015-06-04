//
//  userPreferencesViewController.h
//  iGordon
//
//  Created by Rodrigo Amaral on 6/2/15.
//  Copyright (c) 2015 Gordon College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPreferencesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic) NSMutableArray *allUserOptions;
@property (strong,nonatomic)NSMutableArray *userSelectedOptions;


@end
