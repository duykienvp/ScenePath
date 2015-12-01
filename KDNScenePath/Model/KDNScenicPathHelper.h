//
//  KDNScenicPathHelper.h
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/30/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDNScenicPathHelper : NSObject

+(void)getRoadNetworkNearestNeightborAt:(double)latitude longitude:(double)longitude isStartNode:(BOOL)isStartNode;

@end
