//
//  DetailViewController.h
//  SponsorPayChallenge
//
//  Created by Viktor Shcherban on 9/7/13.
//  Copyright (c) 2013 Viktor Shcherban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParamsList.h"
#import "DataAPI.h"
#import "HTTPClient.h"
#import "SPJSONParser.h"

@interface DetailViewController : UITableViewController <HTTPClientProtocol, UIAlertViewDelegate, jsonParserProtocol>

@property (nonatomic, strong) ParamsList *params;

- (void) jsonParserError:(NSString *)code message:(NSString *)message;
- (void) jsonParserDone:(NSArray *)offers;

@end
