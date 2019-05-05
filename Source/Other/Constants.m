//
//  ViewController.m
//  Expentrace
//
//  Created by RHVT on 5/5/19.
//  Copyright © 2019 R. All rights reserved.
//

#import "Constants.h"

@interface Constants ()

@end

@implementation Constants

+(NSString *)apiAccessKey {
    /*
     Replace bellow with your own access key
    */
    return @"----";
}

+(NSString *)accessKeyComponent {
    return @"access_key";
}


+(NSURL *)currencyLiveURL {
    NSString *baseURLString = @"http://www.apilayer.net/api/live";
    return [NSURL URLWithString:baseURLString];
}

@end
