//
//  OfferCell.m
//  SPChallenge
//
//  Created by Viktor Shcherban on 9/9/13.
//  Copyright (c) 2013 Viktor Shcherban. All rights reserved.
//

#import "OfferCell.h"

@implementation OfferCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"cell Initialization");
        // Initialization code
    }
    return self;
}

// my custom init with offer
-(void) initWithOffer:(SPOffer *)offer
{
    self.titleLabel.text  = offer.title;
    self.teaserLabel.text = offer.teaser;
    self.payoutLabel.text = offer.payout;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SPDownloadImageNotification"
                                                        object:self
                                                      userInfo:@{@"cell":self, @"imgUrl":offer.thumbnail}];
}


- (void) setThumbnailImage:(UIImage *)image
{
    _customImageView.image = image;
    [self.indicator stopAnimating];
}

@end
