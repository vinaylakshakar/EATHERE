//
//  SettingsViewController.m
//  Eat Here
//
//  Created by Silstone on 27/06/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "SettingsViewController.h"
#import "EatHere.pch"

@interface SettingsViewController ()
{
    TokenProcess *sampleProtocol;
    NSString *apiName;
    NSMutableDictionary * userdetailDict;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self.scrollview setContentSize:CGSizeMake(self.view.frame.size.width, self.settingsView.frame.size.height)];
     self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
    self.profileImage.clipsToBounds = YES;
    self.followView.layer.cornerRadius =8;
    sampleProtocol = [[TokenProcess alloc]init];
    sampleProtocol.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@", [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:kuserID]]);
    if (![USERDEFAULTS valueForKey:kuserID])
    {
        [self.logoutBtn setHidden:YES];
        [self.signInView setHidden:NO];
    }
    else
    {
        [self UserDetail];
    }
 
}

#pragma mark - Sample protocol delegate
-(void)processCompleted
{
    NSLog(@"Process complete");
    if ([apiName isEqualToString:@"UserDetail"]) {
        [self UserDetail];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -Api methods

-(void)UserDetail
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"Userid"];
    
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]UserDetail:^(id object)
     {
         
         NSLog(@"%@",object);
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             //[kAppDelegate hideProgressHUD];
             userdetailDict = [[object valueForKey:@"UserDetail"] mutableCopy];
             [self.profileImage sd_setImageWithURL:[NSURL URLWithString:[userdetailDict valueForKey:@"ImageUrl"]] placeholderImage:[UIImage imageNamed:@"profile_placeholder"] options:0 progress:nil completed:nil];
             
             self.username.text = [userdetailDict valueForKey:@"username"];
             self.email.text = [userdetailDict valueForKey:@"email"];
             [self.logoutBtn setHidden:NO];
             [self.signInView setHidden:YES];
             
             
         } else if ([[object valueForKey:@"Message"] isEqualToString:@"Authorization failed."])
         {
             apiName =@"UserDetail";
             [sampleProtocol startSampleProcess];
         }
         
         else
         {
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!"
                                                                           message:[object valueForKey:@"Message"]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action)
                                         {
                                             
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




- (IBAction)updateProfileImage:(id)sender
{
 
    EditProfileViewController *editProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
    editProfile.userDetail = userdetailDict;
    [self.navigationController pushViewController:editProfile animated:YES];

}



- (IBAction)rateBtnAction:(id)sender {
    NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa";
    str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str];
    str = [NSString stringWithFormat:@"%@type=Purple+Software&id=", str];
    
    // Here is the app id from itunesconnect
    str = [NSString stringWithFormat:@"%@1278265344", str];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (IBAction)shareBtnAction:(id)sender
{
    NSString *url=@"http://itunes.apple.com/us/app/APPNAME/idXXXXXXXXX";
    NSString * title =[NSString stringWithFormat:@"join us on Eat Here %@",url];
    NSArray* dataToShare = @[title];
    UIActivityViewController* activityViewController =[[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop];
    [self presentViewController:activityViewController animated:YES completion:^{}];
    
}

- (IBAction)followUsAction:(id)sender {
    
    [self.visualEffectView setHidden:NO];
    [self.followView setHidden:NO];
}

- (IBAction)signInAction:(id)sender
{

    [self SigninUser];
    
}
-(void)SigninUser
{
    [Utility PushtoLoginPage:self.navigationController];
    
}
- (IBAction)signoutAction:(id)sender
{
     [self showAlert:@"Are you sure you want to logout!"];
}
- (IBAction)feedbackBtnAction:(id)sender
{
//    if (![USERDEFAULTS valueForKey:kuserID])
//    {
//        [self showAlert:@"You are not register user. Please login!"];
//    }
//    else
//    {
        FeedBackViewController *feedback = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedBackViewController"];
        [self.navigationController pushViewController:feedback animated:YES];
//    }
}

-(void)showAlert:(NSString*)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Eat Here!" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                             //BUTTON OK CLICK EVENT
                             if ([message isEqualToString:@"Are you sure you want to logout!"])
                             {
                                 [self.logoutBtn setHidden:YES];
                                 [self.signInView setHidden:NO];
                                 [USERDEFAULTS removeObjectForKey:kuserID];
                                 //[self removeUserDefaults];
                             }else
                             {
                                 [self SigninUser];
                             }
                             
                             
                         }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:ok];
    [alert.view setTintColor:[UIColor redColor]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)hiedeEffectView:(id)sender
{
    [self.visualEffectView setHidden:YES];
    [self.followView setHidden:YES];
}

- (IBAction)followInstagram:(id)sender
{
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"https://www.instagram.com/eathere416/"];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
}

- (IBAction)followFacebook:(id)sender
{
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.daledietrich.com"]];
    
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"https://www.facebook.com/Eat-Here-973523666153114/"];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
}

- (void)removeUserDefaults
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [userDefaults dictionaryRepresentation];
    for (id key in dict) {
        [userDefaults removeObjectForKey:key];
    }
    [userDefaults synchronize];
}
@end
