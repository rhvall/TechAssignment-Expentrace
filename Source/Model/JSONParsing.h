//
//  ViewController.h
//  Expentrace
//
//  Created by RHVT on 5/5/19.
//  Copyright © 2019 R. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSONParsing : NSObject

// This function does a simple URL request to the constant using Foundation's
// method "NSData dataWithContentsOfURL", it is not the most efficient nor
// best way to deal with network errors, but it is a shorcut given the alloted
// time for this project
+(NSData *)requestJSON:(NSURL *)baseURL;

// Receives data in JSON format, and tries to parse it into a NSArray
+(NSArray *)parseJSONArray:(NSData *)jsonDta;

// Receives data in JSON format, and tries to parse it into a NSDictionary
+(NSDictionary *)parseJSONDictionary:(NSData *)jsonDta;
@end

