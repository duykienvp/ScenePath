//
//  KDNScenicPathHelper.m
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/30/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import "KDNScenicPathHelper.h"
#import "KDNNodeInfo.h"
#import "KDNConstants.h"

@implementation KDNScenicPathHelper

+(void)getRoadNetworkNearestNeightborAt:(double)latitude longitude:(double)longitude isStartNode:(BOOL)isStartNode {
    NSLog(@"Find nearest neighbor for %f, %f, %s", latitude, longitude, isStartNode ? "YES" : "NO");
    NSString *urlString = [NSString stringWithFormat:
                           kSceniceRequestFormat,
                           kSceniceBaseURL,
                           kSceniceNearestNeighborPath,
                           latitude,
                           longitude];
    NSURL *directionsURL = [NSURL URLWithString:urlString];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:directionsURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        @try {
            if (data != nil) {
                NSDictionary* dict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                NSLog(@"received: %@", dict);
                KDNNodeInfo* nodeId = [[KDNNodeInfo alloc] initWithDictionary:dict];
                
                NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
                [data setObject:nodeId forKey:kSceniceNearestNeighborReceivedNodeInfoKey];
                [data setObject:[NSNumber numberWithBool:isStartNode] forKey:kSceniceNearestNeighborReceivedIsScenicKey];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kSceniceNearestNeighborReceivedSuccessfully object:nil userInfo:data];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error requesting route: %@", [exception description]);
            [[NSNotificationCenter defaultCenter] postNotificationName:kSceniceNearestNeighborReceivedFailed object:nil];
        }
    }] resume];
}

@end
