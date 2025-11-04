//
//  SettingsViewController.h
//  Eat Here
//
//  Created by Silstone on 27/06/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *settingsView;
@property (weak, nonatomic) IBOutlet UIScrollView  *scrollview;
- (IBAction)updateProfileImage:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
- (IBAction)rateBtnAction:(id)sender;
- (IBAction)shareBtnAction:(id)sender;
- (IBAction)followUsAction:(id)sender;
- (IBAction)signInAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *signInView;
- (IBAction)signoutAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *logoutBtn;
- (IBAction)feedbackBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *visualEffectView;
@property (strong, nonatomic) IBOutlet UIView *followView;
- (IBAction)hiedeEffectView:(id)sender;
- (IBAction)followInstagram:(id)sender;
- (IBAction)followFacebook:(id)sender;


@end
