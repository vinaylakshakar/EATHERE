//
//  EnableLocationViewController.m
//  Eat Here
//
//  Created by Silstone on 30/07/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "EnableLocationViewController.h"
#import "EatHere.pch"

@interface EnableLocationViewController ()

@end

@implementation EnableLocationViewController
{
    NSString *Clatitude;
    NSString *Clongitude,*countryStr;
    CLPlacemark *placemark;
    CLGeocoder *geocoder;
}

@synthesize locationManager;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)CurrentLocationIdentifier
{
    //---- For getting current gps location
    [kAppDelegate showProgressHUD];
    geocoder = [[CLGeocoder alloc] init];
    if (locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        
        if(IS_OS_8_OR_LATER) {
            
            [locationManager requestWhenInUseAuthorization];
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        
        [locationManager startUpdatingLocation];
    }
    [locationManager startUpdatingLocation];
    
    //------
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            //             NSLog(@"%@",[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude]);
            Clatitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
            Clongitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
            
            Clatitude=[NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude];
            Clongitude=[NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude];
            NSLog(@"%@",Clatitude);
            NSLog(@"%@",Clongitude);
            NSLog(@"country %@",placemark.country);
            countryStr = [NSString stringWithFormat:@"%@",placemark.country];
            [USERDEFAULTS setObject:Clatitude forKey:AddressLatitude];
            [USERDEFAULTS setObject:Clongitude forKey:AddressLongitude];
            
            [USERDEFAULTS setObject:Clatitude forKey:CurrentAddressLatitude];
            [USERDEFAULTS setObject:Clongitude forKey:CurrentAddressLongitude];
            
            [USERDEFAULTS synchronize];
            
            [kAppDelegate hideProgressHUD];
//            CreateAccountViewController *createAccount =[self.storyboard instantiateViewControllerWithIdentifier:@"CreateAccountViewController"];
//            [self.navigationController pushViewController:createAccount animated:YES];
            RootPageViewController *PageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RootPageViewController"];
            [self.navigationController pushViewController:PageViewController animated:YES];
        }
        else
        {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
    // Turn off the location manager to save power.
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Cannot find the location.");
    EnterZipViewController *enterZip =[self.storyboard instantiateViewControllerWithIdentifier:@"EnterZipViewController"];
    [self.navigationController pushViewController:enterZip animated:YES];
    [kAppDelegate hideProgressHUD];
//    [USERDEFAULTS setObject:@"30.596404" forKey:AddressLatitude];
//    [USERDEFAULTS setObject:@"76.843266" forKey:AddressLongitude];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)getUserLocation:(id)sender
{
    if ([CLLocationManager locationServicesEnabled]){

        NSLog(@"Location Services Enabled");

        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        {
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"App Permission Denied"
                                                                          message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                                   preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {

                                        }];

            [alert addAction:yesButton];

            [self presentViewController:alert animated:YES completion:nil];

        }else
        {
             [self CurrentLocationIdentifier];
        }
    }else
    {
             [self CurrentLocationIdentifier];
    }
    
 
}

- (IBAction)rejectUserLocation:(id)sender
{
    NSLog(@"reject location");
    EnterZipViewController *enterZip =[self.storyboard instantiateViewControllerWithIdentifier:@"EnterZipViewController"];
    [self.navigationController pushViewController:enterZip animated:YES];
}
@end
