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
    NSLog(@"cell initWithOffer");

    self.titleLabel.text  = offer.title;
    self.teaserLabel.text = offer.teaser;
    self.payoutLabel.text = [offer.payout stringValue];
    
    NSLog(@"uiimageview.image = %@", _offerImageView.image);
    
    [_offerImageView addObserver:self forKeyPath:@"image" options:0 context:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"SPDownloadImageNotification"
                                                        object:self
                                                      userInfo:@{@"offerImageView":self, @"imgUrl":offer.thumbnail}];
}


/*- (void) setThumbnailImage:(UIImage *)image
{
    NSLog(@"setThumbnailImage");
    _customImageView.image = image;
    [self.indicator stopAnimating];
}
 */

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"=== observeValueForKeyPath");
    if ([keyPath isEqualToString:@"image"])
        NSLog(@"observeValueForKeyPath = image"); 
    {
        [_indicator stopAnimating];
    }
}

- (void)dealloc
{
    NSLog(@"cell dealloc");
#warning solve it later
//    [_customImageView removeObserver:self forKeyPath:@"image"];
}

@end
