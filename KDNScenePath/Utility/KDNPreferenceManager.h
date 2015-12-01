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

+(void)setBudget:(int)budget;
+(int)getBudget;

+(void)setScenicOption:(BOOL)isScenic;
+(BOOL)getScenicOption;

+(void)setGoogleOption:(BOOL)isGoogle;
+(BOOL)getGoogleOption;

+(void)setShouldSavePreviousSearch:(BOOL)shouldSavePreviousSearch;
+(BOOL)getShouldSavePreviousSearch;

+(void)setPreviousFromLocation:(KDNLocationInfo*)fromLocation;
+(KDNLocationInfo*)getPreviousFromLocation;

+(void)setPreviousToLocation:(KDNLocationInfo*)toLocation;
+(KDNLocationInfo*)getPreviousToLocation;

@end
