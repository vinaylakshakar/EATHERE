//
//  AdvancedSearchViewController.h
//  Eat Here
//
//  Created by Silstone on 10/07/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>

@interface AdvancedSearchViewController : UIViewController<TTGTextTagCollectionViewDelegate>
{
    IBOutlet UIButton *testytheWorld;
    IBOutlet UIButton *Healthychoice;
}

@property (strong, nonatomic) IBOutlet UIImageView *firstFilterImage;
@property (strong, nonatomic) IBOutlet UIImageView *secondFilterImage;
@property (strong, nonatomic) IBOutlet UIImageView *thirdFilterImage;
@property (strong, nonatomic) IBOutlet UIImageView *fourthFilterImage;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
- (IBAction)backBtnAction:(id)sender;
- (IBAction)restaurantDistance:(id)sender;
- (IBAction)restaurantType:(id)sender;
- (IBAction)advanceSearch:(id)sender;

@property (strong, nonatomic) IBOutlet TTGTextTagCollectionView *tagView;
@property (strong, nonatomic) IBOutlet UIView *tagContent;
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@property (strong, nonatomic) IBOutlet UILabel *subcategoryLable;
@property (strong, nonatomic) NSMutableDictionary *selectedDic;
@end
