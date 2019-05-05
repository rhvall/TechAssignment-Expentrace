//
//  ViewController.m
//  Expentrace
//
//  Created by RHVT on 5/5/19.
//  Copyright © 2019 R. All rights reserved.
//

#import "TransactionsViewController.h"
#import "Constants.h"

@interface TransactionsViewController ()

@end

@implementation TransactionsViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self requestJSON];
    // Do any additional setup after loading the view.
}

-(NSString *)requestJSON {
    NSURL *baseURL = [Constants currencyLiveURL];
    NSData *data = [NSData dataWithContentsOfURL:baseURL];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", ret);
    return ret;
}

@end
