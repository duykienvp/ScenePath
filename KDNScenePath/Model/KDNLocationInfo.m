//
//  KDNLocationInfo.m
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/22/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import "KDNLocationInfo.h"

@implementation KDNLocationInfo

NSString* const kLatitudeCodingKey = @"kLatitudeCodingKey";
NSString* const kLongitudeCodingKey = @"kLongitudeCodingKey";
NSString* const kTitleCodingKey = @"kTitleCodingKey";

-(id)initWithLatitude:(double)lat longitude:(double)lng title:(NSString *)title {
    self = [super init];
    if (self) {
        self.latitude = lat;
        self.longitude = lng;
        self.title = title;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeDouble:self.latitude forKey:kLatitudeCodingKey];
    [aCoder encodeDouble:self.longitude forKey:kLongitudeCodingKey];
    [aCoder encodeObject:self.title forKey:kTitleCodingKey];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.latitude = [aDecoder decodeDoubleForKey:kLatitudeCodingKey];
        self.longitude = [aDecoder decodeDoubleForKey:kLongitudeCodingKey];
        self.title = [aDecoder decodeObjectForKey:kTitleCodingKey];
    }
    return self;
}

-(NSString*)description {
    return [NSString stringWithFormat:@"[KDNLocationInfo: title = %@, latitude = %f, longitude = %f]", self.title, self.latitude, self.longitude];
}

@end
