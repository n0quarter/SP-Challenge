//
//  DetailViewController.m
//  SponsorPayChallenge
//
//  Created by Viktor Shcherban on 9/7/13.
//  Copyright (c) 2013 Viktor Shcherban. All rights reserved.
//

#import "DetailViewController.h"
#import "NSString+sha1.h"
#import "MBProgressHUD.h"
#import "DataAPI.h"
#import "mainLib.h"

@interface DetailViewController () {
    HTTPClient *httpClient;
}
@property(nonatomic, strong) UIAlertView *alertView;
@property(nonatomic, strong) NSArray *offers;
@end

@implementation DetailViewController

#pragma mark - INIT
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Add SponsorPay logo to NavigationBar
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SPLogo.png"]];

    [self getDataWithParams:_params];
}


#pragma mark - get data from server
- (void) getDataWithParams: (ParamsList *) params
{
    httpClient = [[HTTPClient alloc] init];
    httpClient.delegate = self;
    httpClient.verbose = NO;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [httpClient getRequest:[NSString stringWithFormat:@"%@?%@", [[DataAPI sharedInstance] getServerURL], params.sponsorPayUrlWithHash]];
}

#pragma mark - httpClient delegates
- (void) getDataDone:(int)httpCode data:(NSData *)data signature:(NSString *)signature
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (httpCode == 200) {
        
        // Check signature, for Signed Response (as described at http://developer.sponsorpay.com/docs/mobile/offer-api/)
        NSString *answerString = [[NSMutableString alloc]  initWithBytes:[data bytes] length:[data length] encoding: NSUTF8StringEncoding];
        NSString *answerPlusApiKey = [answerString stringByAppendingFormat:@"%@", _params.apiKey];
        
        if (![answerPlusApiKey.sha1 isEqualToString:signature]) {
            [self showAlert:@"Error" message:@"Wrong responce signature!"];
        } else {
            [self parseJSON:data httpCode:httpCode];
        }
    } else if (httpCode == 500) [self showAlert:@"Error on the SponsorPay server" message:@"Internal Server Error"];
      else if (httpCode == 501) [self showAlert:@"Error on the SponsorPay server" message:@"Bad Gateway"];
      else {
        [self parseJSON:data httpCode:httpCode];
    } 
}


- (void) getDataError: (int) _httpCode
{
    NSLog(@"dataAPI. getDataError = %d", _httpCode);

    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self showAlert:@"Error" message:@"Connection error"];
    
}

#pragma mark - parse JSON

// -------------------------------------------
- (void) parseJSON: (NSData *) data httpCode:(int)httpCode{
    //    NSLog(@"Stat. parseJSON");
    
    NSError *jsonError = nil;

#warning use example json

    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    
//    NSData* exampleData = [[mainLib jsonExample] dataUsingEncoding:NSUTF8StringEncoding];
//    id jsonObject = [NSJSONSerialization JSONObjectWithData:exampleData options:kNilOptions error:&jsonError];
    
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *jd = (NSDictionary *)jsonObject;

        NSString *code    = [jd objectForKey:@"code"];
        NSString *message = [jd objectForKey:@"message"];
        
        NSLog(@"code = %@, m = %@", code, message);
        
        // if httpCode == 200, we have 2 options, all_right or N0_Content
        // let's check it here
        if ([code isEqualToString:@"NO_CONTENT"] || httpCode > 200)  {
            self.alertView = [[UIAlertView alloc] initWithTitle:code message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [self.alertView show];
        } else {
            // Okay, so we have 200 and code = "OK" here.
            // It means that we have at least one offer (accourding to API documentation)

            NSArray *jsonOffers = jd[@"offers"];
            if ([jsonOffers isKindOfClass:[NSArray class]]) {
                
                
                // get offers from json asynchronically
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    NSLog(@"offers = %@", offers);
                    NSLog(@"go async...");

                    [self printQueue];
                    NSArray *offers = [self parseOffers:jsonOffers];
                    
                    // update offers in main queue and refresh data on view
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self printQueue];

                        self.offers = offers;
                        [self reloadData]; 
                    });
                });
                
            }
        }
    }
}


- (NSArray *) parseOffers:(NSArray *)jsonOffers {
    
    NSLog(@"jsonOff = %@", jsonOffers);
    return jsonOffers;
}

- (void) reloadData {
    NSLog(@"reloadData");
}

- (void) printQueue
{
    dispatch_queue_t me = dispatch_get_current_queue();     /* The queue which currently runs this block */
    printf("'%s'\n", dispatch_queue_get_label(me));         // Print the name of the queue
}

- (void) showAlert:(NSString *)title message:(NSString *)message {
    self.alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [self.alertView show];
}

#pragma mark - AlertView delegate

// ------------------------------------------
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc {
    [self.alertView setDelegate:nil]; // this prevents the crash in the event that the alertview is still showing.
    self.alertView = nil; // release it
//    [super dealloc];
}

#pragma mark - other stuff
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
