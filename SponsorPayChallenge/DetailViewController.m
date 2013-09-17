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
#import "SPOffer.h"
#import "OfferCell.h"
#import "SPJSONParser.h"

@interface DetailViewController ()
@property(nonatomic, strong) NSArray *allOffers;
@property(nonatomic, strong) UIAlertView *alertView;
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
    HTTPClient *httpClient = [[HTTPClient alloc] init];
    httpClient.delegate = self;
    httpClient.verbose = NO;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [httpClient getRequest:[NSString stringWithFormat:@"%@?%@", [[DataAPI sharedInstance] getServerURL], params.sponsorPayUrlWithHash]];
}

#pragma mark - httpClient delegates
- (void) getDataDone:(int)httpCode data:(NSData *)data signature:(NSString *)signature
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    SPJSONParser *jsonParser =[[SPJSONParser alloc] initWithDelegate:self];
    
    if (httpCode == 200) {
        
        // Check signature, for Signed Response (as described at http://developer.sponsorpay.com/docs/mobile/offer-api/)
        NSString *answerString = [[NSMutableString alloc]  initWithBytes:[data bytes] length:[data length] encoding: NSUTF8StringEncoding];
        NSString *answerPlusApiKey = [answerString stringByAppendingFormat:@"%@", _params.apiKey];
        
        
        if (![answerPlusApiKey.sha1 isEqualToString:signature]) {
            [self showAlert:@"Error" message:@"Wrong responce signature!"];
        } else {
            [jsonParser parseJSON:data httpCode:httpCode];
        }
    } else if (httpCode == 500) [self showAlert:@"Error on the SponsorPay server" message:@"Internal Server Error"];
      else if (httpCode == 501) [self showAlert:@"Error on the SponsorPay server" message:@"Bad Gateway"];
      else {
          [jsonParser parseJSON:data httpCode:httpCode];
    }
}

- (void) getDataError:(NSString *)localizedDescription
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self showAlert:@"Connection error" message:localizedDescription];
}


#pragma mark - SPJSONParser delegate

- (void) jsonParserDone:(NSArray *)offers {
    self.allOffers = offers;
    [self.tableView reloadData];
    
}
- (void) jsonParserError:(NSString *)code message:(NSString *)message;
{
    [self showAlert:code message:message];
}


#pragma mark - AlertView

- (void) showAlert:(NSString *)title message:(NSString *)message
{
    self.alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [self.alertView show];
}

// ------------------------------------------
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc {
    [self.alertView setDelegate:nil];
    self.alertView = nil;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSNumber *height;
    if (!height) {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
        height = @(cell.bounds.size.height);
    }
    return [height floatValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allOffers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    OfferCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    SPOffer *offer = self.allOffers[indexPath.row];
    
    return [cell initWithOffer:offer andTag:indexPath.row];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - other stuff
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
