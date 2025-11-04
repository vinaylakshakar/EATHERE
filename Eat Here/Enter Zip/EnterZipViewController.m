//
//  EnterZipViewController.m
//  Eat Here
//
//  Created by Silstone on 30/07/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "EnterZipViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "EatHere.pch"

@interface EnterZipViewController ()<CLLocationManagerDelegate>

@end

@implementation EnterZipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // [self.doneBtn setEnabled:NO];
//    self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    [self setEnabled];
    [self.zipCodeField addTarget:self
                           action:@selector(textFieldDidChange:)
                 forControlEvents:UIControlEventEditingChanged];
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

    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 8 && range.length == 0)
    {
         return NO;
    }
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    [self setEnabled];
}

-(void)setEnabled
{
    if (self.zipCodeField.text.length<3) {
        [self.doneBtn setEnabled:NO];
    } else {
        [self.doneBtn setEnabled:YES];
    }
}

//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    // add your method here
//    if (textField.text.length<6) {
//        [self.doneBtn setEnabled:NO];
//    } else {
//        [self.doneBtn setEnabled:YES];
//    }
//    
//    return YES;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneBtn:(id)sender
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
    //vinay here-
    NSString *trimmed = [self.zipCodeField.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
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
    
                RootPageViewController *PageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RootPageViewController"];
               [self.navigationController pushViewController:PageViewController animated:YES];
    }
}


- (IBAction)SkipBtnAction:(id)sender
{
    [USERDEFAULTS setObject:@"45.332825" forKey:AddressLatitude];
    [USERDEFAULTS setObject:@"-75.805790" forKey:AddressLongitude];
    [USERDEFAULTS setObject:@"" forKey:ZipCode];
    CreateAccountViewController *createAccount =[self.storyboard instantiateViewControllerWithIdentifier:@"CreateAccountViewController"];
    [self.navigationController pushViewController:createAccount animated:YES];
}
@end
