//
//  GoogleMapsUtility.h
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/21/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GoogleMaps;

@interface KDNGoogleMapsUtility : NSObject

extern NSString * const kGoogleMapsApiKey;
extern NSString * const kGoogleMapsApiServerKey;
extern NSString * const kGoogleMapsGeoCodeFromAddressUrlFormat;
extern NSString * const kGoogleMapsDirectionsApiBaseURL;
extern NSString * const kGoogleMapsDirectionsApiRequestURLFormat;

///Constructs a path from a list of point (KDNLatLng)
+(GMSPath*)constructPathFromPoints:(NSArray*)points;

@end


