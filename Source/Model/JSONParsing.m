//
//  ViewController.m
//  Expentrace
//
//  Created by RHVT on 5/5/19.
//  Copyright © 2019 R. All rights reserved.
//

#import "JSONParsing.h"
#import "Constants.h"
#import "Expentrace-Swift.h"

@interface JSONParsing ()

@end

@implementation JSONParsing

+(DownloadService *)downloadService {
    static DownloadService *ds = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ds = [[DownloadService alloc] init];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                        delegate:ds
                                                    delegateQueue:nil];
        [ds setDownloadsSession:session];
    });
    
    return ds;
}

+(NSData *)syncRequestJSON:(NSURL *)baseURL {
    // Where data is going to be stored after it is retrieved. It has a block
    // to signal it is going to be used within a callback function
    __block NSData *data = nil;
    // Mechanish used to keep the "sync" part, in a "async" call
    __block dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    
    void (^complHdl)(NSURL *) = ^(NSURL *filePath) {
        if (filePath != nil) {
            data = [NSData dataWithContentsOfURL:baseURL];
        }
        dispatch_group_leave(group);
    };
    ObjectToDownload *otd = [[ObjectToDownload alloc] initWithName:@""
                                                      refURL:baseURL];
    [[JSONParsing downloadService] setCompletionHandler:complHdl];
    [[JSONParsing downloadService] startDownload:otd];
    
    // if by 10 secs it has not returned, free the dispatch group.
    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, 10000000000);
    dispatch_group_wait(group, t);
    
    return data;
}

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
