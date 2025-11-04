//
//  EditProfileViewController.m
//  Eat Here
//
//  Created by Silstone on 12/10/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "EditProfileViewController.h"
#import "EatHere.pch"
#import "EnterMobileViewController.h"
//EnterMobileViewController

@interface EditProfileViewController ()
{
    TokenProcess *sampleProtocol;
    NSString *apiName;
}

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.saveChangeBtn.layer.cornerRadius = 20;
     updatePhoneBtn.layer.cornerRadius = 20;
//    [self setRoundedView:self.profileImage toDiameter:190];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
    _profileImage.clipsToBounds = YES;
    sampleProtocol = [[TokenProcess alloc]init];
    sampleProtocol.delegate = self;
    
    [self.profileImage sd_setImageWithURL:[NSURL URLWithString:[self.userDetail valueForKey:@"ImageUrl"]] placeholderImage:[UIImage imageNamed:@"user_placeholder"] options:0 progress:nil completed:nil];
    
    self.username.text = [self.userDetail valueForKey:@"username"];
    self.email.text = [self.userDetail valueForKey:@"email"];
    self.zipCodeField.text =  [USERDEFAULTS objectForKey:ZipCode];
    //[self UserDetail];
    [self checkZipCodeStatus];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}
-(void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

#pragma mark - Sample protocol delegate
-(void)processCompleted
{
    NSLog(@"Process complete");
    if([apiName isEqualToString:@"updateUserDetail"])
    {
        [self updateUserDetail];
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

//-(void)UserDetail
//{
//    
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"Userid"];
//    
//    
//    NSLog(@"%@",dict);
//    
//    [[NetworkEngine sharedNetworkEngine]UserDetail:^(id object)
//     {
//         
//         NSLog(@"%@",object);
//         
//         
//         
//         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
//         {
//             //[kAppDelegate hideProgressHUD];
//             NSMutableDictionary * userdetailDict = [[object valueForKey:@"UserDetail"] mutableCopy];
////             [self.profileImage sd_setImageWithURL:[NSURL URLWithString:[userdetailDict valueForKey:@"ImageUrl"]] placeholderImage:[UIImage imageNamed:@"user_placeholder"] options:0 progress:nil completed:nil];
////
////             self.username.text = [userdetailDict valueForKey:@"name"];
////             self.email.text = [userdetailDict valueForKey:@"email"];
//             
//             
//         } else if ([[object valueForKey:@"Message"] isEqualToString:@"Authorization failed."])
//         {
//             apiName =@"UserDetail";
//             [sampleProtocol startSampleProcess];
//         }
//         
//         else
//         {
//             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!"
//                                                                           message:[object valueForKey:@"Message"]
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//             
//             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
//                                                                 style:UIAlertActionStyleDefault
//                                                               handler:^(UIAlertAction * action)
//                                         {
//                                             
//                                         }];
//             
//             [alert addAction:yesButton];
//             
//             [self presentViewController:alert animated:YES completion:nil];
//         }
//         
//         [kAppDelegate hideProgressHUD];
//         
//         
//     }
//                                           onError:^(NSError *error)
//     {
//         NSLog(@"Error : %@",error);
//     }params:dict];
//}

-(void)updateUserDetail
{
//
//    if(isChooseImage)
//    {
    
        [kAppDelegate showProgressHUD];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"id"];
        [dict setObject:self.email.text forKey:@"email"];
        [dict setObject:self.username.text forKey:@"username"];
        [dict setObject:@"" forKey:@"name"];
        
        NSString *filename = [NSString stringWithFormat:@"%ld%c%c.jpg", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
        
        NSLog(@"%@",dict);
        
        [[NetworkEngine sharedNetworkEngine]UpdateUserProfile:^(id object)
         {
             NSLog(@"errekkjk %@",object);
             
             
             if ([[object valueForKey:@"status"] isEqualToString:@"success"])
             {
                 
                 UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                                message:@"Updated Successfully."
                                                                         preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     [self.navigationController popViewControllerAnimated:YES];
                 }];
                 [alert addAction:cancel];
                 [self presentViewController:alert animated:YES completion:nil];
                 
             } else if([[object valueForKey:@"Message"] isEqualToString:@"Authorization failed."])
             {
                 apiName =@"updateUserDetail";
                 [sampleProtocol startSampleProcess];
             }else
             {
                 UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                                message:[object valueForKey:@"Message"]
                                                                         preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                 [alert addAction:cancel];
                 [self presentViewController:alert animated:YES completion:nil];
                 
             }
             
             
             [kAppDelegate hideProgressHUD];
             
             
         } onError:^(NSError *error)
         {
             NSLog(@"%@",error);
         } filePath:filename imageName:_profileImage.image params:dict];
        
        
//    }else
//    {
//
//        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Eat here!"
//                                                                       message:@"Please Select Image."
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
//        [alert addAction:cancel];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
}

- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)updateProfile:(id)sender
{
    UIActionSheet *actionSheet_popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open Gallery", @"Camera", nil];
    actionSheet_popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet_popupQuery showInView:self.view];
    actionSheet_popupQuery.tag=2;
}

#pragma mark - ACTION SHEET DELEGATE

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self click_gallery];
        
    }
    else if(buttonIndex == 1)
    {
        [self click_camera];
        
    }
}


