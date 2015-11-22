//
//  RouteViewController.h
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/22/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDNLocationInfo.h"
#import "KDNSearchResultsTableViewController.h"

@interface KDNRouteViewController : UIViewController <KDNMapsLocator, UISearchBarDelegate>

@property (strong, nonatomic) KDNLocationInfo* fromLocation;
@property (strong, nonatomic) KDNLocationInfo* toLocation;

@end
