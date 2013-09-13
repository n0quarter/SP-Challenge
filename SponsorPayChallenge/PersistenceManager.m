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


#import "PersistenceManager.h"

@interface PersistenceManager () {
    // An dictionary with default parameters
    ParamsList *params;
    NSMutableDictionary *cachedImages;
    BOOL storeDataInMemory;
}
@end

@implementation PersistenceManager

- (id)init
{
    self = [super init];
    if (self) {
        
        [self setStartParams];
        }
    return self;
}

- (void) setStartParams
{
    params = [[ParamsList alloc] initWithUid:@"spiderman" apiKey:@"1c915e3b5d42d05136185030892fbb846c278927" appid:@"2070" pub0:@""];
    //        [self saveParams]; // inplement in future
    cachedImages = [NSMutableDictionary dictionary];
    storeDataInMemory = YES; // store data in memory instead of local storage
}


- (ParamsList *) getParams
{
    return params;
}

- (ParamsList *) getStartParams
{
    [self setStartParams];
    return params;
}

- (void)saveParams {
    // implement in future
}

- (void)saveImage:(UIImage*)image filename:(NSString*)filename
{
    if (storeDataInMemory) [cachedImages setObject:image forKey:filename];
    else 
    {
        filename = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", [filename lastPathComponent]];
        NSData *data = UIImagePNGRepresentation(image);
        [data writeToFile:filename atomically:YES];
    }
}

- (UIImage*)getImage:(NSString*)filename
{
    if (storeDataInMemory) return cachedImages[filename];
    else
    {
        filename = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", [filename lastPathComponent]];
        NSData *data = [NSData dataWithContentsOfFile:filename];
        return [UIImage imageWithData:data];
    }
}



@end
