//
//  KDNPreferenceManager.m
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/27/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import "KDNPreferenceManager.h"

@implementation KDNPreferenceManager

NSString* const kScenicOptionKey = @"isScenic";
NSString* const kShouldSavePreviousSearchKey = @"ShouldSavePreviousSearch";
NSString* const kPreviousFromLocationKey = @"PreviousFromLocation";
NSString* const kPreviousToLocationKey = @"PreviousToLocation";

+(void)setScenicOption:(BOOL)isScenic {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isScenic forKey:kScenicOptionKey];
    [defaults synchronize];
}
+(BOOL)getScenicOption {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kScenicOptionKey];
}

+(void)setShouldSavePreviousSearch:(BOOL)shouldSavePreviousSearch {
    [[NSUserDefaults standardUserDefaults] setBool:shouldSavePreviousSearch forKey:kShouldSavePreviousSearchKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(BOOL)getShouldSavePreviousSearch {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kShouldSavePreviousSearchKey];
}

+(void)setPreviousFromLocation:(KDNLocationInfo*)fromLocation {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:fromLocation];
    [[NSUserDefaults standardUserDefaults] setObject:data
                                              forKey:kPreviousFromLocationKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(KDNLocationInfo*)getPreviousFromLocation {
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kPreviousFromLocationKey];
    if (data == nil) {
        return nil;
    }
    
    KDNLocationInfo* info = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    KDNLocationInfo* result = [[KDNLocationInfo alloc] initWithLatitude:info.latitude
                                                              longitude:info.longitude
                                                                  title:info.title];
    return result;
}

+(void)setPreviousToLocation:(KDNLocationInfo*)toLocation {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:toLocation];
    [[NSUserDefaults standardUserDefaults] setObject:data
                                              forKey:kPreviousToLocationKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(KDNLocationInfo*)getPreviousToLocation {
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kPreviousToLocationKey];
    if (data == nil) {
        return nil;
    }
    
    KDNLocationInfo* info = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    KDNLocationInfo* result = [[KDNLocationInfo alloc] initWithLatitude:info.latitude
                                                              longitude:info.longitude
                                                                  title:info.title];
    return result;
}

@end
