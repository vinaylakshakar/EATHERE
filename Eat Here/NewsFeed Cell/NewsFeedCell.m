//
//  NewsFeedCell.m
//  Eat Here
//
//  Created by Silstone on 03/07/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "NewsFeedCell.h"

@implementation NewsFeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - custom rating method

//-(void)addRating:(int)rating
//{
//    if (rating>=1) {
//        self.firstRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
//        
//    }
//    if (rating>=2) {
//        self.secondRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
//        
//    }
//    if (rating>=3) {
//        self.thirdRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
//        
//    }
//    if (rating>=4) {
//        self.fourthRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
//        
//    }
//    if (rating>=5) {
//        self.fifthRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
//    }
//}

@end
