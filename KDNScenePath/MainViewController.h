//
//  ViewController.h
//  KDNScenePath
//
//  Created by Kien Nguyen Duy on 11/21/15.
//  Copyright © 2015 Kien Nguyen Duy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "KDNRouteViewController.h"

@interface MainViewController : UIViewController <CLLocationManagerDelegate, RouteFindingDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

