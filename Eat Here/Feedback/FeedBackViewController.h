//
//  FeedBackViewController.h
//  Eat Here
//
//  Created by Silstone on 27/06/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *sendFeedBackBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)backBtnAction:(id)sender;
- (IBAction)sendFeedbackAction:(id)sender;

@end
