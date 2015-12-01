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
#import "KDNGoogleMapsHelper.h"
#import "KDNNodeInfo.h"
#import "KDNConstants.h"
#import "KDNScenicPathHelper.h"
#import "KDNPreferenceManager.h"
#import "KDNUtility.h"
#import "KDNLatLng.h"
#import "KDNImageUploadViewController.h"
@import GoogleMaps;

@interface MainViewController ()

@property (strong, nonatomic) KDNLocationInfo* fromLocation;
@property (strong, nonatomic) KDNLocationInfo* toLocation;
@property (nonatomic) BOOL shouldRoute;
@property (strong, nonatomic) KDNNodeInfo* startNode;
@property (strong, nonatomic) KDNNodeInfo* endNode;

@property (strong, nonatomic) UIImage* imageToUpload;

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
    
    //add observer for getting Google path
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(routeGoogleMapsSucceeded:)
                                                 name:kGooglePathReceivedSuccessfully
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(routeGoogleMapsFailed:)
                                                 name:kGooglePathReceivedFailed
                                               object:nil];
    
    //add observer for getting nearest neighbors
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNodeInfoSucceeded:)
                                                 name:kSceniceNearestNeighborReceivedSuccessfully
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNodeInfoFailed:)
                                                 name:kSceniceNearestNeighborReceivedFailed
                                               object:nil];
    
    //add observer for getting scenic path
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedScenicPathSucceeded:)
                                                 name:kScenicePathReceivedSuccessfully
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedScenicPathFailed:)
                                                 name:kScenicePathReceivedFailed
                                               object:nil];
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
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse
        || status == kCLAuthorizationStatusAuthorizedAlways) {
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
    } else if ([segue.identifier isEqualToString:@"mainToImageUploadSegueIdentifier"]) {
        KDNImageUploadViewController* imageUploadViewController = (KDNImageUploadViewController*)[segue destinationViewController];
        imageUploadViewController.image = self.imageToUpload;
    }
}

-(void)shouldRouteFrom:(KDNLocationInfo*)fromLocation to:(KDNLocationInfo*)toLocation {
    self.shouldRoute = YES;
    self.fromLocation = fromLocation;
    self.toLocation = toLocation;
}

-(void)shouldNotRoute {
    self.shouldRoute = NO;
}

-(void)route {
    dispatch_async(dispatch_get_main_queue(),^{
        //clear the old map
        [mapView clear];
    });
    
    if ([KDNPreferenceManager getScenicOption]) {
        [self routeScenic];
    }
    if ([KDNPreferenceManager getGoogleOption]) {
        [self routeGoogleMaps];
    }
    
    if ([KDNPreferenceManager getScenicOption]
        || [KDNPreferenceManager getGoogleOption]) {
        [self updateMapMarkers];
        [self updateMapCamera];
    }
//    if (self.isScenic) {
//        [self routeScenic];
//    } else {
//        [self routeGoogleMaps];
//    }
}

-(void)routeScenic {
    [KDNScenicPathHelper getRoadNetworkNearestNeightborAt:self.fromLocation.latitude
                                                longitude:self.fromLocation.longitude
                                              isStartNode:YES];
}

-(void)receivedNodeInfoFailed:(NSNotification*)notification {
    NSLog(@"Failed to get nearest neighbor");
}

-(void)receivedNodeInfoSucceeded:(NSNotification*)notification {
//     NSLog(@"SUCCEEDED to get nearest neighbor: %@", [notification userInfo]);
    BOOL isStartNode = [[[notification userInfo] valueForKey:kSceniceNearestNeighborReceivedIsScenicKey] boolValue];
    if (isStartNode) {
        self.startNode = [[notification userInfo] valueForKey:kSceniceNearestNeighborReceivedNodeInfoKey];
//        NSLog(@"startNode: %@", self.startNode);
        //if we just get the startNode, we need to get endNode
        [KDNScenicPathHelper getRoadNetworkNearestNeightborAt:self.toLocation.latitude
                                                    longitude:self.toLocation.longitude
                                                  isStartNode:NO];
    } else {
        self.endNode = [[notification userInfo] valueForKey:kSceniceNearestNeighborReceivedNodeInfoKey];
//        NSLog(@"endNode: %@", self.endNode);
        //if we get endNode, start doing jobs
        KDNLocationInfo* startNodeLocation = [[KDNLocationInfo alloc] initWithLatitude:self.startNode.latitude
                                                                             longitude:self.startNode.longitude
                                                                                 title:self.startNode.nodeName];
        KDNLocationInfo* endNodeLocation = [[KDNLocationInfo alloc] initWithLatitude:self.endNode.latitude
                                                                           longitude:self.endNode.longitude
                                                                               title:self.endNode.nodeName];
        
        //get Goolge's path from fromLocation to startNode, and from endNode to toLocation
        [KDNGoogleMapsHelper getEncodedGmsPathFrom:self.fromLocation
                                                to:startNodeLocation
                                          pathType:KDNMyGoogleMapsPathTypeScenic];
        [KDNGoogleMapsHelper getEncodedGmsPathFrom:endNodeLocation
                                                to:self.toLocation
                                          pathType:KDNMyGoogleMapsPathTypeScenic];
        //get Scenic path from startNode to endNode
        int budget = [KDNPreferenceManager getBudget];
        if (budget == 0) {
            budget = kDefaultBudget;
            [KDNPreferenceManager setBudget:budget];
        }
        [KDNScenicPathHelper getScenicPathFrom:self.startNode
                                            to:self.endNode
                                        budget:budget];
    }
}

