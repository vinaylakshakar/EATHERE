//
//  EnableLocationViewController.h
//  Eat Here
//
//  Created by Silstone on 30/07/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface EnableLocationViewController : UIViewController<CLLocationManagerDelegate>
- (IBAction)getUserLocation:(id)sender;
- (IBAction)rejectUserLocation:(id)sender;

@property (nonatomic, retain) CLLocationManager *locationManager;

@end
