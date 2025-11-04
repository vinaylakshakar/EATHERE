//
//  PagesViewController.m
//  Eat Here
//
//  Created by Silstone on 30/07/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "PagesViewController.h"
#import "RootPageViewController.h"

@interface PagesViewController ()

@end

@implementation PagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ivScreenImage.image = [UIImage imageNamed:self.imgFile];
    self.lblScreenLabel.text = self.txtTitle;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
//    [NSTimer scheduledTimerWithTimeInterval:1.0
//                                     target:self
//                                   selector:@selector(targetMethod)
//                                   userInfo:nil
//                                    repeats:NO];
}


-(void)targetMethod
{
     [self.circleArrowView setHidden:NO];
//    [UIView animateWithDuration:0.5f animations:^{
//        self.circleArrowView.frame = CGRectOffset(self.circleArrowView.frame, 0, 0);
//    }];
    
    [UIView transitionWithView:self.circleArrowView
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        //self.circleArrowView = NO;
                    }
                    completion:NULL];
   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
