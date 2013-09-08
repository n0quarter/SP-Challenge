//
//  ParamsList.h
//  SPChallenge
//
//  Created by Viktor Shcherban on 9/8/13.
//  Copyright (c) 2013 Viktor Shcherban. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParamsList : NSObject

- (id)initWithUid:(NSString*)uid apiKey:(NSString*)apiKey appid:(NSString*)appid pub0:(NSString*)pub0;

@property (nonatomic, strong) NSString *uid, *apiKey, *appid, *pub0;
@property (nonatomic, readonly) NSString *device_id, *locale, *ip, *offer_types;

@property (nonatomic, readonly) NSString *sponsorPayUrlWithHash;

@end
