//
//  SPJSONParter.h
//  SPChallenge
//
//  Created by Viktor Shcherban on 9/16/13.
//  Copyright (c) 2013 Viktor Shcherban. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol jsonParserProtocol

@required
- (void) jsonParserDone:(NSArray *)offers;

@optional
- (void) jsonParserError:(NSString *)code message:(NSString *)message;
@end


@interface SPJSONParser : NSObject

- (id) initWithDelegate:(id)SPdelegate;
- (void) parseJSON: (NSData *) data httpCode:(int)httpCode;

@end
