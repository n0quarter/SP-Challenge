//
//  SPOffer.h
//  SPChallenge
//
//  Created by Viktor Shcherban on 9/9/13.
//  Copyright (c) 2013 Viktor Shcherban. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPOffer : NSObject

- (id)initWithDictionary:(NSDictionary*) dictionary;

@property (nonatomic, strong) NSString *title, *teaser, *thumbnail;
@property (nonatomic, strong) NSNumber *payout;

@end

