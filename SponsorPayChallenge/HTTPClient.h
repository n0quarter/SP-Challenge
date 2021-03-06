//
//  HTTPClient.h
//  SponsorPayChallenge
//
//  Created by asdCode on 8/7/13.
//  Copyright (c) 2013 asdCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTTPClientProtocol

@required
- (void) getDataDone:(int)httpCode data:(NSData *)data signature:(NSString *)signature;

@optional
- (void) getDataError:(NSString *)localizedDescription;
- (void) getDataHttpError:(int)httpCode;
- (void) getDataAuthLost:(int)httpCode;
@end


@interface HTTPClient : NSObject

- (id)getRequest:(NSString*)url;
- (id)postRequest:(NSString*)url body:(NSString*)body;
- (UIImage*)downloadImage:(NSString*)url;

@property BOOL verbose;
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSMutableData *httpData;
@property int httpCode;

@end
