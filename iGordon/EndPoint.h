//
//  EndPoint.h
//  iGordon
//
//  Created by Rodrigo Amaral on 5/29/15.
//  Copyright (c) 2015 Gordon College. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EndPoint : NSObject <NSURLConnectionDelegate>

@property (nonatomic, strong) NSString *name; // endpoint name = chapelcredits ; mealpoints ; etc

@property (nonatomic, strong) NSString *cellDescription; // CL & W credit ; MEAL POINTS ; Student ID ;etc

@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSArray *colorRGB;

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSMutableData *responseData;


-(void)loadDataFromServer: (NSDictionary*)userProfile ;

@end
