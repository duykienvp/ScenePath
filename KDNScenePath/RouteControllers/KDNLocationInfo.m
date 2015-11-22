//
//  KDNLocationInfo.m
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/22/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import "KDNLocationInfo.h"

@implementation KDNLocationInfo

-(id)initWithLatitude:(double)lat longitude:(double)lng title:(NSString *)title {
    self = [super init];
    if (self) {
        self.latitude = lat;
        self.longitude = lng;
        self.title = title;
    }
    return self;
}

@end
