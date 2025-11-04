//
//  RestaurantDetailViewController.h
//  Eat Here
//
//  Created by Silstone on 09/07/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)backBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *addressView;
@property (strong,nonatomic) NSString *restaurantId;


@property (nonatomic) bool isCurrentEnable;

@property (strong, nonatomic) IBOutlet UIImageView *restaurantImage;
@property (strong, nonatomic) IBOutlet UILabel *restaurantName;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumber;
@property (strong, nonatomic) IBOutlet UILabel *addressLineFirst;
@property (strong, nonatomic) IBOutlet UILabel *addressLineSecond;

@property (strong, nonatomic) IBOutlet UIImageView *ratingStarFirst;
@property (strong, nonatomic) IBOutlet UIImageView *ratingStarSecond;
@property (strong, nonatomic) IBOutlet UIImageView *ratingStarThird;
@property (strong, nonatomic) IBOutlet UIImageView *ratingStarFourth;
@property (strong, nonatomic) IBOutlet UIImageView *ratingStarFifth;

@property (strong, nonatomic) IBOutlet UILabel *cuisineLable;
@property (strong, nonatomic) IBOutlet UILabel *averageCostLable;
@property (strong, nonatomic) IBOutlet UILabel *timeLable;
@property (strong, nonatomic) IBOutlet UILabel *showDateTimeLabel;
- (IBAction)createPostBtn:(id)sender;

@property (strong, nonatomic) NSString *newsfeedImageStr;
@property (strong, nonatomic) NSString *ratingStr;
@property (strong, nonatomic) NSString *restaurantNameStr;
- (IBAction)restaurantRoute:(id)sender;
- (IBAction)callNowAction:(id)sender;


@end
