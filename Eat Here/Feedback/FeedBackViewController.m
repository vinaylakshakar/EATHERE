//
//  FeedBackViewController.m
//  Eat Here
//
//  Created by Silstone on 27/06/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "FeedBackViewController.h"
#import "EatHere.pch"

@interface FeedBackViewController ()
{
    NSString *apiName;
    TokenProcess *sampleProtocol;
}

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textView.layer.borderColor = [UIColor blackColor].CGColor;;
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.cornerRadius = 15;
    self.sendFeedBackBtn.layer.cornerRadius = self.sendFeedBackBtn.frame.size.height/2;
    sampleProtocol = [[TokenProcess alloc]init];
    sampleProtocol.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
#pragma mark - Sample protocol delegate
-(void)processCompleted
{
    NSLog(@"Process complete");
    if ([apiName isEqualToString:@"SendFeedback"]) {
        [self SendFeedback];
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

-(void)SendFeedback
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    if (![USERDEFAULTS valueForKey:kuserID])
    {
         [dict setObject:@"0" forKey:@"userId"];;
    }
    else{
         [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userId"];
    }
   
    [dict setObject:self.textView.text forKey:@"FeedbackMessage"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]SendFeedback:^(id object)
     {
         
         NSLog(@"%@",object);
         
         
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             //[kAppDelegate hideProgressHUD];
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!"
                                                                           message:[object valueForKey:@"Message"]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action)
                                         {
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }];
             
             [alert addAction:yesButton];
             
             [self presentViewController:alert animated:YES completion:nil];
             
             
         } else if ([[object valueForKey:@"Message"] isEqualToString:@"Authorization failed."])
         {
             apiName =@"SendFeedback";
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


- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendFeedbackAction:(id)sender
{
    if ([self.textView.text isEqualToString:@""])
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!"
                                                                      message:@"Feedback can not be blank."
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        
                                    }];
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else
    {
        [self SendFeedback];
    }
}
@end
