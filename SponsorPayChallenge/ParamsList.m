//
//  ParamsList.m
//  SPChallenge
//
//  Created by Viktor Shcherban on 9/8/13.
//  Copyright (c) 2013 Viktor Shcherban. All rights reserved.
//

#import "ParamsList.h"
#import "NSString+sha1.h"
#import "mainLib.h"

#define simulateIP @"192.168.0.1"

// remove deprecated warnings (I have one, because Apple no longer accept apps that access the UDID of a device starting May 1, 2013.
// proof http://www.macworld.com/article/2031573/apple-sets-may-1-deadline-for-udid-iphone-5-app-changes.html
// in future use OpenUDID or something
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

@implementation ParamsList

- (id)initWithUid:(NSString*)uid apiKey:(NSString*)apiKey appid:(NSString*)appid pub0:(NSString*)pub0
{
    self = [super init];
    if (self)
    {
        _uid = uid; 
        _apiKey = apiKey;
        _appid = appid;
        _pub0 = pub0;
        
        // readonly parameters. just set defaults
        _device_id = [[UIDevice currentDevice] uniqueIdentifier]; // get UDID.
        _locale = [[NSLocale preferredLanguages] objectAtIndex:0]; // get locale
        #if TARGET_IPHONE_SIMULATOR
            _ip = simulateIP;
        #else
            _ip = [mainLib getIPAddress]; // device ip
        #endif
        
        _offer_types = @"112"; // got from challenge description
    }
    return self; 
}


// return URL string as described in API documentation (http://developer.sponsorpay.com/docs/mobile/offer-api/)
- (NSString *) sponsorPayUrlWithHash
{    
    NSString *timeStamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    
    // Create an array with parameters
    NSMutableArray *paramsArray = [NSMutableArray array];
    [paramsArray addObject:[NSString stringWithFormat:@"device_id=%@", _device_id]];
    [paramsArray addObject:[NSString stringWithFormat:@"ip=%@", _ip]];
    [paramsArray addObject:[NSString stringWithFormat:@"appid=%@", _appid]];
    [paramsArray addObject:[NSString stringWithFormat:@"locale=%@", _locale]];
    if (![_pub0 isEqualToString:@""]) [paramsArray addObject:[NSString stringWithFormat:@"pub0=%@", _pub0]];
    [paramsArray addObject:[NSString stringWithFormat:@"timestamp=%@", timeStamp]];
    [paramsArray addObject:[NSString stringWithFormat:@"uid=%@", _uid]];
    
    // sort params alphabetically
    NSArray *sortedParamsArray = [paramsArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    // make a string and add API key
    NSString *paramsString = [[sortedParamsArray valueForKey:@"description"] componentsJoinedByString:@"&"];
    NSString *urlPlusApiKey = [paramsString stringByAppendingFormat:@"&%@", _apiKey];

    // make a hash
    NSString *hashKey = [[urlPlusApiKey sha1] lowercaseString];
    
    // result - string with params and hash
    NSString *result = [NSString stringWithFormat:@"%@&&hashkey=%@", paramsString, hashKey];
    
    return result;
}


@end
