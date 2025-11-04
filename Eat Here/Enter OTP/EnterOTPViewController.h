//
//  EnterOTPViewController.h
//  Eat Here
//
//  Created by Silstone on 25/06/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterOTPViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *firstNumberField;
@property (weak, nonatomic) IBOutlet UITextField *secondNumberField;
@property (weak, nonatomic) IBOutlet UITextField *thirdNumberField;
@property (weak, nonatomic) IBOutlet UITextField *fourthNumberField;
- (IBAction)deleteNumberAction:(id)sender;
- (IBAction)enterNumberAction:(id)sender;
- (IBAction)pushToCreateAccount:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *doneOTPbtn;
- (IBAction)resendOtpAction:(id)sender;
@property (strong, nonatomic) NSString *otpNumber;
@property (strong, nonatomic) NSString *mobileNumber;
@property(nonatomic)bool fromUpdateScreen;

@end
