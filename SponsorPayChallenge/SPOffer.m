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
//        NSLog(@"initWithDictionary. = %@", dictionary);
        _title  = [dictionary[@"title"] stringByReplacingOccurrencesOfString:@" " withString:@""];
        _teaser = [dictionary[@" teaser "] stringByReplacingOccurrencesOfString:@" " withString:@""];
        _payout = [dictionary[@"payout"] stringByReplacingOccurrencesOfString:@" " withString:@""];

        if ([dictionary[@"thumbnail"] isKindOfClass:[NSDictionary class]]) {
            _thumbnail = dictionary[@"thumbnail"][@"hires"];
        }
    }
    
//    NSLog(@"_title = %@", _title);
//    NSLog(@"_teaser = %@", _teaser);
//    NSLog(@"_thumbnail_hires = %@", _thumbnail_hires);
//    NSLog(@"_payout = %@", _payout);
    return self;
}
@end
