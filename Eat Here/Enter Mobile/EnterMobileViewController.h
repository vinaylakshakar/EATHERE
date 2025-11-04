//
//  EnterMobileViewController.h
//  Eat Here
//
//  Created by Silstone on 25/06/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterMobileViewController : UIViewController
- (IBAction)enterNumberAction:(id)sender;
- (IBAction)pushToOtpScreen:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *mobileField;
- (IBAction)deleteNumberAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *countryCodeField;
- (IBAction)countryCodeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *countryCodeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *countryImage;
@property (weak, nonatomic) IBOutlet UIButton *doneMobileBtn;
@property (nonatomic) bool fromUpdateScreen;

@end
