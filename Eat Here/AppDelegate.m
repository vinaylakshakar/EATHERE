//
//  AppDelegate.m
//  Eat Here
//
//  Created by Silstone on 25/06/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "EatHere.pch"

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    Reachability *networkReachability;
    NetworkStatus networkStatus;
    UIStoryboard *storyboard;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    //SegoeUI
    //SegoeUI-Light
   
    if ([USERDEFAULTS valueForKey:kuserDashboard])
    {
         storyboard = [self grabStoryboard];
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        TabBarViewController *TabBarVC = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
        self.window.rootViewController = TabBarVC;
        [self.window makeKeyAndVisible];
    }
    else{
        storyboard = [self grabStoryboard];
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        UINavigationController *TabBarVC = [storyboard instantiateViewControllerWithIdentifier:@"LocationNavigationVC"];
        self.window.rootViewController = TabBarVC;
        [self.window makeKeyAndVisible];
    }
   
    sleep(2);
    return YES;
}


- (UIStoryboard *)grabStoryboard {
    
    UIStoryboard *storyboard;
    
    if ([[UIScreen mainScreen] bounds].size.height >= 812.0) {
        //        storyboard = [UIStoryboard storyboardWithName:@"StoryboardX" bundle:nil];
        storyboard = [UIStoryboard storyboardWithName:@"MainIphoneX" bundle:nil];
    }
    else {
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        // NSLog(@"Device has a 4inch Display.");
    }
    
    return storyboard;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [USERDEFAULTS setObject:@"true" forKey:AppKilled];
    [USERDEFAULTS synchronize];
}

#pragma progressHUD

-(void)showProgressHUD
{
    
    networkReachability = [Reachability reachabilityForInternetConnection];
    networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!"
                                                                      message:@"No Network Connection!."
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        
                                    }];
        
        [alert addAction:yesButton];
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        
    }else
    {
        [self createProgressHud];
        [self.window bringSubviewToFront:_progressHUD];
        [_progressHUD showAnimated:YES];
        
    }
}

-(void)showProgressHUDInView:(UIView *)view
{
    
    networkReachability = [Reachability reachabilityForInternetConnection];
    networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"No NetWork Connection!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }else
    {
        [self createProgressHud];
        [view bringSubviewToFront:_progressHUD];
        [_progressHUD showAnimated:YES];
        
    }
}


//Hide Progress HUD
-(void)hideProgressHUD
{
    [_progressHUD hideAnimated:YES];
}
//Create Progress HUD
-(void)createProgressHud
{
    if(_progressHUD)
    {
        return;
    }
    else
    {
        _progressHUD=[[MBProgressHUD alloc]initWithView:self.window];
        _progressHUD.label.text = @"Loading...";
        [self.window addSubview:_progressHUD];
    }
}


@end
