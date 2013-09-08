//
//  HTTPClient.m
//  SponsorPayChallenge
//
//  Created by asdCode on 8/7/13.
//  Copyright (c) 2013 asdCode. All rights reserved.
//

#import "HTTPClient.h"
#import "NSString+sha1.h"

@interface HTTPClient () {
    NSString *signatureHeader;
}

@end
@implementation HTTPClient 

- (id)getRequest:(NSString *)url
{
    NSURL *getUrl = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    if (_verbose) NSLog(@"HTTPClient getRequest. url = '%@'", getUrl);

    NSURLRequest * request = [NSURLRequest requestWithURL:getUrl];
    NSURLConnection *theConnection = [NSURLConnection connectionWithRequest:request delegate:self];

    if (theConnection) {
        self.httpData = [NSMutableData data];
    } else {
        NSLog(@"Connection failed");
    }

    
    return nil;
}

- (id)postRequest:(NSString*)url body:(NSString*)body
{
    return nil;
}


#pragma mark - connection delegates

// --------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (_verbose) NSLog(@"[HTTPClient] didReceiveData");
    [self.httpData appendData:data];
}

// -------------------------------------------- catch redirect
- (NSURLRequest *)connection: (NSURLConnection *)inConnection willSendRequest: (NSURLRequest *)inRequest redirectResponse: (NSURLResponse *)inRedirectResponse {
    NSString *url = [NSString stringWithString:inRequest.URL.absoluteString];
    if (_verbose) NSLog(@"[HTTPClient] Redirect to '%@'", url);
    return inRequest;
}

// --------------------------------------
- (void)connectionDidFinishLoading:(NSURLConnection *)connection { // ------ ВСЕ ОК !!!!!!
    
    if (_verbose) NSLog(@"[HTTPClient] connectionDidFinishLoading");
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if ([_delegate respondsToSelector:@selector(getDataDone:data:signature:)]) {
        [self.delegate getDataDone:_httpCode data:[NSData dataWithData:_httpData] signature:signatureHeader];
    } else {
        NSLog(@"HTTPClient. [ERROR] delegate doesn't respond do selector getDataDone");
    }
}

// --------------------------------------
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
    _httpCode = [httpResponse statusCode];
    
    //    NSLog(@"didReceiveResponse %@: %@", [response URL], [(NSHTTPURLResponse*)response allHeaderFields]); // проверка на gzip
    if (_verbose) NSLog(@"[HTTPClient] didReceiveResponse code = '%d'", _httpCode);

    if ([httpResponse respondsToSelector:@selector(allHeaderFields)]) {
        signatureHeader = [[httpResponse allHeaderFields] objectForKey:@"X-Sponsorpay-Response-Signature"];
    }
        
    if (_httpCode >= 400) {
        // сообщаем делегату о ошибке.
        if ([self.delegate respondsToSelector:@selector(getDataHttpError:)]) {
            [_delegate getDataHttpError:_httpCode];
        }
    }
}

// --------------------------------------
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error { // --- Ошибочка вышла
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    if ([self.delegate respondsToSelector:@selector(getDataHttpError:)]) {
        [_delegate getDataHttpError:_httpCode];
    }
    
    if (_verbose) NSLog(@"err = %@", error);
}





@end
