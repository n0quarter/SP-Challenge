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
#import "PersistenceManager.h"
#import "HTTPClient.h"
#import "OfferCell.h"

#define serverURL @"http://api.sponsorpay.com/feed/v1/offers.json"

@interface DataAPI () {
    PersistenceManager *persistencyManager;
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
        persistencyManager = [[PersistenceManager alloc] init];
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
    UIImageView *offerImageView = notification.userInfo[@"offerImageView"];
    NSString *imgUrl = notification.userInfo[@"imgUrl"];
    NSNumber *tag = notification.userInfo[@"tag"];
    
    // trying to get cached image 
    offerImageView.image = [persistencyManager getImage:imgUrl];

    // if we haven't cached image - then download it using GCD
    if (offerImageView.image == nil) {

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [httpClient downloadImage:imgUrl];

            dispatch_sync(dispatch_get_main_queue(), ^{
                if ([tag intValue] == offerImageView.tag)
                    offerImageView.image = image;
                [persistencyManager saveImage:image filename:imgUrl];
            });
        });
    }
}
#pragma mark - Local storage API

- (ParamsList*)getParams
{
    return [persistencyManager getParams];
}

- (ParamsList*)getStartParams
{
    return [persistencyManager getStartParams];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
