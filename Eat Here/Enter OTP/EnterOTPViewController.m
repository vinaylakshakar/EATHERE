//
//  EnterOTPViewController.m
//  Eat Here
//
//  Created by Silstone on 25/06/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "EnterOTPViewController.h"
#import "EatHere.pch"
#import "Utility.h"

@interface EnterOTPViewController ()
{
    NSMutableArray *NumberArray;
    TokenProcess *sampleProtocol;
}

@end

@implementation EnterOTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      NumberArray =[[NSMutableArray alloc]init];
    [self.doneOTPbtn setEnabled:NO];
    self.firstNumberField.text =[self.otpNumber substringWithRange:NSMakeRange(0, self.otpNumber.length-3)];
    self.secondNumberField.text =[self.otpNumber substringWithRange:NSMakeRange(1,self.otpNumber.length-3)];
    self.thirdNumberField.text =[self.otpNumber substringWithRange:NSMakeRange(2, self.otpNumber.length-3)];
    self.fourthNumberField.text =[self.otpNumber substringWithRange:NSMakeRange(3, self.otpNumber.length-3)];
    [self.doneOTPbtn setEnabled:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)deleteNumberAction:(id)sender
{
    if (![self.fourthNumberField.text isEqualToString:@""]) {
        self.fourthNumberField.text = @"";
        [self.doneOTPbtn setEnabled:NO];
    }
    else
        if (![self.thirdNumberField.text isEqualToString:@""]) {
            self.thirdNumberField.text = @"";
        }
        else
            if (![self.secondNumberField.text isEqualToString:@""]) {
                self.secondNumberField.text = @"";
            }
            else
                if (![self.firstNumberField.text isEqualToString:@""]) {
                    self.firstNumberField.text = @"";
                }
}

- (IBAction)enterNumberAction:(id)sender
{
    if ([self.firstNumberField.text isEqualToString:@""]) {
        self.firstNumberField.text = [NSString stringWithFormat:@"%ld",[sender tag]-10];
    }
    else
    if ([self.secondNumberField.text isEqualToString:@""]) {
        self.secondNumberField.text = [NSString stringWithFormat:@"%ld",[sender tag]-10];
    }
    else
    if ([self.thirdNumberField.text isEqualToString:@""]) {
        self.thirdNumberField.text = [NSString stringWithFormat:@"%ld",[sender tag]-10];
    }
    else
    if ([self.fourthNumberField.text isEqualToString:@""]) {
        self.fourthNumberField.text = [NSString stringWithFormat:@"%ld",[sender tag]-10];
        [self.doneOTPbtn setEnabled:YES];
    }
}
-(IBAction)CancelClick:(id)sender
{
    if(self.fromUpdateScreen)
    {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)pushToCreateAccount:(id)sender
{
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
     if(self.fromUpdateScreen)
     {
         [self updatePhoneNumber];
         
     }
     else{
         if ([[USERDEFAULTS valueForKey:kuserID] intValue]==0)
         {
             [USERDEFAULTS removeObjectForKey:kuserID];
             CreateAccountViewController *createAccount =[self.storyboard instantiateViewControllerWithIdentifier:@"CreateAccountViewController"];
             [self.navigationController pushViewController:createAccount animated:YES];
         } else {
             NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
             int count = (int)[allViewControllers count];
             UIViewController *aViewController = [allViewControllers objectAtIndex:count-3];
              [self.tabBarController setSelectedIndex:del.willSelectedTab];
        [self.navigationController popToViewController:aViewController animated:NO];
            
                 
             }
     }
    
}
- (IBAction)resendOtpAction:(id)sender {
    [self resendOtp];
}

-(void)resendOtp
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.mobileNumber forKey:@"mobile_number"];
    [dict setObject:@"ios" forKey:@"device_type"];
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        [dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"device_token"];
        
    }
    else{
        [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"device_token"];
        
    }
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]loginUser:^(id object)
     {
         
         NSLog(@"%@",object);

         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             //[kAppDelegate hideProgressHUD];
             self.firstNumberField.text =[[[object valueForKey:@"OTP"] stringValue] substringWithRange:NSMakeRange(0, self.otpNumber.length-3)];
             self.secondNumberField.text =[[[object valueForKey:@"OTP"] stringValue] substringWithRange:NSMakeRange(1,self.otpNumber.length-3)];
             self.thirdNumberField.text =[[[object valueForKey:@"OTP"] stringValue] substringWithRange:NSMakeRange(2, self.otpNumber.length-3)];
             self.fourthNumberField.text =[[[object valueForKey:@"OTP"] stringValue] substringWithRange:NSMakeRange(3, self.otpNumber.length-3)];
             [self.doneOTPbtn setEnabled:YES];
             
             
         } else
         {
             
             [sampleProtocol startSampleProcess];
         }
         
         //[kAppDelegate hideProgressHUD];
         
         
     }
                                          onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

-(void)updatePhoneNumber
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:_mobileNumber forKey:@"phone_number"];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"user_id"];
    
    [[NetworkEngine sharedNetworkEngine]updatePhoneNumber:^(id object)
     {
         
         NSLog(@"%@",object);
         [USERDEFAULTS setObject:_mobileNumber forKey:MobileNo];
         
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             [Utility showAlertMessage:@"Eat Here" message:@"Phone number updated successfully"];
             [self dismissViewControllerAnimated:YES completion:nil];
         } else
         {
             
             [sampleProtocol startSampleProcess];
         }
         
         //[kAppDelegate hideProgressHUD];
         
         
     }
                                          onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

@end
