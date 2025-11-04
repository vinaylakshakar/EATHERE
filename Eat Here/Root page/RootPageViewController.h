//
//  RootPageViewController.h
//  Eat Here
//
//  Created by Silstone on 31/07/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagesViewController.h"

@interface RootPageViewController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (nonatomic,strong) UIPageViewController *PageViewController;
@property (nonatomic,strong) NSArray *arrPageTitles;
@property (nonatomic,strong) NSArray *arrPageImages;
@property (nonatomic,strong) NSArray *arrPageIdentifier;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;

- (PagesViewController *)viewControllerAtIndex:(NSUInteger)index;

@property (strong, nonatomic) IBOutlet UIButton *btnSkip;
- (IBAction)btnStartAgain:(id)sender;
@end
