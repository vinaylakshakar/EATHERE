//
//  FoodFinderViewController.h
//  Eat Here
//
//  Created by Silstone on 03/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodFinderViewController : UIViewController
{
    NSMutableArray *restaurantArray;
    int offsetLimit;
    UIActivityIndicatorView *spinner;
}
@property (strong, nonatomic) NSMutableArray *selectedArray;
@property (strong, nonatomic) NSMutableArray *selectedCategory;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)backBtnAction:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *foodFinderTable;
@property (strong, nonatomic) IBOutlet UILabel *restaurantName;
@property (strong, nonatomic) IBOutlet UILabel *restaurantAddress;
@property (strong, nonatomic) IBOutlet UILabel *timeLable;
@property (strong, nonatomic) IBOutlet UIImageView *firstRatingImage;
@property (strong, nonatomic) IBOutlet UIImageView *secondRatingImage;
@property (strong, nonatomic) IBOutlet UIImageView *thirdRatingImage;
@property (strong, nonatomic) IBOutlet UIImageView *fourthRatingImage;
@property (strong, nonatomic) IBOutlet UIImageView *fifthRatingImage;
@end
