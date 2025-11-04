//
//  RadomizeCellFirst.h
//  Eat Here
//
//  Created by Silstone on 27/12/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RadomizeCellFirst : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *restaurantName;
@property (strong, nonatomic) IBOutlet UILabel *restaurantAddress;
@property (strong, nonatomic) IBOutlet UILabel *timeLable;
@property (strong, nonatomic) IBOutlet UIImageView *firstRatingImage;
@property (strong, nonatomic) IBOutlet UIImageView *secondRatingImage;
@property (strong, nonatomic) IBOutlet UIImageView *thirdRatingImage;
@property (strong, nonatomic) IBOutlet UIImageView *fourthRatingImage;
@property (strong, nonatomic) IBOutlet UIImageView *fifthRatingImage;
@property (strong, nonatomic) IBOutlet UIImageView *restaurantImage;
@property (strong, nonatomic) IBOutlet UIImageView *whiteImage;
@property (strong, nonatomic) IBOutlet UIImageView *categoryImage;

@end

NS_ASSUME_NONNULL_END
