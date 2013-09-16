//
//  SPJSONParter.m
//  SPChallenge
//
//  Created by Viktor Shcherban on 9/16/13.
//  Copyright (c) 2013 Viktor Shcherban. All rights reserved.
//

#import "SPJSONParser.h"
#import "SPOffer.h"

@interface SPJSONParser () {
    id delegate;
}
@end

@implementation SPJSONParser

#pragma mark - INIT
- (id) initWithDelegate:(id)SPdelegate {
    self = [super init];
    if (self)
    {
        delegate = SPdelegate;
    }
    return self;
}


#pragma mark - parse JSON

// -------------------------------------------
- (void) parseJSON: (NSData *) data httpCode:(int)httpCode{
    
    NSError *jsonError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *jd = (NSDictionary *)jsonObject;
        
        NSString *code    = [jd objectForKey:@"code"];
        NSString *message = [jd objectForKey:@"message"]; 
        
        NSLog(@"code = %@, m = %@", code, message);
        
        // if httpCode == 200, we have 2 options, all_right or N0_Content
        // let's check it here
        if ([code isEqualToString:@"NO_CONTENT"] || httpCode > 200)  {
            [delegate jsonParserError:code message:message];
        } else {
            // Okay, so we have 200 and code = "OK" here.
            // It means that we have at least one offer (accourding to API documentation)
            
            NSArray *jsonOffers = jd[@"offers"];
            if ([jsonOffers isKindOfClass:[NSArray class]]) {
                
                // get offers from json (asynchronically, becouse some jsons could be pretty big)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSArray *offers = [self parseOffers:jsonOffers];
                    
                    // update offers in the main queue and refresh data on view
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [delegate jsonParserDone:offers];
                    });
                });
            }
        }
    }
}

- (NSArray *) parseOffers:(NSArray *)jsonOffers {
    NSMutableArray *spOffers = [NSMutableArray array];
    
    for (NSDictionary *dict in jsonOffers) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            SPOffer *offer = [[SPOffer alloc] initWithDictionary:dict];
            [spOffers addObject:offer];
        }
    }
    return [NSArray arrayWithArray:spOffers];
}

- (void) printQueue // for debugging
{
    dispatch_queue_t me = dispatch_get_current_queue();     // The queue which currently runs this block
    printf("'%s'\n", dispatch_queue_get_label(me));         // Print the name of the queue
}


@end
