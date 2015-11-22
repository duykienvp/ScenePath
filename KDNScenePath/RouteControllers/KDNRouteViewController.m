//
//  RouteViewController.m
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/22/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import "KDNRouteViewController.h"
@import GoogleMaps;

@interface KDNRouteViewController ()
@property (weak, nonatomic) IBOutlet UITextField *fromTextField;
@property (weak, nonatomic) IBOutlet UITextField *toTextField;
@property (weak, nonatomic) IBOutlet UISwitch *scenicPathSwitch;

@property (strong, nonatomic) KDNSearchResultsTableViewController* searchResultsTableViewController;

@end

@implementation KDNRouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.fromTextField addTarget:self action:@selector(fromTextFieldClicked) forControlEvents:UIControlEventEditingDidBegin];
    [self.toTextField addTarget:self action:@selector(toTextFieldClicked) forControlEvents:UIControlEventEditingDidBegin];
    
    self.searchResultsTableViewController = [[KDNSearchResultsTableViewController alloc] init];
    self.searchResultsTableViewController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)fromTextFieldClicked {
    self.searchResultsTableViewController.isFromLocation = YES;
    [self showSearchControllerWithPlaceholder:self.fromTextField.text];
}

-(void)toTextFieldClicked {
    self.searchResultsTableViewController.isFromLocation = NO;
    [self showSearchControllerWithPlaceholder:self.toTextField.text];
}

-(void)setFromLocationWithLatitude:(double)lat andLongitude:(double)lng andTitle:(NSString*)title {
    self.fromLocation.latitude = lat;
    self.fromLocation.longitude = lng;
    self.fromLocation.title = title;
    
    dispatch_async(dispatch_get_main_queue(),^{
        self.fromTextField.text = title;
    });
}
-(void)setToLocationWithLatitude:(double)lat andLongitude:(double)lng andTitle:(NSString*)title {
    self.toLocation.latitude = lat;
    self.toLocation.longitude = lng;
    self.toLocation.title = title;
    
    
    dispatch_async(dispatch_get_main_queue(),^{
        self.toTextField.text = title;
    });
}

-(void)showSearchControllerWithPlaceholder:(NSString*)placeholder {
    UISearchController* searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultsTableViewController];
    searchController.searchBar.delegate = self;
    searchController.searchBar.placeholder = placeholder;
    [self presentViewController:searchController animated:YES completion:nil];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    GMSPlacesClient* placesClient = [[GMSPlacesClient alloc] init];
    
    CLLocationCoordinate2D topLeft = CLLocationCoordinate2DMake(34.316540, -118.612350);
    CLLocationCoordinate2D bottomRight = CLLocationCoordinate2DMake(33.448647, -116.621358);
    
    GMSCoordinateBounds* bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:topLeft coordinate:bottomRight];
    
    [placesClient autocompleteQuery:searchText
                              bounds:bounds
                              filter:nil
                            callback:^(NSArray *results, NSError *error) {
                                if (error != nil) {
                                    NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                    return;
                                }
                                
                                NSMutableArray* searchResults = [[NSMutableArray alloc] init];
                                NSLog(@"Results %@", results);
                                
                                for (GMSAutocompletePrediction* result in results) {
                                    [searchResults addObject:result.attributedFullText.string];
                                }
                                
                                [self.searchResultsTableViewController reloadDataWithArray:searchResults];
                            }];
}

@end
