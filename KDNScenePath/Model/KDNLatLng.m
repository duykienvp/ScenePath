//
//  KDNLatLng.m
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/30/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import "KDNLatLng.h"

@implementation KDNLatLng

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

-(NSString*)description {
    return [NSString stringWithFormat:@"[KDNLatLng: lat = %f, lng = %f]", self.lat, self.lng];
}

@end
