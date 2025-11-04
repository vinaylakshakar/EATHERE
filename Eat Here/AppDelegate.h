//
//  AppDelegate.h
//  Eat Here
//
//  Created by Silstone on 25/06/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    MBProgressHUD *_progressHUD;
    
}
@property (strong, nonatomic) UIWindow *window;
@property NSInteger selectedTab;
@property NSInteger willSelectedTab;
- (void)showProgressHUD;
- (void)hideProgressHUD;
-(void)showProgressHUDInView:(UIView *)view;
- (UIStoryboard *)grabStoryboard;


@end

