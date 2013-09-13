//
//  SponsorPayChallengeTests.m
//  SponsorPayChallengeTests
//
//  Created by Viktor Shcherban on 9/7/13.
//  Copyright (c) 2013 Viktor Shcherban. All rights reserved.
//

#import "SponsorPayChallengeTests.h"
#import "SPOffer.h"

@implementation SponsorPayChallengeTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{

    [super tearDown];
}

- (void) testOfferInitWithDictionary {
    NSLog(@"testOffer");

    // First test with correct data
    NSDictionary *correctOfferDict = @{@"title":@"text",
                                    @"teaser":@"text",
                                    @"payout": @10,
                                    @"thumbnail": @{@"hires": @"http://cdn1.sponsorpay.com/assets/26513/ipoll_square_175.png"}
                                    };
    SPOffer *offer = [[SPOffer alloc] initWithDictionary:correctOfferDict];
    if (!offer) {
        STFail(@"Offer initWithDictionary fail");
    } else {
        if (offer.title == nil)     [self correctDictFail:@"set title fail"];
        if (offer.teaser == nil)    [self correctDictFail:@"set teaser fail"];
        if (offer.payout == nil)    [self correctDictFail:@"set payout fail"];
        if (offer.thumbnail == nil) [self correctDictFail:@"set thumbnail fail"];
    }
    
    // Then test with wrong data
    NSDictionary *incorrectOfferDict = @{@"title": @"",
                                       @"teaser":@"",
                                       @"payout": @0,
                                       @"thumbnail": @{@"hires": @""}
                                       };
    NSLog(@"wrong = %@", incorrectOfferDict);
    
    offer = [[SPOffer alloc] initWithDictionary:incorrectOfferDict];
    if (!offer) {
        STFail(@"Offer initWithDictionary fail");
    } else {
        if (offer.title == nil)     [self incorrectDictFail:@"set title fail"];
        if (offer.teaser == nil)    [self incorrectDictFail:@"set teaser fail"];
        if (offer.payout == nil)    [self incorrectDictFail:@"set payout fail"];
        if (offer.thumbnail == nil) [self incorrectDictFail:@"set thumbnail fail"];
    }

}
- (void) correctDictFail:(NSString *)msg
{
    STFail([NSString stringWithFormat:@"FAIL. [Offer with correct dict] %@", msg]);
}

- (void) incorrectDictFail:(NSString *)msg
{
    STFail([NSString stringWithFormat:@"FAIL. [Offer with INcorrect dict] %@", msg]);
}

@end
