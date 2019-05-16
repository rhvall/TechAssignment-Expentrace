//
//  DownloadManager.h
//  Expentrace
//
//  Created by RHVT on 16/5/19.
//  Copyright © 2019 R. All rights reserved.
//

#import "Expentrace-Swift.h"
#import <Foundation/Foundation.h>

// Class in charge of downloading content, it could be done synchrounously
// or asynchronously.
@interface DownloadManager : NSObject

// If a service would like to make changes on the completion handler or
// when the download should start, those cases will use this call
+(DownloadService *)downloadService;
/**
 Method to synchronously get something from a URL

 @param baseURL The location to get data
 @return Data retrieved from that location, could be nil if
 the request timesout or nothing could be obtained
 */
+(NSData *)syncGetData:(NSURL *)baseURL;
// Future possible definition:
// +(void)asyncGetData:(NSURL *)baseURL completion:(^);
@end
