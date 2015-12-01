//
//  KDNGoogleMapsHelper.m
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/30/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import "KDNGoogleMapsHelper.h"
#import "KDNGoogleMapsUtility.h"
#import "KDNConstants.h"
@import GoogleMaps;

@implementation KDNGoogleMapsHelper

+(void)getEncodedGmsPathFrom:(KDNLocationInfo *)location1 to:(KDNLocationInfo *)location2 pathType:(KDNMyGoogleMapsPathType)pathType{
    NSLog(@"Get GOOGLE route from %@ to %@", [location1 description], [location2 description]);
    NSString *urlString = [NSString stringWithFormat:
                           kGoogleMapsDirectionsApiRequestURLFormat,
                           kGoogleMapsDirectionsApiBaseURL,
                           location1.latitude,
                           location1.longitude,
                           location2.latitude,
                           location2.longitude,
                           kGoogleMapsApiServerKey];
//    NSLog(@"Google directions request string: %@", urlString);
    NSURL *directionsURL = [NSURL URLWithString:urlString];
    [[[NSURLSession sharedSession] dataTaskWithURL:directionsURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        @try {
            if (data != nil) {
                NSDictionary* dict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                NSLog(@"Dict: %@", dict);
                NSString* status = dict[@"status"];
                if ([status isEqualToString:@"OK"]) {
                    NSString* encodedPath = dict[@"routes"][0][@"overview_polyline"][@"points"];

                    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                    [userInfo setObject:encodedPath forKey:kGooglePathReceivedEncodedPathKey];
                    [userInfo setObject:[NSNumber numberWithInteger:pathType] forKey:kGooglePathReceivedPathTypeKey];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kGooglePathReceivedSuccessfully object:nil userInfo:userInfo];
                } else {
                    NSLog(@"Error getting route: status = %@", status);
                    [[NSNotificationCenter defaultCenter] postNotificationName:kGooglePathReceivedFailed object:nil];
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error requesting route: %@", [exception description]);
            [[NSNotificationCenter defaultCenter] postNotificationName:kGooglePathReceivedFailed object:nil];
        }
    }] resume];
}

@end
