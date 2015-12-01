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
#import "KDNLatLng.h"

@implementation KDNScenicPathHelper

+(void)getRoadNetworkNearestNeightborAt:(double)latitude longitude:(double)longitude isStartNode:(BOOL)isStartNode {
    NSLog(@"Find nearest neighbor for %f, %f, %s", latitude, longitude, isStartNode ? "YES" : "NO");
    NSString *urlString = [NSString stringWithFormat:
                           kScenicNearestNeighborRequestFormat,
                           kScenicBaseURL,
                           latitude,
                           longitude];
    NSURL *directionsURL = [NSURL URLWithString:urlString];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:directionsURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        @try {
            if (data != nil) {
                NSDictionary* dict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                NSLog(@"received: %@", dict);
                KDNNodeInfo* nodeId = [[KDNNodeInfo alloc] initWithDictionary:dict];
                
                NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
                [userInfo setObject:nodeId forKey:kSceniceNearestNeighborReceivedNodeInfoKey];
                [userInfo setObject:[NSNumber numberWithBool:isStartNode] forKey:kSceniceNearestNeighborReceivedIsScenicKey];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kSceniceNearestNeighborReceivedSuccessfully object:nil userInfo:userInfo];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error requesting route: %@", [exception description]);
            [[NSNotificationCenter defaultCenter] postNotificationName:kSceniceNearestNeighborReceivedFailed object:nil];
        }
    }] resume];
}

+(void)getScenicPathFrom:(KDNNodeInfo *)startNode to:(KDNNodeInfo *)endNode budget:(int)budget {
    NSLog(@"Get SCENIC path for %@, %@, %d", startNode, endNode, budget);
    NSString *urlString = [NSString stringWithFormat:
                           kScenicPathRequestFormat,
                           kScenicBaseURL,
                           startNode.nodeId,
                           endNode.nodeId,
                           budget];
//    NSLog(@"Request: %@", urlString);
    NSURL *directionsURL = [NSURL URLWithString:urlString];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:directionsURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        @try {
            if (data != nil) {
                NSArray* pointData = (NSArray*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                NSLog(@"received: %@", pointData);
                NSMutableArray* points = [[NSMutableArray array] init];
                for (int i = 0; i < pointData.count; i++) {
                    NSDictionary* pointDict = [pointData objectAtIndex:i];
                    KDNLatLng* point = [[KDNLatLng alloc] initWithDictionary:pointDict];
                    
                    [points addObject:point];
                }
                
                NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
                [userInfo setObject:points forKey:kScenicePathReceivedPathKey];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kScenicePathReceivedSuccessfully object:nil userInfo:userInfo];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error requesting route: %@", [exception description]);
            [[NSNotificationCenter defaultCenter] postNotificationName:kScenicePathReceivedFailed object:nil];
        }
    }] resume];

}

@end
