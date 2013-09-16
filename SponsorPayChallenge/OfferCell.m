//
//  OfferCell.m
//  SPChallenge
//
//  Created by Viktor Shcherban on 9/9/13.
//  Copyright (c) 2013 Viktor Shcherban. All rights reserved.
//

#import "OfferCell.h"

@implementation OfferCell

// my custom init with offer
- (id) initWithOffer:(SPOffer *)offer
{
    self.titleLabel.text  = offer.title;
    self.teaserLabel.text = offer.teaser;
    self.payoutLabel.text = [offer.payout stringValue]; 
    
    
    [self.offerImageView addObserver:self forKeyPath:@"image" options:0 context:nil];

    // download image with DataAPI
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SPDownloadImageNotification"
                                                            object:self
                                                          userInfo:@{@"offerImageView":self.offerImageView, @"imgUrl":offer.thumbnail}];
    return self;
} 


 - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"image"])
    {
        [_indicator stopAnimating];
        [self.offerImageView removeObserver:self forKeyPath:@"image"];
        
    }
}


@end
