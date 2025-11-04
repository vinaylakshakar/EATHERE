//
//  EnterMobileViewController.m
//  Eat Here
//
//  Created by Silstone on 25/06/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "EnterMobileViewController.h"
#import "EatHere.pch"
#import "Utility.h"

@interface EnterMobileViewController ()
{
    NSMutableArray *NumberArray;
    NSString *countryCode,*apiName;
    TokenProcess *sampleProtocol;
}

@end

@implementation EnterMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NumberArray =[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    NSString *countryIdentifier = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    
    countryCode =[NSString stringWithFormat:@"+%@",[[Utility getCountryCodeDictionary] objectForKey:countryIdentifier]];
//   self.countryCodeField.text = countryCode;
    
    [self updateViewsWithCountryDic:[PCCPViewController infoFromSimCardAndiOSSettings]];
//    NSMutableString * defalultInfo = [[_label text] mutableCopy];
//    [defalultInfo  appendString:@"\n\nAs Default!"];
//    [_label setText:defalultInfo];
    [self.doneMobileBtn setEnabled:NO];
    
    //SegoeUI
    //SegoeUI-Light
    for(NSString *fontfamilyname in [UIFont familyNames])
    {
        NSLog(@"family:'%@'",fontfamilyname);
        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
        {
            NSLog(@"\tfont:'%@'",fontName);
        }
        NSLog(@"-------------");
    }
    
    sampleProtocol = [[TokenProcess alloc]init];
    sampleProtocol.delegate = self;
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

- (IBAction)enterNumberAction:(id)sender
{
   
    if (NumberArray.count<10)
    {
        if ([sender tag]==11)
        {
            [NumberArray addObject:@"1"];
        }
        if ([sender tag]==12) {
            [NumberArray addObject:@"2"];
        }
        if ([sender tag]==13) {
            [NumberArray addObject:@"3"];
        }
        if ([sender tag]==14) {
            [NumberArray addObject:@"4"];
        }
        if ([sender tag]==15) {
            [NumberArray addObject:@"5"];
        }
        if ([sender tag]==16) {
            [NumberArray addObject:@"6"];
        }
        if ([sender tag]==17) {
            [NumberArray addObject:@"7"];;
        }
        if ([sender tag]==18) {
            [NumberArray addObject:@"8"];
        }
        if ([sender tag]==19) {
            [NumberArray addObject:@"9"];
        }
        if ([sender tag]==10) {
            [NumberArray addObject:@"0"];
        }
        
      self.mobileField.text = [NumberArray componentsJoinedByString:@""];
    }
    
    if (NumberArray.count==10)
    {
         [self.doneMobileBtn setEnabled:YES];
    }
   
    
}

#pragma mark - Sample protocol delegate
-(void)processCompleted {
    NSLog(@"Process complete");
    if ([apiName isEqualToString:@"Login"]) {
        [self LoginUser];
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


-(void)LoginUser
{
    NSString *mobileNumber = [NSString stringWithFormat:@"%@%@",countryCode,self.mobileField.text];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:mobileNumber forKey:@"mobile_number"];
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
         
        
         [USERDEFAULTS setObject:mobileNumber forKey:MobileNo];
        
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             int otp = [[object valueForKey:@"id"] intValue];
              if (otp==0)
              {
                  if(self.fromUpdateScreen)
                  {
                      
                      [self dismissViewControllerAnimated:YES completion:^{
                          AppDelegate *ad = (AppDelegate *)[UIApplication sharedApplication].delegate;
                          EnterOTPViewController *enterOTP =[self.storyboard instantiateViewControllerWithIdentifier:@"EnterOTPViewController"];
                          enterOTP.mobileNumber = mobileNumber;
                          enterOTP.fromUpdateScreen = true;
                          enterOTP.otpNumber = [[object valueForKey:@"OTP"] stringValue];
                          [ad.window.rootViewController presentViewController:enterOTP animated:YES completion:nil];
                      }];
                      
                  }
                  else{
                      [USERDEFAULTS setObject:[object valueForKey:@"id"] forKey:kuserID];
                      EnterOTPViewController *enterOTP =[self.storyboard instantiateViewControllerWithIdentifier:@"EnterOTPViewController"];
                      enterOTP.mobileNumber = mobileNumber;
                      enterOTP.fromUpdateScreen = false;
                      enterOTP.otpNumber = [[object valueForKey:@"OTP"] stringValue];
                          [self.navigationController pushViewController:enterOTP animated:YES];
                  }
                  
              }
              else{
                   if(self.fromUpdateScreen)
                   {
                       [Utility showAlertMessage:@"Eat Here" message:@"Phone Number you entered is already exist.Please try another number"];
                   }
                   else{
                       [USERDEFAULTS setObject:[object valueForKey:@"id"] forKey:kuserID];
                       EnterOTPViewController *enterOTP =[self.storyboard instantiateViewControllerWithIdentifier:@"EnterOTPViewController"];
                       enterOTP.mobileNumber = mobileNumber;
                       enterOTP.fromUpdateScreen = false;
                       enterOTP.otpNumber = [[object valueForKey:@"OTP"] stringValue];
                           [self.navigationController pushViewController:enterOTP animated:YES];
                   }
                  
              }
             
             
             
             
         } else
         {
             apiName =@"Login";
             [sampleProtocol startSampleProcess];
         }
         
         //[kAppDelegate hideProgressHUD];
         
         
     }
                                          onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}


- (IBAction)pushToOtpScreen:(id)sender
{
//        EnterOTPViewController *enterOTP =[self.storyboard instantiateViewControllerWithIdentifier:@"EnterOTPViewController"];
//        [self.navigationController pushViewController:enterOTP animated:YES];
    [self LoginUser];
}
- (IBAction)deleteNumberAction:(id)sender
{
    [self.doneMobileBtn setEnabled:NO];
    [NumberArray removeLastObject];
    self.mobileField.text = [NumberArray componentsJoinedByString:@""];
}
- (IBAction)countryCodeAction:(id)sender
{
    PCCPViewController * vc = [[PCCPViewController alloc] initWithCompletion:^(id countryDic) {
        [self updateViewsWithCountryDic:countryDic];
    }];
    //[vc setIsUsingChinese:[_langSwitch selectedSegmentIndex] == 1];
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:naviVC animated:YES completion:NULL];
}

- (void)updateViewsWithCountryDic:(NSDictionary*)countryDic{
//    [_label setText:[NSString stringWithFormat:@"country_code: %@\ncountry_en: %@\ncountry_cn: %@\nphone_code: %@",countryDic[@"country_code"],countryDic[@"country_en"],countryDic[@"country_cn"],countryDic[@"phone_code"]]];
    [self.countryImage setImage:[PCCPViewController imageForCountryCode:countryDic[@"country_code"]]];
    countryCode =[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"+%@",countryDic[@"phone_code"]]];
    NSLog(@"%@",[NSString stringWithFormat:@"+%@",countryDic[@"phone_code"]]);
}

@end
