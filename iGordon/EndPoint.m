//
//  EndPoint.m
//  iGordon
//
//  Created by Rodrigo Amaral on 5/29/15.
//  Copyright (c) 2015 Gordon College. All rights reserved.
//

#import "EndPoint.h"


@implementation EndPoint

@synthesize name = _name;
@synthesize cellDescription = _cellDescription;
@synthesize value = _value ;
@synthesize color = _color;
@synthesize image = _image;
@synthesize responseData = _responseData;




- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    self.responseData = [[NSMutableData alloc] init];
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    
    [self.responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:self.responseData
                                                               options:0
                                                                 error:nil];
    
    self.value = jsonObject[@"data"];
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dataRetrievedFromServer"
                                                         object:self
                                                         userInfo:[NSDictionary dictionaryWithObject:self.value forKey:self.name]];
    
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"ERROR - %@" , error);
}


-(void)loadDataFromServer: (NSDictionary*)userProfile {
    
    NSString *requestString = @"http://api.adamvig.com/gocostudent/2.2/";
    requestString  = [requestString stringByAppendingFormat:@"%@%@%@%@%@",self.name,@"?username=",[userProfile objectForKey:@"username"],@"&password=",[userProfile objectForKey:@"password"]];
    
    
    
    // Create the request.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    
    
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"Connection: %@" , [conn description]);
    
}





@end
