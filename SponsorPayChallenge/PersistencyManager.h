//
//  PersistencyManager.h
//  SponsorPayChallenge
//
//  Created by Viktor Shcherban on 9/7/13.
//  Copyright (c) 2013 asdCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParamsList.h"

@interface PersistencyManager : NSObject

- (ParamsList *) getParams;
- (void) saveParams;


@end
