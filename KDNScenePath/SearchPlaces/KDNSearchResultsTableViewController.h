//
//  SearchResultsTableViewController.h
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/21/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KDNMapsLocator <NSObject>

-(void)locateWithLatitude:(double)lat andLongitude:(double)lng andTitle:(NSString*)title;

@end

@interface KDNSearchResultsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray * searchResults;
@property (weak) id <KDNMapsLocator> delegate;

@end
