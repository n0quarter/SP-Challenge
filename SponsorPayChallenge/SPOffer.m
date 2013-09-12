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
        if ([dictionary[@"title"] isKindOfClass:[NSString class]])
            self.title  = [dictionary[@"title"] stringByReplacingOccurrencesOfString:@" " withString:@""];
//        NSLog(@"title = '%@'", _title);

        if ([dictionary[@"teaser"] isKindOfClass:[NSString class]])
            self.teaser = [dictionary[@"teaser"] stringByReplacingOccurrencesOfString:@" " withString:@""];
//        NSLog(@"_teaser = '%@'", _teaser);

        if ([dictionary[@"payout"] isKindOfClass:[NSNumber class]])
            self.payout = dictionary[@"payout"];
//        NSLog(@"payout = '%@'", _payout);

        if ([dictionary[@"thumbnail"] isKindOfClass:[NSDictionary class]])
            self.thumbnail = dictionary[@"thumbnail"][@"hires"];
//        NSLog(@"thumbnail = '%@'", _thumbnail);

    }
    
//    NSLog(@"_title = %@", _title);
//    NSLog(@"_teaser = %@", _teaser);
//    NSLog(@"_thumbnail_hires = %@", _thumbnail_hires);
//    NSLog(@"_payout = %@", _payout);
    return self;
}
@end
