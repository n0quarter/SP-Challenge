//
//  OfferCell.h
//  SPChallenge
//
//  Created by Viktor Shcherban on 9/9/13.
//  Copyright (c) 2013 Viktor Shcherban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPOffer.h"

@interface OfferCell : UITableViewCell 

- (id) initWithOffer:(SPOffer *)offer;

@property (weak, nonatomic) IBOutlet UIImageView *offerImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *teaserLabel;
@property (weak, nonatomic) IBOutlet UILabel *payoutLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
