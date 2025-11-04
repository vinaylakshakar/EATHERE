//
//  TokenProcess.m
//  Eat Here
//
//  Created by Silstone on 18/07/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "TokenProcess.h"
#import "EatHere.pch"

@implementation TokenProcess

-(void)startSampleProcess {

        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:kMerchantID forKey:@"MerchantId"];
        
        NSLog(@"%@",dict);
    
        
        [[NetworkEngine sharedNetworkEngine]GetTokenAccess:^(id object)
         {
             
             NSLog(@"%@",object);
             
             
             if ([[object valueForKey:@"status"] isEqualToString:@"success"])
             {
                 //[kAppDelegate hideProgressHUD];
                 
                 NSString *token = [object valueForKey:@"TokenAccess"];
                 [USERDEFAULTS setObject:token forKey:kAccessToken];
                 NSLog(@"new token %@",token);
                 
                 [NSTimer scheduledTimerWithTimeInterval:1.0 target:self.delegate
                                                selector:@selector(processCompleted) userInfo:nil repeats:NO];
             }
             
             //[kAppDelegate hideProgressHUD];
             
             
         }
                                              onError:^(NSError *error)
         {
             NSLog(@"Error : %@",error);
         }params:dict];
    
}

@end
