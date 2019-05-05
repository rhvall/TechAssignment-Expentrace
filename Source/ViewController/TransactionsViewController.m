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
    NSURLComponents *urlComp = [[NSURLComponents alloc] initWithURL:baseURL
                                     resolvingAgainstBaseURL:NO];
    NSURLQueryItem *activeKey = [[NSURLQueryItem alloc] initWithName:[Constants accessKeyComponent]
                                                         value:[Constants apiAccessKey]];
    [urlComp setQueryItems:@[activeKey]];
    NSData *data = [NSData dataWithContentsOfURL:[urlComp URL]];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", ret);
    return ret;
}

@end
