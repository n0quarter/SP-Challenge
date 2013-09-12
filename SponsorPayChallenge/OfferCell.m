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
-(void) initWithOffer:(SPOffer *)offer
{
//    NSLog(@"[%d] initWithOffer", num);
    self.titleLabel.text  = offer.title;
    self.teaserLabel.text = offer.teaser;
    self.payoutLabel.text = [offer.payout stringValue]; 
    
//    if (self.offerImageView.image == nil) NSLog(@"_offerImageView.image = nil");
//    else NSLog(@"_offerImageView.image != nil");
    
    [self.offerImageView addObserver:self forKeyPath:@"image" options:0 context:nil];

    //        NSLog(@"[%d] url = %@", num, offer.thumbnail);
    
    // download image with DataAPI
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SPDownloadImageNotification"
                                                            object:self
                                                          userInfo:@{@"offerImageView":self.offerImageView, @"imgUrl":offer.thumbnail}];
//    }
} 


 - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"image"])
    {
        [_indicator stopAnimating];
        [self.offerImageView removeObserver:self forKeyPath:@"image"];
        
//        if (self.offerImageView.image == nil) NSLog(@"=== _offerImageView.image = nil");
//        else NSLog(@"=== _offerImageView.image != nil");

    }
}


@end
