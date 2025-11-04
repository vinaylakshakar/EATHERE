//
//  RootPageViewController.m
//  Eat Here
//
//  Created by Silstone on 31/07/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "RootPageViewController.h"
#import "EatHere.pch"

@interface RootPageViewController ()

@end

@implementation RootPageViewController

@synthesize PageViewController,arrPageTitles,arrPageImages,arrPageIdentifier;

- (void)viewDidLoad {
    [super viewDidLoad];
    arrPageTitles = @[@"View places to eat around you,change your location by simply clicking on the map",@"Tap list view to see a list of restaurants around you.",@"Search for Restaurants and Cuisines.",@"Advanced search lets you pick from over 170 Cuisines.",@"Hit Randomize on any screen to pick a random place.",@"Can't decide where to eat? Use the randomizer!",@"Know exactly what you want? Use the food finder.",@"Share your experience in News Feed!"];
    arrPageImages =@[@"tutorial_1",@"tutorial_2",@"tutorial_8",@"tutorial_3",@"tutorial_4",@"tutorial_5",@"tutorial_6",@"tutorial_7"];
    arrPageIdentifier =@[@"PagesViewController",@"secondPage",@"PagesViewController",@"thirdPage",@"fourthPage",@"PagesViewController",@"PagesViewController",@"PagesViewController"];
    
    self.pageControl.numberOfPages = arrPageImages.count;
    // Create page view controller
    self.PageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.PageViewController.dataSource = self;
    
    PagesViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.PageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.PageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:PageViewController];
    [self.view addSubview:PageViewController.view];
    [self.PageViewController didMoveToParentViewController:self];
    
    NSArray *subviews = self.PageViewController.view.subviews;
    UIPageControl *thisControl = nil;
    for (int i=0; i<[subviews count]; i++) {
        if ([[subviews objectAtIndex:i] isKindOfClass:[UIPageControl class]]) {
            thisControl = (UIPageControl *)[subviews objectAtIndex:i];
        }
    }
    
    thisControl.hidden = true;
    self.PageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+40);
    
    self.titleLable.text = self.arrPageTitles[0];
    [self.view addSubview:self.btnSkip];
    self.PageViewController.delegate =self;
    self.PageViewController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Page View Datasource Methods
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PagesViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound))
    {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PagesViewController*) viewController).pageIndex;
    
    if (index == NSNotFound)
    {
        return nil;
    }
    
    index++;
    if (index == [self.arrPageTitles count])
    {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

#pragma mark - Other Methods
- (PagesViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.arrPageTitles count] == 0) || (index >= [self.arrPageTitles count])) {
        return nil;
    }
    
    PagesViewController *pageContentViewController;
    // Create a new view controller and pass suitable data.
        pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:self.arrPageIdentifier[index]];
        pageContentViewController.imgFile = self.arrPageImages[index];
        pageContentViewController.txtTitle = self.arrPageTitles[index];
        pageContentViewController.pageIndex = index;

    //self.pageControl.currentPage = pageContentViewController.pageIndex;
    return pageContentViewController;
}

//#pragma mark - No of Pages Methods
//- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
//{
//    return [self.arrPageTitles count];
//}
//
//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
//{
//    return 0;
//}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    PagesViewController *pageContentView = (PagesViewController*) pendingViewControllers[0];
    self.pageControl.currentPage = pageContentView.pageIndex;
    self.titleLable.text = self.arrPageTitles[pageContentView.pageIndex];
    
    if (pageContentView.pageIndex==self.pageControl.numberOfPages-1) {
        [self.btnSkip setTitle:@"Done" forState:UIControlStateNormal];
    }else
    {
        [self.btnSkip setTitle:@"Skip" forState:UIControlStateNormal];
    }
}

- (IBAction)btnStartAgain:(id)sender
{
    TabBarViewController *TabBarView = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
    [self.navigationController pushViewController:TabBarView animated:NO];
    
//    PagesViewController *startingViewController = [self viewControllerAtIndex:0];
//    NSArray *viewControllers = @[startingViewController];
//    [self.PageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

@end
