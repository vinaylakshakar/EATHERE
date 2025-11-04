//
//  DashBoardViewController.h
//  Eat Here
//
//  Created by Silstone on 29/06/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "EatHere.pch"
#import <lottie-ios/Lottie/LOTAnimationView.h>

@interface DashBoardViewController : UIViewController<MKMapViewDelegate,UIGestureRecognizerDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *restaurantArray,*recentSearchArray,*searchRestaurantIDArray;
    NSMutableDictionary *Dict_name,*AdvanceSearchDict;
    BOOL isDragging_msg, isDecliring_msg;
    int offsetLimit;
    UIActivityIndicatorView *spinner;
    NSString *searchTextString;
    BOOL isFilter,isAdvanceSearch,isAnnotationClicked,isSetBlueRegion,isSearchedWithfilter;
    NSArray *filterdArray;
    NSMutableArray *AroundMeArray,*BBqArray,*CAFEArray,*FASTFOODArray,*VEGANArray,*HEALTHYCHOICEArray,*BARArray,*DESSERTArray,*EATTHEWORLDArray,*TermsArray,*HeighRatedArray,*mainRestaurantArray;
    int viewTag;
    AppDelegate *myAppDelegate;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString* Clatitude;
    NSString* Clongitude;
    UITapGestureRecognizer *singleTap;
    IBOutlet UITableView *dashBoardTable;
    IBOutlet UILabel *emptyLbl;
    IBOutlet UIView *animationView;
     LOTAnimationView *hello_loader;
}

- (IBAction)flipViewAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *flipImage;
- (IBAction)advanceSearchAction:(id)sender;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *annotationDetailView;
- (IBAction)closeDetailView:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *restaurantName;
@property (strong, nonatomic) IBOutlet UILabel *restaurantAddress;
@property (strong, nonatomic) IBOutlet UILabel *timeLable;
@property (strong, nonatomic) IBOutlet UIImageView *firstRatingImage;
@property (strong, nonatomic) IBOutlet UIImageView *secondRatingImage;
@property (strong, nonatomic) IBOutlet UIImageView *thirdRatingImage;
@property (strong, nonatomic) IBOutlet UIImageView *fourthRatingImage;
@property (strong, nonatomic) IBOutlet UIImageView *fifthRatingImage;
@property (strong, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) IBOutlet UITableView *searchTable;
- (IBAction)clearRecentSearch:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *searchView;
- (IBAction)showDetailBtn:(id)sender;
@property (nonatomic, retain) CLLocationManager *locationManager;
- (IBAction)clearClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *clearBtn;
- (IBAction)updateLocation:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *currentLocationView;
@property (weak, nonatomic) IBOutlet UIButton *flipBtn;

@end
