//
//  CreatePostViewController.h
//  Eat Here
//
//  Created by Silstone on 17/07/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatePostViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>
{
    BOOL click_reg;
    UIImage *imageOriginal;
    NSData *imgData;
    BOOL isChooseImage;
    
}
- (IBAction)backBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)selectRating:(id)sender;
- (IBAction)createPost:(id)sender;
- (IBAction)selectImage:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *restaurantImage;
@property (strong, nonatomic) IBOutlet UITextField *restaurantName;
@property (strong, nonatomic) NSString *restaurantID;
@property (strong, nonatomic) NSString *AddressStr;
@property (strong, nonatomic) NSString *restaurantNameStr;
@property (strong, nonatomic) NSString *restaurantLatitude;
@property (strong, nonatomic) NSString *restaurantLongitude;
@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet UITableView *searchTable;


@end