-(void)receivedScenicPathSucceeded:(NSNotification*)notification {
    NSLog(@"<%@:%@:%d>: Scenic OK", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
    GMSPath* path = [KDNGoogleMapsUtility constructPathFromPoints:[[notification userInfo] objectForKey:kScenicePathReceivedPathKey]];
    [self drawPathFromPath:path color:[KDNUtility getScenicPathColor]];
}

-(void)receivedScenicPathFailed:(NSNotification*)notification {
    NSLog(@"Failed to get scenic path");
}


-(void)routeGoogleMaps {
    [KDNGoogleMapsHelper getEncodedGmsPathFrom:self.fromLocation to:self.toLocation pathType:KDNMyGoogleMapsPathTypeGoogle];
}

-(void)routeGoogleMapsFailed:(NSNotification*)notification {
    NSLog(@"Failed to get Google Path");
}

-(void)routeGoogleMapsSucceeded:(NSNotification*)notification {
    NSString* encodedGmsPath = [[notification userInfo] valueForKey:kGooglePathReceivedEncodedPathKey];
    if (encodedGmsPath == nil) {
        return;
    }
//    NSLog(@"encodedGmsPath = %@", encodedGmsPath);
    KDNMyGoogleMapsPathType pathType = [[[notification userInfo] valueForKey:kGooglePathReceivedPathTypeKey] integerValue];
    if (pathType == KDNMyGoogleMapsPathTypeGoogle) {
        [self drawPathFromEncodedPath:encodedGmsPath
                     color:[KDNUtility getGooglePathColor]];
    } else if (pathType == KDNMyGoogleMapsPathTypeScenic) {
        [self drawPathFromEncodedPath:encodedGmsPath
                     color:[KDNUtility getScenicPathColor]];
    }
}

-(void)drawPathFromEncodedPath:(NSString*)encodedGmsPath color:(UIColor*)color{
    GMSPath *path =[GMSPath pathFromEncodedPath:encodedGmsPath];
    [self drawPathFromPath:path color:color];
}

-(void)drawPathFromPath:(GMSPath*)path color:(UIColor*)color{
    dispatch_async(dispatch_get_main_queue(),^{
        //update path
        GMSPolyline *singleLine = [GMSPolyline polylineWithPath:path];
        singleLine.strokeWidth = 5;
        singleLine.strokeColor = color;
        singleLine.map = mapView;
    });
}

-(void)updateMapMarkers {
    __weak MainViewController* weakSelf = self;
    dispatch_async(dispatch_get_main_queue(),^{
        //update markers at start/end positions
        CLLocationCoordinate2D fromPosition = CLLocationCoordinate2DMake(weakSelf.fromLocation.latitude, weakSelf.fromLocation.longitude);
        GMSMarker *fromMarker = [GMSMarker markerWithPosition:fromPosition];
        fromMarker.title = weakSelf.fromLocation.title;
        fromMarker.map = mapView;
        
        CLLocationCoordinate2D toPosition = CLLocationCoordinate2DMake(weakSelf.toLocation.latitude, weakSelf.toLocation.longitude);
        GMSMarker *toMarker = [GMSMarker markerWithPosition:toPosition];
        toMarker.title = weakSelf.toLocation.title;
        toMarker.map = mapView;
    });
}
-(void)updateMapCamera {
    __weak MainViewController* weakSelf = self;
    dispatch_async(dispatch_get_main_queue(),^{
        //find max/min lat/long for camera bounds
        double maxLat;
        double maxLng;;
        
        double minLat;
        double minLng;
        
        if (weakSelf.fromLocation.latitude < weakSelf.toLocation.latitude) {
            minLat = weakSelf.fromLocation.latitude;
            maxLat = weakSelf.toLocation.latitude;
        } else {
            minLat = weakSelf.toLocation.latitude;
            maxLat = weakSelf.fromLocation.latitude;
        }
        
        if (weakSelf.fromLocation.longitude < weakSelf.toLocation.longitude) {
            minLng = weakSelf.fromLocation.longitude;
            maxLng = weakSelf.toLocation.longitude;
        } else {
            minLng = weakSelf.toLocation.longitude;
            maxLng = weakSelf.fromLocation.longitude;
        }
        
        //update map bounds
        GMSCoordinateBounds* bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:CLLocationCoordinate2DMake(maxLat, maxLng)
                                                                           coordinate:CLLocationCoordinate2DMake(minLat, minLng)];
        [mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds]];
    });
}

- (IBAction)uploadImageClicked:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    
    //TODO:
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
//    {
//        [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//    }
//    [imagePickerController setAllowsEditing:false];
    
    // image picker needs a delegate,
    [imagePickerController setDelegate:self];
    
    // Place image picker on the screen
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

//delegate methode will be called after picking photo either from camera or library
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.imageToUpload = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self performSegueWithIdentifier:@"mainToImageUploadSegueIdentifier" sender:self];
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    NSLog(@"%@", UIImageJPEGRepresentation(image, 1.0));
//    
//    //show image upload
//    KDNImageUploadViewController* imageUploadViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"imageUploadViewController"];
//    [imageUploadViewController.imageView setImage:image];
//    [self presentViewController:imageUploadViewController animated:YES completion:nil];
}


@end
