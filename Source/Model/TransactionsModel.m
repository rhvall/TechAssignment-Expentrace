//
//  ViewController.m
//  Expentrace
//
//  Created by RHVT on 5/5/19.
//  Copyright © 2019 R. All rights reserved.
//

#import "TransactionsModel.h"
#import "Constants.h"

@interface TransactionsModel ()

@end

@implementation TransactionsModel

// This function does a simple URL request to the constant using Foundation's
// method "NSData dataWithContentsOfURL", it is not the most efficient nor
// best way to deal with network errors, but it is a shorcut given the alloted
// time for this project
+(NSData *)requestJSON:(NSURL *)baseURL {
    return [NSData dataWithContentsOfURL:baseURL];
}

// Receives data in JSON format, and tries to parse it into a NSDictionary
+(NSDictionary *)parseJSON:(NSData *)jsonDta {
    NSError *jsonError;
    id allKeys = [NSJSONSerialization JSONObjectWithData:jsonDta
                                            options:NSJSONReadingMutableContainers
                                              error:&jsonError];
    
    if (jsonError != nil) {
        NSLog(@"Error at time of retrieving exchange data: %@", jsonError);
        return nil;
    }
    
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithCapacity:[allKeys count]];
    
    [allKeys enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        // It is necessary to check for multiple types of objects that the JSON parser
        // can do, if it is not an NSString, then we should check for other types
        if ([key isKindOfClass:[NSString class]]) {
            [mutDic setObject:obj
                       forKey:key];
        }
        
        if ([key isKindOfClass:[NSNumber class]]) {
            NSString *keyStr = [[NSString alloc] initWithFormat:@"%@", obj];
            [mutDic setObject:obj
                       forKey:keyStr];
        }
    }];
    
    // Return a simple NSDictionary instead of the mutable version we used inside this function
    return [mutDic copy];
}

@end
