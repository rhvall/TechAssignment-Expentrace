//
//  ViewController.m
//  Expentrace
//
//  Created by RHVT on 5/5/19.
//  Copyright © 2019 R. All rights reserved.
//

#import "TransactionsViewController.h"
#import "Constants.h"
#import "TransactionsModel.h"

@interface TransactionsViewController ()

@end

@implementation TransactionsViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    NSData *dta = [TransactionsModel requestJSON: [Constants currencyLiveURL]];
    NSDictionary *dic = [TransactionsModel parseJSON:dta];
    NSLog(@"Dic: %@", dic);
    // Do any additional setup after loading the view.
}

@end
