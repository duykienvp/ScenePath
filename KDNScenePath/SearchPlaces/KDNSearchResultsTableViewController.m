//
//  SearchResultsTableViewController.m
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/21/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import "KDNSearchResultsTableViewController.h"
#import "KDNConstants.h"
#import "KDNGoogleMapsUtility.h"
#import "KDNLocationInfo.h"

@interface KDNSearchResultsTableViewController()
@property (strong, nonatomic) NSArray * searchResults;

@end

@implementation KDNSearchResultsTableViewController

-(void)viewDidLoad {
    self.searchResults = [[NSArray alloc] init];
    [self.tableView registerClass:UITableViewCell.self forCellReuseIdentifier:kSearchResultTableViewCellIdentifier];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kSearchResultTableViewCellIdentifier];
    cell.textLabel.text = self.searchResults[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:true completion:nil];
    NSString* correctedAddress = self.searchResults[indexPath.row];
    correctedAddress = [correctedAddress stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet symbolCharacterSet]];
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:kGoogleMapsGeoCodeFromAddressUrlFormat, correctedAddress]];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        @try {
            if (data != nil) {
                NSDictionary* dict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                NSLog(@"Dict: %@", dict);
                NSArray* results = [dict objectForKey:@"results"];
                NSDictionary* result = [results firstObject];
                if (result != nil) {
                    
                    //parse result
                    NSString* title = [result objectForKey:@"formatted_address"];
                    double latitude = [[[[result objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
                    double longitude = [[[[result objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
                    
                    //set appropriate location
                    if (self.isFromLocation) {
                        [self.delegate setFromLocationWithLatitude:latitude andLongitude:longitude andTitle:title];
                    } else {
                        [self.delegate setToLocationWithLatitude:latitude andLongitude:longitude andTitle:title];
                    }
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error requesting location for address: %@", correctedAddress);
        }
    }] resume];
}
-(void)reloadDataWithArray:(NSArray*)array {
    self.searchResults = array;
    [self.tableView reloadData];
}

@end
