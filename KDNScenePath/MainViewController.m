//
//  ViewController.m
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/21/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import "MainViewController.h"
@import GoogleMaps;

@interface MainViewController ()

@end

@implementation MainViewController {
    CLLocationManager *locationManager;
    __weak IBOutlet GMSMapView *mapView;
    BOOL hasCurrentLocation;
    
    KDNSearchResultsTableViewController* searchResultsTableViewController;
    __weak IBOutlet UIButton *routeButton;
    __weak IBOutlet UIButton *cameraButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    searchResultsTableViewController = [[KDNSearchResultsTableViewController alloc] init];
    searchResultsTableViewController.delegate = self;
    
    hasCurrentLocation = NO;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;

    mapView.myLocationEnabled = YES;
    mapView.settings.myLocationButton = YES;
    [self.view bringSubviewToFront:routeButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        [locationManager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (!hasCurrentLocation) {
        CLLocation *newLocation = [locations lastObject];
        NSLog(@"Current location: %f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                                                longitude:newLocation.coordinate.longitude
                                                                     zoom:15];
        [mapView setCamera:camera];
        
        hasCurrentLocation = YES;
        [self.view bringSubviewToFront:routeButton];
    }
}

-(void)locateWithLatitude:(double)lat andLongitude:(double)lng andTitle:(NSString *)title {
    
}
@end
