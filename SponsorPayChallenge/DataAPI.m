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
#import "HTTPClient.h"
#import "OfferCell.h"

#define serverURL @"http://api.sponsorpay.com/feed/v1/offers.json"

@interface DataAPI () {
    PersistencyManager *persistencyManager;
    HTTPClient *httpClient;
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
        httpClient = [[HTTPClient alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadImage:) name:@"SPDownloadImageNotification" object:nil];
    }
    return self;
}

- (NSString *) getServerURL
{
    return serverURL;
}


- (void)downloadImage:(NSNotification*)notification
{
    OfferCell *cell = notification.userInfo[@"cell"];
    NSString *coverUrl = notification.userInfo[@"imgUrl"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [httpClient downloadImage:coverUrl];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([cell respondsToSelector:@selector(setThumbnailImage:)]) {
                [cell setThumbnailImage:image];
            }
        });
    });
}
#pragma mark - Local storage API

- (ParamsList*)getParams
{
    return [persistencyManager getParams];
}



@end
