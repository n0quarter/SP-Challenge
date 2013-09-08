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
    
    NSLog(@"HTTPClient getRequest. url = '%@'", url);
//    return nil;

    
    
    NSURL *getUrl = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    if (_verbose) NSLog(@"HTTPClient getRequest. url = '%@'", getUrl);

    NSURLRequest * request = [NSURLRequest requestWithURL:getUrl];
    NSURLConnection *theConnection = [NSURLConnection connectionWithRequest:request delegate:self];

    if (theConnection) {
        self.httpData = [NSMutableData data];
    } else {
//        UIAlertView *eView = [[UIAlertView alloc]  initWithTitle: @"Error" message:@"Ошибка соединения" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [eView show];
        
        NSLog(@"Connection failed");
    }

    
    return nil;
}

- (id)postRequest:(NSString*)url body:(NSString*)body
{
    NSLog(@"HTTPClient. url = %@", url);
    NSLog(@"HTTPClient. body = %@", body);
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
    
    //        NSString *answer = [[NSString alloc]  initWithBytes:[myData bytes] length:[myData length] encoding: NSUTF8StringEncoding];
    //        NSLog(@"answer = '%@'", answer);
    //        NSLog(@"------------------------------- ALL Ok, we got answer");
    //        NSString *str = [NSString stringWithString:[answer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    //        NSLog(@"str = '%@'", str);
    
    
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
//        NSLog(@"signatureHeader = '%@'", signatureHeader);
    }
    
    NSLog(@"[HTTPClient] didReceiveResponse code = '%d'", _httpCode);
    
    if (_httpCode >= 400) {
        
        // сообщаем делегату о ошибке.
        if ([self.delegate respondsToSelector:@selector(getDataHttpError:)]) {
            [_delegate getDataHttpError:_httpCode];
        }
        
        /*        if (_httpCode == 404) { // эта ошибка возникает, когда неверно указан магазин
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка авторизации" message:@"Магазин указан неверно"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
         [alert show];
         }
         else {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка авторизации" message:@"Неправильный логин или пароль"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
         [alert show];
         }
         */
        
        // обрываем соединение
//        [theConnection cancel];
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    }
}

// --------------------------------------
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error { // --- Ошибочка вышла
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
/*
 if ([_delegate respondsToSelector:@selector(getDataError:)]) {
        [_delegate getDataError:_httpCode];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка соединения" message:@"Нет связи с сервером."  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
    [alert show];
 */
    
    if (_verbose) NSLog(@"err = %@", error);
}


/*- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)space {
 if([[space authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust]) {
 return YES; // Self-signed cert will be accepted
 // Note: it doesn't seem to matter what you return for a proper SSL cert
 //       only self-signed certs
 }
 // If no other authentication is required, return NO for everything else
 // Otherwise maybe YES for NSURLAuthenticationMethodDefault and etc.
 return YES;
 }
 */






@end
