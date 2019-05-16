//
//  ViewController.m
//  Expentrace
//
//  Created by RHVT on 5/5/19.
//  Copyright © 2019 R. All rights reserved.
//

#import "JSONParsing.h"
#import "Constants.h"

@implementation JSONParsing

// Receives data in JSON format, and tries to parse it into a NSDictionary
+(NSDictionary *)parseJSONDictionary:(NSData *)jsonDta {
    
    id allKeys = [self transformToJSON:jsonDta];
    
    if ([allKeys isKindOfClass:[NSDictionary class]] == false) {
        // To avoid crashing, this function will make sure the parsed
        // JSON object is a dictionary, otherwise it will return nil
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

+(NSArray *)parseJSONArray:(NSData *)jsonDta {
    
    if (jsonDta == nil) {
        return nil;
    }
    
    id allKeys = [self transformToJSON:jsonDta];
    
    if ([allKeys isKindOfClass:[NSArray class]] == false) {
        // To avoid crashing, this function will make sure the parsed
        // JSON object is an array, otherwise it will return nil
        return nil;
    }
    
    return [allKeys copy];
}

// Single reponsability to parse data into a serialized JSON object
+(id)transformToJSON:(NSData *)jsonDta {
    NSError *jsonError;
    id serialized = [NSJSONSerialization JSONObjectWithData:jsonDta
                                                 options:kNilOptions
                                                   error:&jsonError];
    
    if (jsonError != nil) {
        NSLog(@"Error at time of retrieving exchange data: %@", jsonError);
        return nil;
    }
    
    return serialized;
}

@end
