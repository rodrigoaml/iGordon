//
//  TableViewCellUserData.h
//  iGordon
//
//  Created by Rodrigo Amaral on 5/24/15.
//  Copyright (c) 2015 Gordon College. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TableViewCellUserData : UITableViewCell<NSURLSessionDelegate>

@property (nonatomic, weak) IBOutlet UILabel *dataDescriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *dataResultFromServerLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;


@end
