//
//  CreateAccountViewController.m
//  Eat Here
//
//  Created by Silstone on 25/06/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "EatHere.pch"

@interface CreateAccountViewController ()
{
    
    TokenProcess *sampleProtocol;
    NSString *apiName;
}

@end

@implementation CreateAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)termsConditionAction:(id)sender
{
    if (![sender isSelected]) {
        [sender setSelected:YES];
    } else {
        [sender setSelected:NO];
    }
}

- (IBAction)NewsletterBtnAction:(id)sender
{
    if (![sender isSelected]) {
        [sender setSelected:YES];
    } else {
        [sender setSelected:NO];
    }
}

#pragma mark - Sample protocol delegate
-(void)processCompleted {
    NSLog(@"Process complete");
    if ([apiName isEqualToString:@"RegisterUser"]) {
        [self RegisterUser];
    }
    
}

-(void)RegisterUser
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.nameField.text forKey:@"name"];
    [dict setObject:self.userNameField.text forKey:@"username"];
    [dict setObject:self.emailField.text forKey:@"email"];
    [dict setObject:[USERDEFAULTS valueForKey:MobileNo] forKey:@"MobileNo"];
    [dict setObject:@"ios" forKey:@"DeviceType"];
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        [dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"DeviceToken"];
        
    }
    else{
        [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"DeviceToken"];
        
    }

//name=Aji&username=887455&email=ajkd@gmail.com&MobileNo=8825478745
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]RegisterUser:^(id object)
     {
         
         NSLog(@"%@",object);

         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             [USERDEFAULTS setObject:[[object valueForKey:@"RegistrationDetail"] valueForKey:@"id"] forKey:kuserID];
             
             NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
             int count = (int)[allViewControllers count];
             UIViewController *aViewController = [allViewControllers objectAtIndex:count-4];
             [self.navigationController popToViewController:aViewController animated:NO];
             
             
             
         } else if ([[object valueForKey:@"Message"] isEqualToString:@"Authorization failed."])
         {
             
             apiName =@"RegisterUser";
             [sampleProtocol startSampleProcess];
         }else
         {
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!"
                                                                           message:[object valueForKey:@"Message"]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action)
                                         {
                                             [self.navigationController popToRootViewControllerAnimated:YES];
                                         }];
             
             [alert addAction:yesButton];
             
             [self presentViewController:alert animated:YES completion:nil];
         }
         
         [kAppDelegate hideProgressHUD];
         
         
     }
                                          onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}



- (IBAction)createAccount:(id)sender
{
    [self.view endEditing:YES];
    LoginProcess *sharedManager = [LoginProcess sharedManager];
    bool usernameValidate = [sharedManager usernameValidate:self.nameField];
    bool emailValidate = [sharedManager emailValidate:self.emailField];
    
    if ([self.nameField.text isEqualToString:@""])
    {
        
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!"
                                                                      message:@"Please Enter Your Name."
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        
                                    }];
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (!usernameValidate)
    {
        
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!"
                                                                      message:@"Please Select Valid UserName."
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        
                                    }];
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else if (!emailValidate)
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!"
                                                                      message:@"Please enter valid email."
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        
                                    }];
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else if (![self.termsConditionBtn isSelected])
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!"
                                                                      message:@"Please Select terms & condition."
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
        {

        }];

        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
//    else if (![self.newsLetterBtn isSelected])
//    {
//        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!"
//                                                                      message:@"Please Subscribe For Newsletter."
//                                                               preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
//                                                            style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action)
//                                    {
//                                        
//                                    }];
//        
//        [alert addAction:yesButton];
//        
//        [self presentViewController:alert animated:YES completion:nil];
//        
//    }
    else
    {
//        TabBarViewController *TabBarView = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
//       [self.navigationController pushViewController:TabBarView animated:YES];
        [self RegisterUser];
    }
}
- (IBAction)showTermsCondition:(id)sender
{
    UIViewController *termsCondition = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsConditionViewController"];
    [self.navigationController pushViewController:termsCondition animated:YES];
}
@end
