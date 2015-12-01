//
//  KDNUtility.m
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/30/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import "KDNUtility.h"

@implementation KDNUtility

+(UIColor*)getGooglePathColor {
    return [UIColor blueColor];
}

+(UIColor*)getScenicPathColor {
    return [UIColor cyanColor];
}

+(UIColor*)getShorestPathColor {
    return [UIColor redColor];
}

+(int)kmToCm:(int)length {
    return length * 1000 * 100;
}

+(int)cmTokm:(int)length {
    return length / 100000;
}

@end
