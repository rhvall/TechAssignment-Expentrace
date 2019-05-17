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
#import "DownloadManager.h"

@interface SummaryViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *transactionsTableView;

@end

@implementation SummaryViewController

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [_transactionsTableView reloadData];
}

// UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    return [[[ListOfTransactions sharedTransactions] getTransactions] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
     cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [_transactionsTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    Transaction *elem =  [[[ListOfTransactions sharedTransactions] getTransactions] objectAtIndex:indexPath.row];
    cell.textLabel.text = [elem tName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%f", [elem tPrice]];
    
    return cell;
}

// UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"title of cell %@", [[[ListOfTransactions sharedTransactions] getTransactions] objectAtIndex:indexPath.row]);
}


@end
