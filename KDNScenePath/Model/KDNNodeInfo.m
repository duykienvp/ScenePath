//
//  KDNNodeInfo.m
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/30/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import "KDNNodeInfo.h"

@implementation KDNNodeInfo

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"[KDNNodeInfo: nodeId = %d, nodeName = %@, latitude = %f, longitude = %f, cost = %f]", self.nodeId, self.nodeName, self.latitude, self.longitude, self.cost];
}

@end
