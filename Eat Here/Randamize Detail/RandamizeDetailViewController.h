//
//  RandamizeDetailViewController.h
//  Eat Here
//
//  Created by Silstone on 01/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RandamizeDetailViewController : UIViewController
{
    NSMutableArray *restaurantArray;
    IBOutlet UIImageView *categoryImage;
    IBOutlet UIImageView *mainImage;
    IBOutlet UILabel *restaurantName;
    IBOutlet UILabel *restaurantAddress;
    IBOutlet UILabel *restaurantOpen;
    IBOutlet UIImageView *smallImageView;
    
    
}

@property (strong, nonatomic) IBOutlet UIImageView *firstRatingImage;
@property (strong, nonatomic) IBOutlet UIImageView *secondRatingImage;
@property (strong, nonatomic) IBOutlet UIImageView *thirdRatingImage;
@property (strong, nonatomic) IBOutlet UIImageView *fourthRatingImage;
@property (strong, nonatomic) IBOutlet UIImageView *fifthRatingImage;


@property (strong, nonatomic) IBOutlet UIButton *viewMoreBtn;
@property (nonatomic) bool fromRandomPage;
@property(nonatomic,strong)NSString *CategoryName;
- (IBAction)viewMoreAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *moreOptionsView;
@property (strong, nonatomic) IBOutlet UITableView *viewMoreTable;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)spinAgainAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *spinAgainBtn;
- (IBAction)viewRestaurantDetail:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *restaurantDetailBtn;
@property (strong, nonatomic) IBOutlet UIView *mainView;

@end
