//
//  ViewController.h
//  iGordon
//
//  Created by Rodrigo Amaral on 5/19/15.
//  Copyright (c) 2015 Gordon College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainDataViewController : UIViewController<NSURLSessionDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblChapelCredits;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalMealPoints;
@property (weak, nonatomic) IBOutlet UILabel *lblMealPointsLeftPerDay;
@property (weak, nonatomic) IBOutlet UILabel *lblDaysLeftSemester;
@property (weak, nonatomic) IBOutlet UILabel *lblStudentID;
@property (weak, nonatomic) IBOutlet UILabel *lblTemperature;
@property (retain,nonatomic) NSDictionary* userProfile;

- (IBAction)btnGetStudentInfo:(UIButton *)sender;


@end
