//
//  KDNLatLng.h
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/30/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDNLatLng : NSObject

@property (nonatomic) double lat;
@property (nonatomic) double lng;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

@end
