//
//  RouteViewController.m
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/22/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import "KDNRouteViewController.h"
#import "KDNConstants.h"
#import "KDNPreferenceManager.h"
#import "KDNUtility.h"
@import GoogleMaps;

@interface KDNRouteViewController ()
@property (weak, nonatomic) IBOutlet UITextField *fromTextField;
@property (weak, nonatomic) IBOutlet UITextField *toTextField;
@property (weak, nonatomic) IBOutlet UISwitch *scenicPathSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *savePreviousSearchSwitch;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UISwitch *googlePathSwitch;
@property (weak, nonatomic) IBOutlet UILabel *budgetLabel;

@property (weak, nonatomic) IBOutlet UISlider *budgetSlider;

@property (strong, nonatomic) KDNSearchResultsTableViewController* searchResultsTableViewController;

@property (strong, nonatomic) KDNLocationInfo* fromLocation;
@property (strong, nonatomic) KDNLocationInfo* toLocation;

@end

@implementation KDNRouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"LOAD");
    // Do any additional setup after loading the view.
    [self.fromTextField addTarget:self action:@selector(fromTextFieldClicked) forControlEvents:UIControlEventEditingDidBegin];
    [self.toTextField addTarget:self action:@selector(toTextFieldClicked) forControlEvents:UIControlEventEditingDidBegin];
    
    self.searchResultsTableViewController = [[KDNSearchResultsTableViewController alloc] init];
    self.searchResultsTableViewController.delegate = self;
    
    [self.scenicPathSwitch setOn:[KDNPreferenceManager getScenicOption] animated:NO];
    [self.googlePathSwitch setOn:[KDNPreferenceManager getGoogleOption] animated:NO];
//    [self updateScenicPathSelection];
    
    if ([KDNPreferenceManager getShouldSavePreviousSearch]) {
        //get info from preference
        [self.savePreviousSearchSwitch setOn:YES animated:NO];
        self.fromLocation = [KDNPreferenceManager getPreviousFromLocation];
        self.toLocation = [KDNPreferenceManager getPreviousToLocation];
    } else {
        //not save previous search
        [self.savePreviousSearchSwitch setOn:NO animated:NO];
    }
    
    //initialize if there is no previous location info
    if (self.fromLocation == nil || self.toLocation == nil) {
        self.fromLocation = [[KDNLocationInfo alloc] initWithLatitude:kAutocompleteBoundTopLeftLatitude longitude:kAutocompleteBoundTopLeftLongitude title:kEmptyString];
        self.toLocation = [[KDNLocationInfo alloc] initWithLatitude:kAutocompleteBoundBottomRightLatitude longitude:kAutocompleteBoundBottomRightLongitude title:kEmptyString];
    }
    
//    NSLog(@"Load fromLocation: %@", [self.fromLocation description]);
//    NSLog(@"Load toLocation: %@", [self.toLocation description]);
    
    [self setTextFieldInitialValues];
    
    int budget = [KDNUtility cmTokm:[KDNPreferenceManager getBudget]];
    self.budgetLabel.text = [NSString stringWithFormat:@"%d", budget];
    self.budgetSlider.value = budget;
}

-(void)setTextFieldInitialValues {
    if ([KDNPreferenceManager getShouldSavePreviousSearch]) {
        [self.fromTextField setText:self.fromLocation.title];
        [self.toTextField setText:self.toLocation.title];
    }
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
    
    //save to preference
    if ([KDNPreferenceManager getShouldSavePreviousSearch]) {
        [KDNPreferenceManager setPreviousFromLocation:self.fromLocation];
    }
//    NSLog(@"Select fromLocation: %@", [self.fromLocation description]);
    
    //update UI
    dispatch_async(dispatch_get_main_queue(),^{
        self.fromTextField.text = title;
    });
}
-(void)setToLocationWithLatitude:(double)lat andLongitude:(double)lng andTitle:(NSString*)title {
    self.toLocation.latitude = lat;
    self.toLocation.longitude = lng;
    self.toLocation.title = title;
    
    //save to preference
    if ([KDNPreferenceManager getShouldSavePreviousSearch]) {
        [KDNPreferenceManager setPreviousToLocation:self.toLocation];
    }
    
//    NSLog(@"Select toLocation: %@", [self.toLocation description]);
    
    //update UI
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
    //Get auto-complete from Google Places API when text is changed
    GMSPlacesClient* placesClient = [[GMSPlacesClient alloc] init];
    
    
    CLLocationCoordinate2D topLeft = CLLocationCoordinate2DMake(kAutocompleteBoundTopLeftLatitude, kAutocompleteBoundTopLeftLongitude);
    CLLocationCoordinate2D bottomRight = CLLocationCoordinate2DMake(kAutocompleteBoundBottomRightLatitude, kAutocompleteBoundBottomRightLongitude);
    
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
                                
                                //add this search text to suggestion: e.g. search by lat long
                                [searchResults addObject:searchText];
                                
                                for (GMSAutocompletePrediction* result in results) {
                                    [searchResults addObject:result.attributedFullText.string];
                                }
                                
                                [self.searchResultsTableViewController reloadDataWithArray:searchResults];
                            }];
}
- (IBAction)searchButtonClicked:(id)sender {
    [self.delegate shouldRouteFrom:self.fromLocation to:self.toLocation];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cancelButtonClicked:(id)sender {
    [self.delegate shouldNotRoute];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)scenicPathSwitchChanged:(id)sender {
    [KDNPreferenceManager setScenicOption:self.scenicPathSwitch.isOn];
//    [self updateScenicPathSelection];
}
- (IBAction)googlePathSwitchChanged:(id)sender {
    [KDNPreferenceManager setGoogleOption:self.googlePathSwitch.isOn];
}
- (IBAction)savePreviousSearchChanged:(id)sender {
    [KDNPreferenceManager setShouldSavePreviousSearch:self.savePreviousSearchSwitch.on];
}

- (IBAction)budgetSliderChanged:(UISlider*)sender {
    int budget = sender.value;
    sender.value = budget;
    self.budgetLabel.text = [NSString stringWithFormat:@"%d", budget];
    
    [KDNPreferenceManager setBudget:[KDNUtility kmToCm:budget]];
}

//NOT CALL NOW
-(void)updateScenicPathSelection {
    //save to preferences
    [KDNPreferenceManager setScenicOption:self.scenicPathSwitch.on];
    
    //Update Search button title
    if ([KDNPreferenceManager getScenicOption]) {
        [self.searchButton setTitle:kSearchButtonWithScenicPath forState:UIControlStateNormal];
    } else {
        [self.searchButton setTitle:kSearchButtonWithoutScenicPath forState:UIControlStateNormal];
    }
}


@end
