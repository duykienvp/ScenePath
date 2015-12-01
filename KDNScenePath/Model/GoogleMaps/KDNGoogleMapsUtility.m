//
//  GoogleMapsUtility.m
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/21/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import "KDNGoogleMapsUtility.h"
#import "KDNLatLng.h"

NSString * const kGoogleMapsApiKey = @"AIzaSyD5I5TZ4q-NQBPJudfODoyKE7_1iVM3rOs";
NSString * const kGoogleMapsApiServerKey = @"AIzaSyDgQyJN58hYAHKqDahdZ-sK1B8kyeLS-1o";
NSString * const kGoogleMapsGeoCodeFromAddressUrlFormat = @"https://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false";
NSString * const kGoogleMapsDirectionsApiBaseURL = @"https://maps.googleapis.com/maps/api/directions/json";
NSString * const kGoogleMapsDirectionsApiRequestURLFormat = @"%@?origin=%f,%f&destination=%f,%f&sensor=true&key=%@";

@implementation KDNGoogleMapsUtility

+(GMSPath*)constructPathFromPoints:(NSArray *)points {
    GMSMutablePath* path = [GMSMutablePath path];
    
    if (points) {
        for (int i = 0; i < points.count; i++) {
            KDNLatLng* point = [points objectAtIndex:i];
            
            [path addLatitude:point.lat longitude:point.lng];
        }
    } else {
        NSLog(@"<%@:%@:%d>: null points", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);

    }
    
    return path;
}

@end


