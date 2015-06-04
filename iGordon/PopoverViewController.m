//
//  PopoverViewController.m
//  iGordon
//
//  Created by Rodrigo Amaral on 5/26/15.
//  Copyright (c) 2015 Gordon College. All rights reserved.
//

#import "PopoverViewController.h"
#import "LoginViewController.h"
#import "UserPreferencesViewController.h"

@interface PopoverViewController ()

@property (nonatomic, weak) NSArray *itemMenuOptions;
@end

@implementation PopoverViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemMenuOptions = [NSArray arrayWithObjects:@"Gordon.edu", @"Computer Science", @"Reorder", @"Logout", nil];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [self.itemMenuOptions objectAtIndex:indexPath.row];
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    

    NSString *url;
    
    switch (indexPath.row) {
        case 0:
            url = @"http://www.gordon.edu";
            break;
        case 1:
            url = @"http://www.cs.gordon.edu";
            break;
        case 2:
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"enableReorderingAtMainView"
                                                                object:self
                                                              userInfo:nil];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case 3:
            [self performSegueWithIdentifier:@"logoutFromPopover" sender:self];
            break;
    }
    
    if(url != nil)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
    
    
}



@end
