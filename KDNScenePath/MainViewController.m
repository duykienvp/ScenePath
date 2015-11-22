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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];

    mapView.myLocationEnabled = YES;
    mapView.settings.myLocationButton = YES;
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
    CLLocation *newLocation = [locations lastObject];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                                            longitude:newLocation.coordinate.longitude
                                                                 zoom:15];
    [mapView setCamera:camera];
    
    [manager stopUpdatingLocation];
}

@end
