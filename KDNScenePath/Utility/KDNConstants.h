//
//  Constants.h
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/21/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface KDNConstants : NSObject
typedef NS_ENUM(NSInteger, KDNMyGoogleMapsPathType) {
    KDNMyGoogleMapsPathTypeGoogle,
    KDNMyGoogleMapsPathTypeScenicStartNode,
    KDNMyGoogleMapsPathTypeScenicEndNode
};

extern int const kDefaultBudget;

extern NSString * const kEmptyString;

extern NSString * const kRouteSegueIdentifier;
extern NSString * const kMainToImageUploadSegueIdentifier;

extern NSString * const kSearchResultTableViewCellIdentifier;
extern NSString * const kSearchButtonWithoutScenicPath;
extern NSString * const kSearchButtonWithScenicPath;

extern double const kAutocompleteBoundTopLeftLatitude;
extern double const kAutocompleteBoundTopLeftLongitude;
extern double const kAutocompleteBoundBottomRightLatitude;
extern double const kAutocompleteBoundBottomRightLongitude;

extern NSString * const kGooglePathReceivedSuccessfully;
extern NSString * const kGooglePathReceivedFailed;
extern NSString * const kGooglePathReceivedEncodedPathKey;
extern NSString * const kGooglePathReceivedPathTypeKey;

extern NSString * const kSceniceNearestNeighborReceivedSuccessfully;
extern NSString * const kSceniceNearestNeighborReceivedFailed;
extern NSString * const kSceniceNearestNeighborReceivedNodeInfoKey;
extern NSString * const kSceniceNearestNeighborReceivedIsScenicKey;

extern NSString * const kScenicePathReceivedSuccessfully;
extern NSString * const kScenicePathReceivedFailed;
extern NSString * const kScenicePathReceivedPathKey;

extern NSString * const kScenicBaseURL;
extern NSString * const kScenicNearestNeighborRequestFormat;
extern NSString * const kScenicPathRequestFormat;

extern NSString* const kUploadImageSucceed;
extern NSString* const kUploadImageFailed;

extern NSString* const kImageUploadUrl;
extern NSString* const kImageUploadUploadTitle;
extern NSString* const kImageUploadUploadingTitle;
extern NSString* const kImageUploadDoneTitle;

extern NSString* const kFailedToFindScenicPathMessage;
extern NSString* const kFailedToGetScenicPathMessage;
extern double const kFailedToFindOrGetScenicPathToastDuration;

@end
