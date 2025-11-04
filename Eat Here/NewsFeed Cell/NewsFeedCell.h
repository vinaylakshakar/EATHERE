//
//  NewsFeedCell.h
//  Eat Here
//
//  Created by Silstone on 03/07/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *reviewNumber;
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddress;
@property (weak, nonatomic) IBOutlet UILabel *restaurantRating;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UILabel *commentLable;

@property (weak, nonatomic) IBOutlet UIImageView *firstRatingImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondRatingImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdRatingImage;
@property (weak, nonatomic) IBOutlet UIImageView *fourthRatingImage;
@property (weak, nonatomic) IBOutlet UIImageView *fifthRatingImage;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *deletePostBtn;
@property (weak, nonatomic) IBOutlet UIImageView *shareBackImage;

@end
