//
//  ViewController.m
//  Expentrace
//
//  Created by RHVT on 5/5/19.
//  Copyright © 2019 R. All rights reserved.
//

#import "SummaryViewController.h"
#import "JSONParsing.h"
#import "Constants.h"
#import "Expentrace-Swift.h"

@interface SummaryViewController ()

@end

@implementation SummaryViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [SummaryViewController loadDataFromServer:nil];
}

+(void)loadDataFromServer:(void(^)(NSArray *))callWhenFinished {
    // Test correct loading of the JSON file
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData *dta = [JSONParsing requestJSON:[Constants storesURL]];
        NSArray *json = [JSONParsing parseJSONArray:dta];
        StoreElement *st = [StoreElement parseStoreElementWithDic:[json objectAtIndex:0]];
        NSLog(@"st: %@", st);
        // If we send on the BG task, it is possible to break the app, so it
        // has to be performed on main
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callWhenFinished != nil) {
                callWhenFinished(json);
            }
        });
    });
}

-(void)updateStoreElements:(NSArray *)elements {
    
}
@end
