//
//  MasterViewController.m
//  SponsorPayChallenge
//
//  Created by Viktor Shcherban on 9/7/13.
//  Copyright (c) 2013 Viktor Shcherban. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

enum {
    uidFieldTag = 0,
    apiKeylFieldTag,
    appIdFieldTag,
    pub0FieldTag
};

@interface MasterViewController () {
    UIBarButtonItem *doneButton;
}
@property (nonatomic, strong) ParamsList *allParams;
@end

@implementation MasterViewController


#pragma mark - INIT
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add SponsorPay logo to NavigationBar
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SPLogo.png"]];

    // Create Done button for Navigation Bar
    doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideKeyboard)];
    
    self.allParams = [[DataAPI sharedInstance] getParams];
//    allParams = [[DataAPI sharedInstance] getParams];
    
    // Set start values
    self.uidTextFielt.text    = _allParams.uid;
    self.apiKeyTextField.text = _allParams.apiKey;
    self.appIdTextField.text  = _allParams.appid;
    self.pub0TextField.text   = _allParams.pub0;
    
}


#pragma mark - My stuff

- (void) hideKeyboard {
    [self.view endEditing:TRUE];
    self.navigationItem.rightBarButtonItem = nil;
}



#pragma mark - UITextField
// Enter Pressed.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // go to the next Text Field
    if (textField.tag < pub0FieldTag) {
        [[self.view viewWithTag:textField.tag+1] becomeFirstResponder];
    }
    // unless we are already on the last Text Field (assuming that pub0 is always last field)
    // in that case go ask server for data (the same action as we pressed Get Data button)
    else {
        [self performSegueWithIdentifier:@"showDetail" sender:self];
    }
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    NSLog(@"textFieldDidEndEditing");
    
    switch (textField.tag) {
        case uidFieldTag:
            _allParams.uid = textField.text;
            break;
        case apiKeylFieldTag:
            _allParams.apiKey = textField.text;
            break;
        case appIdFieldTag:
            _allParams.appid = textField.text;
            break;
        case pub0FieldTag:
            _allParams.pub0 = textField.text;
            break;
    }
}

// In field appid only digits alllowed. Checking this and deny user to enter anything but digits
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == appIdFieldTag)
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *expression = @"^([0-9]+)?(\\.([0-9]{1,2})?)?$";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0)
            return NO;
    }
    return YES;
}


#pragma mark - prepareForSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        [self hideKeyboard];
        [[segue destinationViewController] setParams:_allParams];
    }
}

#pragma mark - other stuff
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
