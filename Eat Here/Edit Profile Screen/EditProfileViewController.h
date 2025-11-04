//
//  EditProfileViewController.h
//  Eat Here
//
//  Created by Silstone on 12/10/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditProfileViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    BOOL click_reg;
    UIImage *imageOriginal;
    NSData *imgData;
    BOOL isChooseImage;
    IBOutlet UIButton *updatePhoneBtn;
    
}

@property (weak, nonatomic) IBOutlet UITextField *zipCodeField;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
- (IBAction)backBtnAction:(id)sender;
- (IBAction)updateProfile:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveChangeBtn;
- (IBAction)saveChangesAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) NSMutableDictionary *userDetail;

@end

NS_ASSUME_NONNULL_END
