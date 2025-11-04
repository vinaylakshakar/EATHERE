//
//  NetworkEngine.h
//  Keep
//
//  Created by Vibha on 30/09/15.
//  Copyright © 2015 Vibha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


typedef void(^completion_block)(id object);
typedef void(^error_block)(NSError *error);
typedef void (^upload_completeBlock)(NSString *url);
@interface NetworkEngine : NSObject

@property(nonatomic,strong)AFHTTPRequestOperationManager *httpManager;
+ (id)sharedNetworkEngine;

// For login purposes
-(void)GetTokenAccess:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)loginUser:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary*)params;
-(void)updatePhoneNumber:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)DashboardListing:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)RegisterUser:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)GetRestaurantDetail:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)Newsfeedlist:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)CreatePost:(completion_block)completionBlock onError:(error_block)errorBlock filePath:(NSString *)filePath imageName:(UIImage *)imageName params:(NSDictionary *)params;
-(void)Deletenewsfeed:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)UserDetail:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)UpdateUserProfile:(completion_block)completionBlock onError:(error_block)errorBlock filePath:(NSString *)filePath imageName:(UIImage *)imageName params:(NSDictionary *)params;
-(void)autoCompleteSearch:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)SendFeedback:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)DashboardListingForFinder:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
@end



