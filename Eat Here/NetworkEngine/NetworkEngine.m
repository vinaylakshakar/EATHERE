  //
//  NetworkEngine.m
//  Keep
//
//  Created by Eweb-A1-iOS on 30/09/15.
//  Copyright © 2015 Mnjt-PC. All rights reserved.
//

#import "NetworkEngine.h"
//#import "Utility.h"
//#import <Stripe/Stripe.h>
#import "AppDelegate.h"
#import "EatHere.pch"
//#import "Constants.h"

static NetworkEngine *sharedNetworkEngine = nil;
@implementation NetworkEngine
@synthesize httpManager;

+(id)sharedNetworkEngine{
 if(sharedNetworkEngine == nil)
 {
  sharedNetworkEngine = [[NetworkEngine alloc]init];
 }
 return sharedNetworkEngine;
}

-(id)init {
 self = [super init];
 if(self) {
  self.httpManager = [AFHTTPRequestOperationManager manager];
  
  self.httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/javascript",@"text/plain", nil];
  
  [self.httpManager.requestSerializer setAuthorizationHeaderFieldWithUsername:nil password:nil];

 }
 return self;
}

-(void)loginUser:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
     [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager GET:kBaseURL@"login/Get?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"Message"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)updatePhoneNumber:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    //[USERDEFAULTS valueForKey:kAccessToken]
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager POST:kBaseURL@"UpdatePhoneNo" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"Message"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            [kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)DashboardListing:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
   // [kAppDelegate showProgressHUD];
    
//    [self.httpManager.requestSerializer setValue:@"Bearer J1nM9P4CYI6DZyeuTe_YKTigJBf0kA8gBRTkrl9rXXGwGZcCRKq6s8tN0HcuZTs2A49Gx57PdlMobCuFk0VjhtobFtTa-YNUhlfoo7Q_xmwHTkfT78xJ2L23DfU5W3Yx" forHTTPHeaderField:@"Authorization"];
//
//    [self.httpManager GET:@"https://api.yelp.com/v3/businesses/search?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    //vinay here-
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:params];
    [mutableDict setObject:@"0" forKey:@"userid"];

     [self.httpManager.requestSerializer setValue:@"Bearer J1nM9P4CYI6DZyeuTe_YKTigJBf0kA8gBRTkrl9rXXGwGZcCRKq6s8tN0HcuZTs2A49Gx57PdlMobCuFk0VjhtobFtTa-YNUhlfoo7Q_xmwHTkfT78xJ2L23DfU5W3Yx" forHTTPHeaderField:@"Authorization"];
     [self.httpManager GET:kBaseURL@"BusinessSearchNew?" parameters:mutableDict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
      
         [kAppDelegate hideProgressHUD];
        if([responseObject valueForKey:@"Message"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)DashboardListingForFinder:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    // [kAppDelegate showProgressHUD];
    
        [self.httpManager.requestSerializer setValue:@"Bearer J1nM9P4CYI6DZyeuTe_YKTigJBf0kA8gBRTkrl9rXXGwGZcCRKq6s8tN0HcuZTs2A49Gx57PdlMobCuFk0VjhtobFtTa-YNUhlfoo7Q_xmwHTkfT78xJ2L23DfU5W3Yx" forHTTPHeaderField:@"Authorization"];
    
        [self.httpManager GET:@"https://api.yelp.com/v3/businesses/search?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    //vinay here-
//    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:params];
//    [mutableDict setObject:@"0" forKey:@"userid"];
//
//    [self.httpManager.requestSerializer setValue:@"Bearer J1nM9P4CYI6DZyeuTe_YKTigJBf0kA8gBRTkrl9rXXGwGZcCRKq6s8tN0HcuZTs2A49Gx57PdlMobCuFk0VjhtobFtTa-YNUhlfoo7Q_xmwHTkfT78xJ2L23DfU5W3Yx" forHTTPHeaderField:@"Authorization"];
//    [self.httpManager GET:kBaseURL@"BusinessSearch?" parameters:mutableDict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         [kAppDelegate hideProgressHUD];
         if([responseObject valueForKey:@"Message"])
         {
             
             completionBlock(responseObject);
         }
         else
         {
             completionBlock(responseObject);
             //[kAppDelegate hideProgressHUD];
             //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)autoCompleteSearch:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    // [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:@"Bearer J1nM9P4CYI6DZyeuTe_YKTigJBf0kA8gBRTkrl9rXXGwGZcCRKq6s8tN0HcuZTs2A49Gx57PdlMobCuFk0VjhtobFtTa-YNUhlfoo7Q_xmwHTkfT78xJ2L23DfU5W3Yx" forHTTPHeaderField:@"Authorization"];
    
    [self.httpManager GET:@"https://api.yelp.com/v3/autocomplete?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"Message"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)GetRestaurantDetail:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager.requestSerializer setValue:@"Bearer J1nM9P4CYI6DZyeuTe_YKTigJBf0kA8gBRTkrl9rXXGwGZcCRKq6s8tN0HcuZTs2A49Gx57PdlMobCuFk0VjhtobFtTa-YNUhlfoo7Q_xmwHTkfT78xJ2L23DfU5W3Yx" forHTTPHeaderField:@"Authorization"];
    
    NSString *url  =[NSString stringWithFormat:@"https://api.yelp.com/v3/businesses/%@",[params valueForKey:@"id"]];
    
    [self.httpManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"Message"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}


-(void)RegisterUser:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    //[USERDEFAULTS valueForKey:kAccessToken]
    NSLog(@"%@",[USERDEFAULTS valueForKey:kAccessToken]);
    [self.httpManager.requestSerializer setValue:@"" forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager POST:kBaseURL@"Registration?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)GetTokenAccess:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
   // [kAppDelegate showProgressHUD];
    
    //    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:Token] forHTTPHeaderField:@"Token"];
    
    [self.httpManager GET:kBaseURL@"Token" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)Newsfeedlist:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    //[kAppDelegate showProgressHUD];
    
    NSLog(@"%@",[USERDEFAULTS valueForKey:kAccessToken]);
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];

    [self.httpManager GET:kBaseURL@"Newsfeedlist?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 //[kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //[kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)CreatePost:(completion_block)completionBlock onError:(error_block)errorBlock filePath:(NSString *)filePath imageName:(UIImage *)imageName params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    NSLog(@"params %@",params);
    NSData *data = UIImageJPEGRepresentation(imageName, 0.5);
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    [self.httpManager POST:kBaseURL@"CreatePost" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         [formData appendPartWithFileData:data name:@"RestaurantImage" fileName:filePath mimeType:@"image/jpeg"];
     }
                   success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         completionBlock(responseObject);
     }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
     }];
}


-(void)Deletenewsfeed:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    NSLog(@"%@",[USERDEFAULTS valueForKey:kAccessToken]);
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    [self.httpManager GET:kBaseURL@"Deletenewsfeed?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)

     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)UserDetail:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    NSLog(@"%@",[USERDEFAULTS valueForKey:kAccessToken]);
    
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    [self.httpManager GET:kBaseURL@"UserDetail?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}


-(void)UpdateUserProfile:(completion_block)completionBlock onError:(error_block)errorBlock filePath:(NSString *)filePath imageName:(UIImage *)imageName params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    NSLog(@"params %@",params);
    NSData *data = UIImageJPEGRepresentation(imageName, 0.5);
    //self.httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [self.httpManager.requestSerializer setValue:[USERDEFAULTS valueForKey:kAccessToken] forHTTPHeaderField:@"TokenAccess"];
    [self.httpManager POST:kBaseURL@"UpdateUserProfile" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         [formData appendPartWithFileData:data name:@"filename" fileName:filePath mimeType:@"image/jpeg"];
     }
                   success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         completionBlock(responseObject);
     }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
     }];
}
-(void)SendFeedback:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    //[USERDEFAULTS valueForKey:kAccessToken]
    NSLog(@"%@",[USERDEFAULTS valueForKey:kAccessToken]);
    [self.httpManager.requestSerializer setValue:@"" forHTTPHeaderField:@"TokenAccess"];
    
    [self.httpManager POST:kBaseURL@"SendFeedback?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"status"])
         {
             if([[responseObject valueForKey:@"status"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

//-------------------------------
//- (void)createCustomerKeyWithAPIVersion:(NSString *)apiVersion completion:(STPJSONResponseCompletionBlock)completion {
//    NSURL *url = [self.baseURL URLByAppendingPathComponent:@"ephemeral_keys"];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager POST:@"" parameters:@{@"api_version": apiVersion} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//         completion(responseObject, nil);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         completion(nil, error);
//    }];
//}

@end
