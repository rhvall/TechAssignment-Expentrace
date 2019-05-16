//
//  ViewController.h
//  Expentrace
//
//  Created by RHVT on 5/5/19.
//  Copyright © 2019 R. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSONParsing : NSObject

// This function does a URL request to the service using the baseURL parameter,
// it is synchronous, so it will wait for the response to return in order to
// give data back.
+(NSData *)syncRequestJSON:(NSURL *)baseURL;

// Receives data in JSON format, and tries to parse it into a NSArray
+(NSArray *)parseJSONArray:(NSData *)jsonDta;

// Receives data in JSON format, and tries to parse it into a NSDictionary
+(NSDictionary *)parseJSONDictionary:(NSData *)jsonDta;
@end

