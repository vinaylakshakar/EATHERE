//
//  SelectCategoryCell.h
//  Eat Here
//
//  Created by Silstone on 02/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCategoryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *categoryImage;
@property (strong, nonatomic) IBOutlet UILabel *categoryName;
@property (strong, nonatomic) IBOutlet UIButton *categoryBtn;

@end
