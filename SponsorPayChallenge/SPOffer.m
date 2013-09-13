//
//  SPOffer.m
//  SPChallenge
//
//  Created by Viktor Shcherban on 9/9/13.
//  Copyright (c) 2013 Viktor Shcherban. All rights reserved.
//

#import "SPOffer.h"

@implementation SPOffer


- (id)initWithDictionary:(NSDictionary*) dictionary
{
    self = [super init];
    if (self)
    {
        if ([dictionary[@"title"] isKindOfClass:[NSString class]])
            self.title  = [dictionary[@"title"] stringByReplacingOccurrencesOfString:@" " withString:@""];

        if ([dictionary[@"teaser"] isKindOfClass:[NSString class]])
            self.teaser = [dictionary[@"teaser"] stringByReplacingOccurrencesOfString:@" " withString:@""];

        if ([dictionary[@"payout"] isKindOfClass:[NSNumber class]])
            self.payout = dictionary[@"payout"];

        if ([dictionary[@"thumbnail"] isKindOfClass:[NSDictionary class]])
            self.thumbnail = dictionary[@"thumbnail"][@"hires"];
    }

    return self;
}
@end
