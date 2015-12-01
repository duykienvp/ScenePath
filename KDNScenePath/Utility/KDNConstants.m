//
//  Constants.m
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/21/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import "KDNConstants.h"

@implementation KDNConstants

NSString * const kEmptyString = @"";

NSString * const kSearchResultTableViewCellIdentifier = @"SearchResultTableViewCellIdentifier";
NSString * const kSearchButtonWithoutScenicPath = @"Search shortest";
NSString * const kSearchButtonWithScenicPath = @"Search nicest";

double const kAutocompleteBoundTopLeftLatitude = 34.316540;
double const kAutocompleteBoundTopLeftLongitude = -118.612350;
double const kAutocompleteBoundBottomRightLatitude = 33.448647;
double const kAutocompleteBoundBottomRightLongitude = -116.621358;

NSString * const kGooglePathReceivedSuccessfully = @"kGooglePathReceivedSuccessfully";
NSString * const kGooglePathReceivedFailed = @"kGooglePathReceivedFailed";
NSString * const kGooglePathReceivedEncodedPathKey = @"kGooglePathReceivedEncodedPathKey";

NSString * const kSceniceNearestNeighborReceivedSuccessfully = @"kSceniceNearestNeighborReceivedSuccessfully";
NSString * const kSceniceNearestNeighborReceivedFailed = @"kSceniceNearestNeighborReceivedFailed";
NSString * const kSceniceNearestNeighborReceivedNodeInfoKey = @"kSceniceNearestNeighborReceivedNodeInfoKey";
NSString * const kSceniceNearestNeighborReceivedIsScenicKey = @"kSceniceNearestNeighborReceivedIsScenicKey";

NSString * const kSceniceRequestFormat = @"%@/%@?loc=%f,%f";
NSString * const kSceniceBaseURL = @"http://ec2-52-26-11-135.us-west-2.compute.amazonaws.com:10000/duykien-csci587-jetty-oracle-spatial-0.0.1-SNAPSHOT";
NSString * const kSceniceNearestNeighborPath = @"nearestneighbor";

@end
