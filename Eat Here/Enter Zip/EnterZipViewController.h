//
//  EnterZipViewController.h
//  Eat Here
//
//  Created by Silstone on 30/07/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterZipViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *zipCodeField;
- (IBAction)doneBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)SkipBtnAction:(id)sender;

@end
