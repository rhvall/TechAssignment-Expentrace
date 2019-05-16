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
// This array is mutable because stores can change from what is retrived
// from the internet. Also, it is atomic because it could be called from
// multiple async callbacks
@property (strong, atomic) NSMutableArray *transactionsArray;

@end

@implementation SummaryViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // We need to allocate
    _transactionsArray = [[NSMutableArray alloc] init];
    
    // Selector was not compiling, so just making a placeholder block
    void (^callback)(NSArray *) = ^(NSArray *elems) {
        [self updateStoreElements:elems];
    };
    
    [SummaryViewController loadDataFromServer:callback];
}

// UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    return [_transactionsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
     cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [_transactionsTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Transaction *elem =  [_transactionsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [elem tName];
    
    return cell;
}

// UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"title of cell %@", [_transactionsArray objectAtIndex:indexPath.row]);
}

+(void)loadDataFromServer:(void(^)(NSArray *))callWhenFinished {
    // Test correct loading of the JSON file
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData *dta = [DownloadManager syncGetData:[Constants storesURL]];
        NSArray *json = [JSONParsing parseJSONArray:dta];
        if (callWhenFinished != nil) {
            callWhenFinished(json);
        }
    });
}

// Given an array of elements, add them to the stores array property
-(void)updateStoreElements:(NSArray *)elements {
    [_transactionsArray removeAllObjects];
    
    [elements enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // Check if the passed object is a dictionary, otherwise continue
        if ([obj isKindOfClass:[NSDictionary class]] == false) {
            return;
        }
        
        // With the dictionary at hand, try to parse it
        Transaction *elem; // = [Transaction parseStoreElementWithDic:obj];
        
        if (elem != nil) {
            [self.transactionsArray addObject:elem];
        }
    }];
    
    // If we send on the BG task, it is possible to break the app, so it
    // has to be performed on main
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.transactionsTableView reloadData];
    });
}

@end
