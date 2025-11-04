//
//  PagesViewController.h
//  Eat Here
//
//  Created by Silstone on 30/07/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagesViewController : UIViewController

@property  NSUInteger pageIndex;
@property  NSString *imgFile;
@property  NSString *txtTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ivScreenImage;
@property (weak, nonatomic) IBOutlet UILabel *lblScreenLabel;
@property (strong, nonatomic) IBOutlet UIView *circleArrowView;

@end
