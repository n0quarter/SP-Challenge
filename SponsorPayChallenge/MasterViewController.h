//
//  MasterViewController.h
//  SponsorPayChallenge
//
//  Created by Viktor Shcherban on 9/7/13.
//  Copyright (c) 2013 Viktor Shcherban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataAPI.h"

@interface MasterViewController : UITableViewController <UITextFieldDelegate, UITableViewDelegate>

- (void) hideKeyboard;
@property (weak, nonatomic) IBOutlet UITextField *uidTextFielt;
@property (weak, nonatomic) IBOutlet UITextField *apiKeyTextField;
@property (weak, nonatomic) IBOutlet UITextField *appIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *pub0TextField;

@end