-(void)click_camera
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        UIColor* color = [UIColor colorWithRed:46.0/255 green:127.0/255 blue:244.0/255 alpha:1];
        [imgPicker.navigationBar setTintColor:color];
        imgPicker.delegate = self;
        imgPicker.allowsEditing = YES;
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imgPicker animated:NO completion:Nil];
    }
    else
    {
        UIAlertView *alert1=[[UIAlertView alloc]initWithTitle:@"Alert! " message:@"Device does not support camera" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert1 show];
    }
}
-(void)click_gallery
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imgPicker= [[UIImagePickerController alloc] init];
        UIColor* color = [UIColor colorWithRed:46.0/255 green:127.0/255 blue:244.0/255 alpha:1];
        [imgPicker.navigationBar setTintColor:color];
        imgPicker.delegate = self;
        imgPicker.allowsEditing = YES;
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imgPicker animated:NO completion:Nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    imageOriginal =  [info objectForKey:UIImagePickerControllerEditedImage];
    
    imgData=UIImageJPEGRepresentation(imageOriginal,0.5);
    
    if (click_reg==YES)
    {
        click_reg=NO;
        
        if (picker.sourceType==UIImagePickerControllerSourceTypeCamera)
        {
            _profileImage.image=imageOriginal;
        }
        else
        {
            _profileImage.image=imageOriginal;
            
        }
    }
    else
    {
        if (picker.sourceType==UIImagePickerControllerSourceTypeCamera)
        {
            _profileImage.image=imageOriginal;
        }
        else
        {
            _profileImage.image=imageOriginal;
            
        }
    }
    isChooseImage=YES;
    [picker dismissViewControllerAnimated:YES completion:Nil];
    //[self updateUserDetail];
    
}

- (IBAction)saveChangesAction:(id)sender
{
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusDenied:
                NSLog(@"HH: kCLAuthorizationStatusDenied");
                 [self updateZipCode];
                
                break;
            case kCLAuthorizationStatusRestricted:
                NSLog(@"HH: kCLAuthorizationStatusRestricted");
                 [self updateZipCode];
               
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
                NSLog(@"HH: kCLAuthorizationStatusAuthorizedAlways");
                [self updateUserDetail];
               
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                NSLog(@"HH: kCLAuthorizationStatusAuthorizedWhenInUse");
                 [self updateUserDetail];
                
                break;
            case kCLAuthorizationStatusNotDetermined:
                NSLog(@"HH: kCLAuthorizationStatusNotDetermined");
                   [self updateZipCode];
               
                break;
            default:
                break;
        }
    }
    else{
         [self updateZipCode];
    }
   
}

-(void)updateZipCode
{
    
    if ([self.zipCodeField.text isEqualToString:@""])
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Eat here!"
                                                                      message:@"Plase Enter your zip code."
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        
                                    }];
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self getuserLocation];
    }
}

-(void)getuserLocation
{
    NSString *trimmed = [self.zipCodeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    trimmed = [trimmed stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&key=AIzaSyABrCIdzKuY_EELaxv4OYoxnJ0SGYuf1Ks",trimmed]]];
    
    [request setHTTPMethod:@"POST"];
    NSError *err;
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    
    if([[dict valueForKey:@"status"] isEqualToString:@"ZERO_RESULTS"])
    {
        [Utility showAlertMessage:@"Eat Here" message:@"Zip Code not valid please check and try again."];
    }
    else{
    NSString *lataddr=[[[[[dict objectForKey:@"results"] objectAtIndex:0]objectForKey:@"geometry"]objectForKey:@"location"]objectForKey:@"lat"];
    
    NSString *longaddr=[[[[[dict objectForKey:@"results"] objectAtIndex:0]objectForKey:@"geometry"]objectForKey:@"location"]objectForKey:@"lng"];
    
    [USERDEFAULTS setObject:[NSString stringWithFormat:@"%@",lataddr] forKey:AddressLatitude];
    [USERDEFAULTS setObject:[NSString stringWithFormat:@"%@",longaddr] forKey:AddressLongitude];
    [USERDEFAULTS setObject:self.zipCodeField.text forKey:ZipCode];
        
     [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateWithZipCode" object:self userInfo:nil];
         [self updateUserDetail];
    }
    
}

- (IBAction)updatePhoneAction:(id)sender
{
    EnterMobileViewController *enterMobile =[self.storyboard instantiateViewControllerWithIdentifier:@"EnterMobileViewController"];
       enterMobile.fromUpdateScreen = true;
    [self presentViewController:enterMobile animated:YES
                     completion:nil];
    
    
}

-(void)checkZipCodeStatus
{
        if ([CLLocationManager locationServicesEnabled]) {
            
            switch ([CLLocationManager authorizationStatus]) {
                case kCLAuthorizationStatusDenied:
                    NSLog(@"HH: kCLAuthorizationStatusDenied");
                     [self.zipCodeField setEnabled:true];
                    self.zipCodeField.alpha = 1.0;
                    
                    break;
                case kCLAuthorizationStatusRestricted:
                    NSLog(@"HH: kCLAuthorizationStatusRestricted");
                    [self.zipCodeField setEnabled:true];
                     self.zipCodeField.alpha = 1.0;
                    
                    break;
                case kCLAuthorizationStatusAuthorizedAlways:
                    NSLog(@"HH: kCLAuthorizationStatusAuthorizedAlways");
                    [self.zipCodeField setEnabled:false];
                     self.zipCodeField.alpha = 0.5;
                    
                    break;
                case kCLAuthorizationStatusAuthorizedWhenInUse:
                    NSLog(@"HH: kCLAuthorizationStatusAuthorizedWhenInUse");
                   [self.zipCodeField setEnabled:false];
                    self.zipCodeField.alpha = 0.5;
                    
                    break;
                case kCLAuthorizationStatusNotDetermined:
                    NSLog(@"HH: kCLAuthorizationStatusNotDetermined");
                   [self.zipCodeField setEnabled:true];
                    self.zipCodeField.alpha = 1.0;
                    
                    break;
                default:
                    break;
            }
        }
        else{
            [self.zipCodeField setEnabled:true];
            self.zipCodeField.alpha = 1.0;
        }
}

@end
