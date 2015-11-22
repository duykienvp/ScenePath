//
//  KDNLocationInfo.h
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/22/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDNLocationInfo : NSObject

@property (strong, nonatomic) NSString* title;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

-(id)initWithLatitude:(double)lat longitude:(double)lng title:(NSString*)title;

@end
