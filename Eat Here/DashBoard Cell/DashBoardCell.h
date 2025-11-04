//
//  DashBoardCell.h
//  Eat Here
//
//  Created by Silstone on 03/07/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashBoardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddress;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIImageView *firstRatingImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondRatingImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdRatingImage;
@property (weak, nonatomic) IBOutlet UIImageView *fourthRatingImage;
@property (weak, nonatomic) IBOutlet UIImageView *fifthRatingImage;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImage;
@property (weak, nonatomic) IBOutlet UIImageView *whiteImage;

@end
