//
//  ViewController.m
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/21/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import "MainViewController.h"
#import "KDNLocationInfo.h"
#import "KDNGoogleMapsUtility.h"
@import GoogleMaps;

@interface MainViewController ()

@property (strong, nonatomic) KDNLocationInfo* fromLocation;
@property (strong, nonatomic) KDNLocationInfo* toLocation;
@property (nonatomic) BOOL isScenic;
@property (nonatomic) BOOL shouldRoute;

@end

@implementation MainViewController {
    CLLocationManager *locationManager;
    __weak IBOutlet GMSMapView *mapView;
    BOOL hasCurrentLocation;
    
    
    __weak IBOutlet UIButton *routeButton;
    __weak IBOutlet UIButton *cameraButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shouldRoute = NO;
    
    //prepare location manager
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

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //if this view appears after choosing routing options, find routes
    if (self.shouldRoute) {
        [self route];
    }
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"routeSegueIdentifier"]) {
        KDNRouteViewController* routeViewController = (KDNRouteViewController*)[segue destinationViewController];
        routeViewController.delegate = self;
    }
}

-(void)shouldRouteFrom:(KDNLocationInfo*)fromLocation to:(KDNLocationInfo*)toLocation withScenic:(BOOL)isScenic {
    self.shouldRoute = YES;
    self.fromLocation = fromLocation;
    self.toLocation = toLocation;
    self.isScenic = isScenic;
}

-(void)route {
    if (self.isScenic) {
        
    } else {
        [self routeGoogleMaps];
    }
}

-(void)routeGoogleMaps {
    NSLog(@"Find route from %@ to %@", [self.fromLocation description], [self.toLocation description]);
    NSString *urlString = [NSString stringWithFormat:
                           @"%@?origin=%f,%f&destination=%f,%f&sensor=true&key=%@",
                           @"https://maps.googleapis.com/maps/api/directions/json",
                           self.fromLocation.latitude,
                           self.fromLocation.longitude,
                           self.toLocation.latitude,
                           self.toLocation.longitude,
                           kGoogleMapsApiServerKey];
    NSURL *directionsURL = [NSURL URLWithString:urlString];
    __weak MainViewController* weakSelf = self;
    
    [[[NSURLSession sharedSession] dataTaskWithURL:directionsURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        @try {
            if (data != nil) {
                NSDictionary* dict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"Dict: %@", dict);
                NSString* status = dict[@"status"];
                if ([status isEqualToString:@"OK"]) {
                    dispatch_async(dispatch_get_main_queue(),^{
                        //update path
                        GMSPath *path =[GMSPath pathFromEncodedPath:dict[@"routes"][0][@"overview_polyline"][@"points"]];
                        GMSPolyline *singleLine = [GMSPolyline polylineWithPath:path];
                        singleLine.strokeWidth = 5;
                        singleLine.strokeColor = [UIColor blueColor];
                        singleLine.map = mapView;
                        
                        //update markers at start/end positions
                        CLLocationCoordinate2D fromPosition = CLLocationCoordinate2DMake(weakSelf.fromLocation.latitude, weakSelf.fromLocation.longitude);
                        GMSMarker *fromMarker = [GMSMarker markerWithPosition:fromPosition];
                        fromMarker.title = weakSelf.fromLocation.title;
                        fromMarker.map = mapView;
                        
                        CLLocationCoordinate2D toPosition = CLLocationCoordinate2DMake(weakSelf.toLocation.latitude, weakSelf.toLocation.longitude);
                        GMSMarker *toMarker = [GMSMarker markerWithPosition:toPosition];
                        toMarker.title = weakSelf.toLocation.title;
                        toMarker.map = mapView;
                        
                        //find max/min lat/long for camera bounds
                        double maxLat = -DBL_MAX;
                        double minLat = DBL_MAX;
                        double maxLong = -DBL_MAX;
                        double minLong = DBL_MAX;
                        for (int i = 0; i < path.count; i++) {
                            double aLat = [path coordinateAtIndex:i].latitude;
                            double aLong = [path coordinateAtIndex:i].longitude;
                            
                            maxLat = maxLat < aLat ? aLat : maxLat;
                            minLat = aLat < minLat ? aLat : minLat;
                            
                            maxLong = maxLong < aLong ? aLong : maxLong;
                            minLong = aLong < minLong ? aLong : minLong;
                        }
                        
                        //update map bounds
                        GMSCoordinateBounds* bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:CLLocationCoordinate2DMake(maxLat, maxLong)
                                                                                           coordinate:CLLocationCoordinate2DMake(minLat, minLong)];
                        [mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds]];
                    });
                } else {
                    NSLog(@"Error getting route: status = %@", status);
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error requesting route: %@", [exception description]);
        }
    }] resume];
}

@end
