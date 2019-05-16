//
//  DownloadManager.m
//  Expentrace
//
//  Created by RHVT on 16/5/19.
//  Copyright © 2019 R. All rights reserved.
//

#import "DownloadManager.h"

@implementation DownloadManager

// Use the singleton pattern
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

+(NSData *)syncGetData:(NSURL *)baseURL
{
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
    [[self downloadService] setCompletionHandler:complHdl];
    [[self downloadService] startDownload:otd];
    
    // if by 10 secs it has not returned, free the dispatch group.
    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, 10000000000);
    dispatch_group_wait(group, t);
    
    return data;
}

@end
