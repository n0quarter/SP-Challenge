//
//  PersistencyManager.m
//  SponsorPayChallenge
//
//  Created by Viktor Shcherban on 9/7/13.
//  Copyright (c) 2013 asdCode. All rights reserved.
//

// Class Description:
// This class stores all the data and return it by request
// We assume that all requests will be done via DataApi singletone,
// becouse this class(PersistencyManager) is not thread safe


#import "PersistencyManager.h"

@interface PersistencyManager () {
    // An dictionary with default parameters
    ParamsList *params;
}
@end

@implementation PersistencyManager

- (id)init
{
    self = [super init];
    if (self) {
        
        params = [[ParamsList alloc] initWithUid:@"spiderman" apiKey:@"1c915e3b5d42d05136185030892fbb846c278927" appid:@"2070" pub0:@""];
//        [self saveParams]; // inplement in future
        }
    return self;
}


- (ParamsList *) getParams
{
    return params;
}

- (void)saveParams {
    // implement in future
}




@end
