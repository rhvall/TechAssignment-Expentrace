//
//  ViewController.m
//  Expentrace
//
//  Created by RHVT on 5/5/19.
//  Copyright © 2019 R. All rights reserved.
//

#import "SummaryViewController.h"
#import "Expentrace-Bridging-Header.h"
#import "JSONParsing.h"

@interface SummaryViewController ()

@end

@implementation SummaryViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // Test correct loading of the JSON file
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/rval735/Expentrace/AddModels/Assets/data.json"];
        NSData *dta = [JSONParsing requestJSON:url];
        NSArray *dic = [JSONParsing parseJSONArray:dta];
        NSLog(@"Dic: %@", dic);
    });
    
}


@end
