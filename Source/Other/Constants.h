//
//  ViewController.h
//  Expentrace
//
//  Created by RHVT on 5/5/19.
//  Copyright © 2019 R. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Constants : NSObject

+(NSURL *)currencyLiveURL;
+(NSString *)transactionsFile;
+(NSString *)encryptionPass;
+(NSString *)ratesKey;
+(NSString *)usdKey;
+(NSString *)nzdKey;

@end

