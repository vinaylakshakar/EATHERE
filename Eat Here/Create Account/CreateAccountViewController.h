//
//  CreateAccountViewController.h
//  Eat Here
//
//  Created by Silstone on 25/06/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateAccountViewController : UIViewController
- (IBAction)termsConditionAction:(id)sender;
- (IBAction)NewsletterBtnAction:(id)sender;
- (IBAction)createAccount:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIButton *termsConditionBtn;
@property (weak, nonatomic) IBOutlet UIButton *newsLetterBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)showTermsCondition:(id)sender;

@end
