//
//  RandamizerViewController.h
//  Eat Here
//
//  Created by Silstone on 01/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RandamizerViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *valueLabel;
@property (nonatomic, weak) IBOutlet UIView *wheelContainer;
@property (strong, nonatomic) IBOutlet UIButton *randamizerBtn;
@property (strong, nonatomic) IBOutlet UIButton *foodFinderBtn;
- (IBAction)foodFinderAction:(id)sender;
- (IBAction)randamizerAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) IBOutlet UITableView *categoryTable;
@property (strong, nonatomic) IBOutlet UIView *footerView;
- (IBAction)findRestaurant:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *findRestaurantBtn;

@end
