//
//  PersistencyManager.h
//  SponsorPayChallenge
//
//  Created by Viktor Shcherban on 9/7/13.
//  Copyright (c) 2013 asdCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParamsList.h"

@interface PersistenceManager : NSObject

- (ParamsList *) getParams;
- (ParamsList *) getStartParams;
- (void) saveParams;

- (void)saveImage:(UIImage *)image filename:(NSString *)filename;
- (UIImage *)getImage:(NSString *)filename;

@end
