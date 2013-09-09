//
//  mainLib.m
//  SPChallenge
//
//  Created by Viktor Shcherban on 9/8/13.
//  Copyright (c) 2013 Viktor Shcherban. All rights reserved.
//

#import "mainLib.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation mainLib

+ (NSString *) jsonExample {
    return @" \
    {  \
    \"code\" :  \" OK\" ,  \
    \"message\":  \"OK\",  \
    \"count\":  \"1\" ,  \
    \"pages\":  \"1\" ,  \
    \"information\" :  {  \
    \"app_name\":  \"SP Test App\" ,  \
    \"appid\":  \"157\",  \
    \" virtual_ currency\":  \"Coins\",  \
    \"country\":  \" US\" ,  \
    \"language\":  \" EN\" ,  \
    \"support_url\" :  \"http://iframe.sponsorpay.com/mobile/DE/157/my_offers\"  \
    },  \
    \"offers\" :  [  \
    {  \
    \"title\":  \" Tap  Fish\",  \
    \"offer_id\":  \" 13554\",   \
    \" teaser \" :  \"  Download and START \" ,  \
    \" required _actions \" :  \"Download and START\",  \
    \"link\" :  \"http://iframe.sponsorpay.com/mbrowser?appid=157&lpid=11387&uid=player1\",  \
    \"offer_types\" :  [  \
    {  \
    \"offer_type_id\":  \"101\",  \
    \"readable\":  \"Download\"  \
    },  \
    {  \
    \"offer_type_id\":  \"112\",  \
    \"readable\":  \"Free\"  \
    }  \
    ] ,  \
    \"thumbnail\" :  {  \
    \"lowres\" :  \"http://cdn.sponsorpay.com/assets/1808/icon175x175- 2_square_60.png\" ,  \
    \"hires\":  \"http://cdn.sponsorpay.com/assets/1808/icon175x175- 2_square_175.png\"  \
    },  \
    \"payout\" :  \"90\",  \
    \"time_to_payout\" :  {  \
    \"amount\" :  \"1800\" ,  \
    \"readable\":  \"30 minutes\"  \
    }  \
    }  \
    ]  \
    }  \
    ";
}


+ (NSString *)getIPAddress
{
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;
    
    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if(sa_type == AF_INET || sa_type == AF_INET6) {
                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
//                NSLog(@"NAME: \"%@\" addr: %@", name, addr); // see for yourself
                
                if([name isEqualToString:@"en0"]) {
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                } else
                    if([name isEqualToString:@"pdp_ip0"]) {
                        // Interface is the cell connection on the iPhone
                        cellAddress = addr;
                    }
            }
            temp_addr = temp_addr->ifa_next;
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    return addr ? addr : @"0.0.0.0";
}

@end
