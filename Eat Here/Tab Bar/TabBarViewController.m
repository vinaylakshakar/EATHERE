//
//  TabBarViewController.m
//  Eat Here
//
//  Created by Silstone on 26/06/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "TabBarViewController.h"
#import "EatHere.pch"

@interface TabBarViewController ()
{
    AppDelegate *myAppDelegate;
}

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.delegate = self;
    self.tabBarController.delegate = self;
    [USERDEFAULTS setObject:@"isdashboard" forKey:kuserDashboard];
    
    if (IS_OS_13_OR_LATER) {
        [[self.tabBar.items objectAtIndex:0] setImageInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
        [[self.tabBar.items objectAtIndex:1] setImageInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
        [[self.tabBar.items objectAtIndex:2] setImageInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
        [[self.tabBar.items objectAtIndex:3] setImageInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
        [[self.tabBar.items objectAtIndex:4] setImageInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
      
    } else {
        [[self.tabBar.items objectAtIndex:0] setImageInsets:(UIEdgeInsetsMake(0, 0, -12, 0))];
        [[self.tabBar.items objectAtIndex:1] setImageInsets:(UIEdgeInsetsMake(0, 0, -12, 0))];
        [[self.tabBar.items objectAtIndex:2] setImageInsets:(UIEdgeInsetsMake(0, 0, -12, 0))];
        [[self.tabBar.items objectAtIndex:3] setImageInsets:(UIEdgeInsetsMake(0, 0, -12, 0))];
        [[self.tabBar.items objectAtIndex:4] setImageInsets:(UIEdgeInsetsMake(0, 0, -12, 0))];
    }

//    NSOperatingSystemVersion ios8_0_1 = (NSOperatingSystemVersion){13, 0, 0};
//    if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:ios8_0_1]) {
//        // iOS 8.0.1 and above logic
//    } else {
//        // iOS 8.0.0 and below logic
//    }

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

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    NSUInteger indexOfTab = [tabBarController.viewControllers indexOfObject:viewController];
    myAppDelegate.willSelectedTab = indexOfTab;
    if (![USERDEFAULTS valueForKey:kuserID]&& indexOfTab==3)
    {
//        UINavigationController *nav;
//        if(myAppDelegate.selectedTab == 0)
//        {
//            UINavigationController *nav = []
//        }
        UINavigationController *prevNavigationController = tabBarController.selectedViewController;
        [self showAlert:@"you need to be login to view the news feed":prevNavigationController];
        return false;
        
    }else
    {
        myAppDelegate.selectedTab = self.selectedIndex;
        // [self showAlert:@"You are not register user. Please login!"];
        
        if (indexOfTab==2)
        {
            [NSTimer scheduledTimerWithTimeInterval:0.2 target: self
                                           selector: @selector(callAfterSixtySecond:) userInfo: nil repeats: NO];
            
        }
        return true;
        
    }
    
}

- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController {
    
    
}

-(void)callAfterSixtySecond:(NSTimer*) t
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Randomizer" object:self userInfo:nil];
}


-(void)showAlert:(NSString*)messageText :(UINavigationController *)navController
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Eat Here!" message:messageText preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"LOGIN" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                    [Utility PushtoLoginPage:navController];
                         }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        NSLog(@"%ld",(long)myAppDelegate.selectedTab);
        self.selectedIndex = myAppDelegate.selectedTab;
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [alert.view setTintColor:[UIColor redColor]];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
