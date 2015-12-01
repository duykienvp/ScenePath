//
//  KDNNodeInfo.h
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/30/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDNNodeInfo : NSObject

@property (nonatomic) int nodeId;
@property (strong, nonatomic) NSString* nodeName;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) double cost;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

@end
