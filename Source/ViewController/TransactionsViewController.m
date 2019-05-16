//
//  ViewController.m
//  Expentrace
//
//  Created by RHVT on 5/5/19.
//  Copyright © 2019 R. All rights reserved.
//

#import "TransactionsViewController.h"
#import "Constants.h"
#import "JSONParsing.h"

@interface TransactionsViewController ()

@property (nonatomic, weak) IBOutlet UITextView *listCurrenciesTextView;
@property (weak, nonatomic) IBOutlet UITextField *lastUpdateTextField;
@property (weak, nonatomic) IBOutlet UIButton *reloadBtn;

@end

@implementation TransactionsViewController

-(void)viewDidLoad {
    [super viewDidLoad];
     // Possible strings that could be "User facing" should be localized.
    [_listCurrenciesTextView setText:NSLocalizedString(@"Nothing loaded yet", @"Comment when the transactions view has still not loaded data")];
    // Do any additional setup after loading the view.
}

-(IBAction)reloadAction:(id)sender {
    // When the user touches the button, we should disable any more
    // actions to avoid spamming the server, only when it finished, then
    // we should try again.
    [_reloadBtn setUserInteractionEnabled:false];
    
    // Quick and dirty way to load in the background a URL request (by NSData)
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSString *usNZ = [TransactionsViewController loadCurrencyExchange:[Constants currencyLiveURL]
                                                      baseCurrency:[Constants usdKey]
                                                        toCurrency:[Constants nzdKey]];
        // If we send on the BG task, it is possible to break the app, so it
        // has to be performed on main
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listCurrenciesTextView setText:usNZ];
            [self.reloadBtn setUserInteractionEnabled:true];
        });
    });
    
}

// Summarize all actions into one: load JSON, parse it and transform into
// a NSString.
+(NSString *)loadCurrencyExchange:(NSURL *)url
                    baseCurrency:(NSString *)baseCurr
                      toCurrency:(NSString *)toCurr{
    NSData *dta = [JSONParsing syncRequestJSON:url];
    NSDictionary *dic = [JSONParsing parseJSONDictionary:dta];
    NSLog(@"Dic: %@", dic);
    NSLog(@"Key: %@", [dic objectForKey:toCurr]);
    
    // This line of code causes me conflict, it should not be here:
    NSDictionary *rates = [dic objectForKey:[Constants ratesKey]];
    
    // Possible strings that could be "User facing" should be localized.
    NSMutableString *str = [[NSMutableString alloc] initWithString:NSLocalizedString(@"Loaded data \n", "First sentence in the text view")];
    [str appendFormat:NSLocalizedString(@"Base Currency: %@ (1)\n", @"Second sentence"), baseCurr];
    [str appendFormat:NSLocalizedString(@"Target Currency: %@\n", @"Third sentence"), toCurr];
    [str appendFormat:NSLocalizedString(@"Exchange: 1 = %@", @"Fourth sentence"), [rates objectForKey:toCurr]];
    return [str copy];
}


@end
