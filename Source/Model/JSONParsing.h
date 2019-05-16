//
//  ViewController.h
//  Expentrace
//
//  Created by RHVT on 5/5/19.
//  Copyright © 2019 R. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParsing : NSObject

// Receives data in JSON format, and tries to parse it into a NSArray
+(NSArray *)parseJSONArray:(NSData *)jsonDta;

// Receives data in JSON format, and tries to parse it into a NSDictionary
+(NSDictionary *)parseJSONDictionary:(NSData *)jsonDta;
@end

