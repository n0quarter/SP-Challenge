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

@interface DetailViewController () {
    HTTPClient *httpClient;
}

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
    [httpClient getRequest:[NSString stringWithFormat:@"http://api.sponsorpay.com/feed/v1/offers.json?%@", params.sponsorPayUrlWithHash]];
}

#pragma mark - httpClient delegates
- (void) getDataDone:(int)httpCode data:(NSData *)data signature:(NSString *)signature
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (httpCode == 200) {
        
        // Check signature, for Signed Response
        NSString *answerString = [[NSMutableString alloc]  initWithBytes:[data bytes] length:[data length] encoding: NSUTF8StringEncoding];
//        NSLog(@"answer = '%@'", answerString);

        NSString *answerPlusApiKey = [answerString stringByAppendingFormat:@"%@", _params.apiKey];
        
        if (![answerPlusApiKey.sha1 isEqualToString:signature]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Wrong responce signature!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];    
        } else {
            [self parseJSON:data httpCode:httpCode];
        }
    } else {
        [self parseJSON:data httpCode:httpCode];
    }
}


- (void) getDataError: (int) _httpCode
{
    NSLog(@"dataAPI. getDataError = %d", _httpCode);

    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    
}

#pragma mark - parse JSON

// -------------------------------------------
- (void) parseJSON: (NSData *) data httpCode:(int)httpCode{
    //    NSLog(@"Stat. parseJSON");
    
    
    NSError *jsonError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    
    if ([jsonObject isKindOfClass:[NSArray class]]) {
//        NSLog(@"its an array!");
    }
    else {
//        NSLog(@"its probably a dictionary");
        
        @try {
            NSDictionary *jd = (NSDictionary *)jsonObject; // jd = jsonDictionary;
//            NSLog(@"jd = %@", jd);
            
            NSString *code    = [jd objectForKey:@"code"];
            NSString *message = [jd objectForKey:@"message"];
            
            NSLog(@"code = %@, m = %@", code, message);
            
            if ([code isEqualToString:@"NO_CONTENT"] || httpCode > 200)  {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:code message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        } @catch (NSException *e) {
            NSLog(@"EXCEPTION = '%@'", e);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"JSON parse error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    
}



#pragma mark - AlertView delegate

// ------------------------------------------
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popToRootViewControllerAnimated:YES];
}




#pragma mark - other stuff
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
