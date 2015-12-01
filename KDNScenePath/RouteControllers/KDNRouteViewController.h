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

/// A delegate to find a route
@protocol RouteFindingDelegate <NSObject>

-(void)shouldRouteFrom:(KDNLocationInfo*)fromLocation to:(KDNLocationInfo*)toLocation;
-(void)shouldNotRoute;

@end

@interface KDNRouteViewController : UIViewController <KDNMapsLocator, UISearchBarDelegate>

@property (weak, nonatomic) id <RouteFindingDelegate> delegate;

@end
