//
//  SearchResultsTableViewController.h
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/21/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KDNMapsLocator <NSObject>

-(void)setFromLocationWithLatitude:(double)lat andLongitude:(double)lng andTitle:(NSString*)title;
-(void)setToLocationWithLatitude:(double)lat andLongitude:(double)lng andTitle:(NSString*)title;

@end

@interface KDNSearchResultsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak) id <KDNMapsLocator> delegate;
@property (nonatomic) BOOL isFromLocation;

/// Reload data of the table with another array
-(void)reloadDataWithArray:(NSArray*)array;

@end
