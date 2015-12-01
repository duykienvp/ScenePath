//
//  Constants.m
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/21/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import "KDNConstants.h"

@implementation KDNConstants

int const kDefaultBudget = 1000000; //in cm

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
NSString * const kGooglePathReceivedPathTypeKey = @"kGooglePathReceivedPathTypeKey";

NSString * const kSceniceNearestNeighborReceivedSuccessfully = @"kSceniceNearestNeighborReceivedSuccessfully";
NSString * const kSceniceNearestNeighborReceivedFailed = @"kSceniceNearestNeighborReceivedFailed";
NSString * const kSceniceNearestNeighborReceivedNodeInfoKey = @"kSceniceNearestNeighborReceivedNodeInfoKey";
NSString * const kSceniceNearestNeighborReceivedIsScenicKey = @"kSceniceNearestNeighborReceivedIsScenicKey";

NSString * const kScenicePathReceivedSuccessfully = @"kScenicePathReceivedSuccessfully";
NSString * const kScenicePathReceivedFailed = @"kScenicePathReceivedFailed";
NSString * const kScenicePathReceivedPathKey = @"kScenicePathReceivedPathKey";

NSString * const kScenicBaseURL = @"http://ec2-52-26-11-135.us-west-2.compute.amazonaws.com:10000/duykien-csci587-jetty-oracle-spatial-0.0.1-SNAPSHOT";
NSString * const kScenicNearestNeighborRequestFormat = @"%@/nearestneighbor?loc=%f,%f";
NSString * const kScenicPathRequestFormat = @"%@/scenicpath?node1=%d&node2=%d&budget=%d";

NSString* const kUploadImageSucceed = @"kUploadImageSucceed";
NSString* const kUploadImageFailed = @"kUploadImageFailed";

NSString* const kImageUploadUrl = @"http://ec2-52-26-11-135.us-west-2.compute.amazonaws.com:10000/duykien-csci587-jetty-oracle-spatial-0.0.1-SNAPSHOT/imageupload";
NSString* const kImageUploadUploadTitle = @"Upload";
NSString* const kImageUploadUploadingTitle = @"Uploading...";
NSString* const kImageUploadDoneTitle = @"Done";
@end
