//
//  NewsFeedViewController.h
//  Eat Here
//
//  Created by Silstone on 03/07/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EatHere.pch"
#import <lottie-ios/Lottie/LOTAnimationView.h>

@interface NewsFeedViewController : UIViewController
{
    NSMutableArray *newsFeedArray;
    TokenProcess *sampleProtocol;
    NSString *apiName;
    NSInteger tagValue;
    UIActivityIndicatorView *spinner;
    int offsetLimit;
    IBOutlet UILabel *emptyLbl;
    IBOutlet UIView *animationView;
    LOTAnimationView *hello_loader;
}
@property (strong, nonatomic) IBOutlet UITableView *newsFeedTable;
- (IBAction)postFeedAction:(id)sender;

@end
