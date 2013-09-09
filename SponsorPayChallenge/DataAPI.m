//
//  DataAPI.m
//  SponsorPayChallenge
//
//  Created by Viktor Shcherban on 9/7/13.
//  Copyright (c) 2013 asdCode. All rights reserved.

// Class description:
// This class is singletone for accesing data from PersistencyManager(local storage)
// Other classes in project don't need to know where the data coming from.



#import "DataAPI.h"
#import "PersistencyManager.h"

#define serverURL @"http://api.sponsorpay.com/feed/v1/offers.json"

@interface DataAPI () {
    PersistencyManager *persistencyManager;
}

@end

@implementation DataAPI

#pragma mark - INIT

+ (DataAPI*)sharedInstance
{
    static DataAPI *_sharedInstance = nil;

    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[DataAPI alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        persistencyManager = [[PersistencyManager alloc] init];

        
    }
    return self;
}

- (NSString *) getServerURL
{
    return serverURL;
}


#pragma mark - Local storage API

- (ParamsList*)getParams
{
    return [persistencyManager getParams];
}



@end
