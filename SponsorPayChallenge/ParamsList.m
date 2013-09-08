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


// remove deprecated warnings, 'cause Apple will no longer accept apps that access the UDID of a device starting May 1, 2013.
// proof http://www.macworld.com/article/2031573/apple-sets-may-1-deadline-for-udid-iphone-5-app-changes.html
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
        
        // readonly parameters
        _device_id = [[UIDevice currentDevice] uniqueIdentifier];
        _locale = [[NSLocale preferredLanguages] objectAtIndex:0];
        _ip = [mainLib getIPAddress];
        _offer_types = @"112";
        
    }
    return self;
}

- (NSString *) sponsorPayUrlWithHash
{
    
    NSString *timeStamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    
    // Create array with parameters
    NSMutableArray *paramsArray = [NSMutableArray array];
    [paramsArray addObject:[NSString stringWithFormat:@"device_id=%@", _device_id]];
//    [paramsArray addObject:[NSString stringWithFormat:@"ip=%@", _ip]];
    [paramsArray addObject:[NSString stringWithFormat:@"appid=%@", _appid]];
    [paramsArray addObject:[NSString stringWithFormat:@"locale=%@", _locale]];
    if (![_pub0 isEqualToString:@""]) [paramsArray addObject:[NSString stringWithFormat:@"pub0=%@", _pub0]];
    [paramsArray addObject:[NSString stringWithFormat:@"timestamp=%@", timeStamp]];
    [paramsArray addObject:[NSString stringWithFormat:@"uid=%@", _uid]];
    
    // sort params
    NSArray *sortedParamsArray = [paramsArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    
    NSString *paramsString = [[sortedParamsArray valueForKey:@"description"] componentsJoinedByString:@"&"];
    NSString *urlPlusApiKey = [paramsString stringByAppendingFormat:@"&%@", _apiKey];

    NSString *hashKey = [[urlPlusApiKey sha1] lowercaseString];
    
    NSString *result = [NSString stringWithFormat:@"%@&&hashkey=%@", paramsString, hashKey];
    
    return result;
}


@end
