//
//  KDNPreferenceManager.h
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/27/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDNLocationInfo.h"

/// Save/Retrieve user's preferences
@interface KDNPreferenceManager : NSObject

+(void)setScenicOption:(BOOL)isScenic;
+(BOOL)getScenicOption;

+(void)setShouldSavePreviousSearch:(BOOL)shouldSavePreviousSearch;
+(BOOL)getShouldSavePreviousSearch;

+(void)setPreviousFromLocation:(KDNLocationInfo*)fromLocation;
+(KDNLocationInfo*)getPreviousFromLocation;

+(void)setPreviousToLocation:(KDNLocationInfo*)toLocation;
+(KDNLocationInfo*)getPreviousToLocation;

@end
