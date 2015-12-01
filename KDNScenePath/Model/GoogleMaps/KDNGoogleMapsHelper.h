//
//  KDNGoogleMapsHelper.h
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/30/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDNLocationInfo.h"

@interface KDNGoogleMapsHelper : NSObject

/** Get encode GMS Path from location1 to location2
 Return the path or nil if error occurred
 */
+(void)getEncodedGmsPathFrom:(KDNLocationInfo*)location1 to:(KDNLocationInfo*)location2;

@end
