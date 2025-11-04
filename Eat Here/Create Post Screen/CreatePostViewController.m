//
//  CreatePostViewController.m
//  Eat Here
//
//  Created by Silstone on 17/07/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "CreatePostViewController.h"
#import "EatHere.pch"
#import "TOCropViewController.h"
#define kOFFSET_FOR_KEYBOARD 270

@interface CreatePostViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, TOCropViewControllerDelegate>
{
    NSInteger rating;
    TokenProcess *sampleProtocol;
    NSString *searchTextString;
    NSMutableArray *recentSearchArray;
}

@property (nonatomic, strong) UIImage *image;           // The image we'll be cropping
@property (nonatomic, strong) UIImageView *imageView;   // The image view to present the cropped image

@property (nonatomic, assign) TOCropViewCroppingStyle croppingStyle; //The cropping style
@property (nonatomic, assign) CGRect croppedFrame;
@property (nonatomic, assign) NSInteger angle;

@end

@implementation CreatePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    rating =0;
    self.textView.layer.borderColor = [UIColor blackColor].CGColor;;
    self.textView.layer.borderWidth = 1.0;
    self.textView.layer.cornerRadius = 15;
    // Do any additional setup after loading the view.
    self.restaurantName.text = self.restaurantNameStr;
    if ([self.restaurantName.text isEqualToString:@""]) {
        [self.restaurantName setUserInteractionEnabled:YES];
    }
    
    _restaurantImage.clipsToBounds = YES;
    sampleProtocol = [[TokenProcess alloc]init];
    sampleProtocol.delegate = self;
    
    [self.restaurantName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    [self click_camera];
    [self showCropViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length >= 160 && range.length == 0)
    {
        return NO;
    }
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

-(void)textFieldDidChange:(UITextField *)textField
{
    searchTextString=self.restaurantName.text;
    if ([searchTextString isEqualToString:@""])
    {
        [self.searchView setHidden:YES];
    }else
    {
        [self updateSearchArray:searchTextString];
    }
    //[self updateSearchArray:searchTextString];
}

-(void)updateSearchArray:(NSString *)searchText
{
    [self autoCompleteSearch:searchText];
    
}
-(void)autoCompleteSearch:(NSString*)searchText
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:searchText forKey:@"text"];
    [dict setObject:[USERDEFAULTS valueForKey:AddressLatitude] forKey:@"latitude"];
    [dict setObject:[USERDEFAULTS valueForKey:AddressLongitude] forKey:@"longitude"];
    [dict setObject:@"en_CA" forKey:@"locale"];
    
    [[NetworkEngine sharedNetworkEngine]autoCompleteSearch:^(id object)
     {
        NSLog(@"%@",object);
//         if ([object valueForKey:@"terms"])
         {
             //recentSearchArray = [[object valueForKey:@"businesses"] valueForKey:@"name"];
             recentSearchArray = [object valueForKey:@"businesses"] ;
             if (recentSearchArray.count<1||[searchTextString isEqualToString:@""])
             {
                 [self.searchView setHidden:YES];
             } else {
                 [self.searchView setHidden:NO];
             }
             
             [self.searchTable reloadData];
         }
         
         
         
     }
                                                   onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
    
}

#pragma mark- tableview methods-

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (recentSearchArray.count>3) {
        return 3;
    }
    return recentSearchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [recentSearchArray[indexPath.row] valueForKey:@"name"];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"SegoeUI" size:15];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.textColor =  [UIColor blackColor];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchView setHidden:YES];
    self.restaurantName.text = [recentSearchArray[indexPath.row] valueForKey:@"name"];
    self.restaurantID = [recentSearchArray[indexPath.row] valueForKey:@"id"];
//    [self searchRestaurant];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Sample protocol delegate
-(void)processCompleted {
    NSLog(@"Process complete");
    [self createPost];
    
}

- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectRating:(id)sender {
    
    for (int i = 11; i<=15; i++)
    {
          UIButton *ratingBtn = [self.view viewWithTag:i];
        if (i<=[sender tag]) {
            [ratingBtn setSelected:YES];
        } else {
            [ratingBtn setSelected:NO];
        }
     
    }
    
    UIButton *ratingBtn = [self.view viewWithTag:[sender tag]];
    [ratingBtn setSelected:YES];
    rating = [sender tag]-10;
    NSLog(@"%ld",(long)rating);
}

- (IBAction)createPost:(id)sender
{
    if (![USERDEFAULTS valueForKey:kuserID])
    {
        
         [self showAlert:@"You are not register user. Please login!"];
        
    }else if (rating ==0)
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Eat Here!"
                                                                      message:@"Please Select Rating."
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        
                                    }];
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    //vinay here-
//    else if ([self.textView.text isEqualToString:@""])
//    {
//        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Eat Here!"
//                                                                      message:@"Please Enter Your Comment."
//                                                               preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
//                                                            style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action)
//                                    {
//                                        
//                                    }];
//        
//        [alert addAction:yesButton];
//        
//        [self presentViewController:alert animated:YES completion:nil];
//    }
    else if ([self.restaurantName.text isEqualToString:@""])
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Eat Here!"
                                                                      message:@"Please Enter Your Restaurant name."
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        
                                    }];
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if ([self.restaurantID isEqualToString:@""] || self.restaurantID == nil)
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Eat Here!"
                                                                      message:@"Please Enter correct Restaurant name."
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        
                                    }];
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
    else
    {
            [self createPost];
    }
    

}

-(void)createPost
{
    
    if(isChooseImage)
    {

            [kAppDelegate showProgressHUD];
        
        NSString *ratingStr =[NSString stringWithFormat:@"%ld",(long)rating];
        
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userId"];
                    [dict setObject:self.restaurantID forKey:@"ResturantId"];
                    [dict setObject:self.restaurantName.text forKey:@"RestaurantName"];
        
        if (self.restaurantLatitude && self.restaurantLongitude) {
            [dict setObject:self.restaurantLatitude forKey:@"lat"];
            [dict setObject:self.restaurantLongitude forKey:@"lang"];
        } else {
            [dict setObject:[USERDEFAULTS valueForKey:AddressLatitude] forKey:@"lat"];
            [dict setObject:[USERDEFAULTS valueForKey:AddressLongitude] forKey:@"lang"];
        }

        if (self.AddressStr) {
            [dict setObject:self.AddressStr forKey:@"address"];
        } else {
            [dict setObject:@"" forKey:@"address"];
        }
        
                    [dict setObject:self.textView.text forKey:@"comment"];
                    [dict setObject:ratingStr forKey:@"Rating"];
            
            NSString *filename = [NSString stringWithFormat:@"%ld%c%c.jpg", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
            
           // NSLog(@"%@",dict);
                
                [[NetworkEngine sharedNetworkEngine]CreatePost:^(id object)
                 {
                     NSLog(@"errekkjk %@",object);
                     
      
                                 if ([[object valueForKey:@"status"] isEqualToString:@"success"])
                                 {
                                     
                                     [self.tabBarController setSelectedIndex:3];
                                     [self.navigationController popToRootViewControllerAnimated:NO];
                     
//                                     UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
//                                                                                                    message:@"Post Created Successfully."
//                                                                                             preferredStyle:UIAlertControllerStyleAlert];
//
//                                     UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                                         [self.navigationController popViewControllerAnimated:YES];
//                                     }];
//                                     [alert addAction:cancel];
//                                     [self presentViewController:alert animated:YES completion:nil];
                     
                                 } else if([[object valueForKey:@"Message"] isEqualToString:@"Authorization failed."])
                                 {
                                     [sampleProtocol startSampleProcess];
                                 }else
                                 {
//                                     UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
//                                                                                                    message:[object valueForKey:@"Message"]
//                                                                                             preferredStyle:UIAlertControllerStyleAlert];
//
//                                     UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
//                                     [alert addAction:cancel];
//                                     [self presentViewController:alert animated:YES completion:nil];
//vinay here-
                                     [self.navigationController popToRootViewControllerAnimated:false];
                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"selectNewsFeed" object:self userInfo:nil];
                                     
                                 }
                     

                         [kAppDelegate hideProgressHUD];
                         

                 } onError:^(NSError *error)
                 {
                     NSLog(@"%@",error);
                 } filePath:filename imageName:_restaurantImage.image params:dict];
  

    }else
    {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Eat here!"
                                                                       message:@"Please Select Image."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (IBAction)selectImage:(id)sender {
    
//    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
//                                                                  message:nil
//                                                           preferredStyle:UIAlertControllerStyleActionSheet];
//
//    UIAlertAction* galleryBtn = [UIAlertAction actionWithTitle:@"Open Gallery"
//                                                        style:UIAlertActionStyleDefault
//                                                      handler:^(UIAlertAction * action)
//                                {
//                                   [self click_gallery];
//                                }];
//    UIAlertAction* cameraBtn = [UIAlertAction actionWithTitle:@"Camera"
//                                                        style:UIAlertActionStyleDefault
//                                                      handler:^(UIAlertAction * action)
//                                {
//                                    [self click_camera];
//                                }];
//
//    [alert addAction:galleryBtn];
//    [alert addAction:cameraBtn];
//
//    [self presentViewController:alert animated:YES completion:nil];
    
    [self showCropViewController];
}
-(void)click_camera
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        UIColor* color = [UIColor colorWithRed:46.0/255 green:127.0/255 blue:244.0/255 alpha:1];
        [imgPicker.navigationBar setTintColor:color];
        imgPicker.delegate = self;
        imgPicker.allowsEditing = YES;
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imgPicker animated:NO completion:Nil];
    }
    else
    {
        UIAlertView *alert1=[[UIAlertView alloc]initWithTitle:@"Alert! " message:@"Device does not support camera" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert1 show];
    }
}

-(void)click_gallery
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imgPicker= [[UIImagePickerController alloc] init];
        UIColor* color = [UIColor colorWithRed:46.0/255 green:127.0/255 blue:244.0/255 alpha:1];
        [imgPicker.navigationBar setTintColor:color];
        imgPicker.delegate = self;
        imgPicker.allowsEditing = YES;
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imgPicker animated:NO completion:Nil];
    }
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    imageOriginal =  [info objectForKey:UIImagePickerControllerEditedImage];
//
//    imgData=UIImageJPEGRepresentation(imageOriginal,0.5);
//
//    if (click_reg==YES)
//    {
//        click_reg=NO;
//
//        if (picker.sourceType==UIImagePickerControllerSourceTypeCamera)
//        {
//            _restaurantImage.image=imageOriginal;
//        }
//        else
//        {
//            _restaurantImage.image=imageOriginal;
//
//        }
//    }
//    else
//    {
//        if (picker.sourceType==UIImagePickerControllerSourceTypeCamera)
//        {
//            _restaurantImage.image=imageOriginal;
//        }
//        else
//        {
//            _restaurantImage.image=imageOriginal;
//
//        }
//    }
//    isChooseImage=YES;
//    [picker dismissViewControllerAnimated:YES completion:Nil];
//
//
//}

#pragma mark - Image Picker Delegate -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    
    
//    TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:self.croppingStyle image:image];
//
//    [cropController setAspectRatioPreset:TOCropViewControllerAspectRatioPresetSquare];
//    [cropController setRotateButtonsHidden:YES];
//    [cropController setAspectRatioPickerButtonHidden:YES];
//    [cropController setAspectRatioLockEnabled:YES];
//    [cropController setResetAspectRatioEnabled:false];
//    cropController.delegate = self;
    
    
    
    // Uncomment this if you wish to provide extra instructions via a title label
    //cropController.title = @"Crop Image";
    
    // -- Uncomment these if you want to test out restoring to a previous crop setting --
    //cropController.angle = 90; // The initial angle in which the image will be rotated
    //cropController.imageCropFrame = CGRectMake(0,0,2848,4288); //The initial frame that the crop controller will have visible.
    
    // -- Uncomment the following lines of code to test out the aspect ratio features --
    //cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare; //Set the initial aspect ratio as a square
    //cropController.aspectRatioLockEnabled = YES; // The crop box is locked to the aspect ratio and can't be resized away from it
    //cropController.resetAspectRatioEnabled = NO; // When tapping 'reset', the aspect ratio will NOT be reset back to default
    //cropController.aspectRatioPickerButtonHidden = YES;
    
    // -- Uncomment this line of code to place the toolbar at the top of the view controller --
    //cropController.toolbarPosition = TOCropViewControllerToolbarPositionTop;
    
    //cropController.rotateButtonsHidden = YES;
    //cropController.rotateClockwiseButtonHidden = NO;
    
    //cropController.doneButtonTitle = @"Title";
    //cropController.cancelButtonTitle = @"Title";
    
    self.image = image;
    
    //vinay here-
    _restaurantImage.image=image;
//     [picker pushViewController:cropController animated:YES];
    //If profile picture, push onto the same navigation stack
//    if (self.croppingStyle == TOCropViewCroppingStyleCircular) {
//        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//            [picker dismissViewControllerAnimated:YES completion:^{
//                [self presentViewController:cropController animated:YES completion:nil];
//            }];
//        } else {
//            [picker pushViewController:cropController animated:YES];
//        }
//    }
//    else { //otherwise dismiss, and then present from the main controller
    
    
    self.imageView.image = image;
    //vinay here-
    _restaurantImage.image=image;
    _restaurantImage.clipsToBounds = YES;
    isChooseImage = YES;
    [self layoutImageView];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    
        [picker dismissViewControllerAnimated:YES completion:^{
//            [self presentViewController:cropController animated:YES completion:nil];
            //[self.navigationController pushViewController:cropController animated:YES];
        }];
//    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Image Layout -
- (void)layoutImageView
{
    if (self.imageView.image == nil)
        return;
    
    CGFloat padding = 20.0f;
    
    CGRect viewFrame = self.view.bounds;
    viewFrame.size.width -= (padding * 2.0f);
    viewFrame.size.height -= ((padding * 2.0f));
    
    CGRect imageFrame = CGRectZero;
    imageFrame.size = self.imageView.image.size;
    
    if (self.imageView.image.size.width > viewFrame.size.width ||
        self.imageView.image.size.height > viewFrame.size.height)
    {
        CGFloat scale = MIN(viewFrame.size.width / imageFrame.size.width, viewFrame.size.height / imageFrame.size.height);
        imageFrame.size.width *= scale;
        imageFrame.size.height *= scale;
        imageFrame.origin.x = (CGRectGetWidth(self.view.bounds) - imageFrame.size.width) * 0.5f;
        imageFrame.origin.y = (CGRectGetHeight(self.view.bounds) - imageFrame.size.height) * 0.5f;
        self.imageView.frame = imageFrame;
    }
    else {
        self.imageView.frame = imageFrame;
        self.imageView.center = (CGPoint){CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)};
    }
}


#pragma mark - Bar Button Items -
- (void)showCropViewController
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Open Gallery", @"")
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              self.croppingStyle = TOCropViewCroppingStyleDefault;
                                                              
                                                              UIImagePickerController *standardPicker = [[UIImagePickerController alloc] init];
                                                              standardPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                              standardPicker.allowsEditing = NO;
                                                              standardPicker.delegate = self;
                                                              [self presentViewController:standardPicker animated:YES completion:nil];
                                                          }];
    
    UIAlertAction *profileAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Camera", @"")
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              self.croppingStyle = TOCropViewCroppingStyleDefault;
                                                              
                                                              UIImagePickerController *profilePicker = [[UIImagePickerController alloc] init];
                                                              profilePicker.modalPresentationStyle = UIModalPresentationPopover;
                                                              profilePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                              profilePicker.allowsEditing = NO;
                                                              profilePicker.delegate = self;
                                                              profilePicker.preferredContentSize = CGSizeMake(512,512);
                                                              profilePicker.popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItem;
                                                              [self presentViewController:profilePicker animated:YES completion:nil];
                                                          }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"")
                                                            style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction *action) {
                                                             
                                                         }];
    
    [alertController addAction:defaultAction];
    [alertController addAction:profileAction];
     [alertController addAction:cancelAction];
    [alertController setModalPresentationStyle:UIModalPresentationPopover];
    
    UIPopoverPresentationController *popPresenter = [alertController popoverPresentationController];
    popPresenter.barButtonItem = self.navigationItem.leftBarButtonItem;
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Cropper Delegate -
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    self.croppedFrame = cropRect;
    self.angle = angle;
    [self updateImageViewWithImage:image fromCropViewController:cropViewController];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToCircularImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    self.croppedFrame = cropRect;
    self.angle = angle;
    [self updateImageViewWithImage:image fromCropViewController:cropViewController];
}

- (void)updateImageViewWithImage:(UIImage *)image fromCropViewController:(TOCropViewController *)cropViewController
{
    self.imageView.image = image;
    //vinay here-
    _restaurantImage.image=image;
    _restaurantImage.clipsToBounds = YES;
    isChooseImage = YES;
    [self layoutImageView];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    if (cropViewController.croppingStyle != TOCropViewCroppingStyleCircular) {
        self.imageView.hidden = YES;
        [cropViewController dismissAnimatedFromParentViewController:self
                                                   withCroppedImage:image
                                                             toView:self.imageView
                                                            toFrame:CGRectZero
                                                              setup:^{ [self layoutImageView]; }
                                                         completion:
         ^{
             self.imageView.hidden = NO;
         }];
    }
    else {
        self.imageView.hidden = NO;
        [cropViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)showAlert:(NSString*)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Eat Here!" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"LOGIN" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                             //BUTTON OK CLICK EVENT
                             
                             [self SigninUser];
                             
                         }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:ok];
    [alert.view setTintColor:[UIColor redColor]];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)SigninUser
{
    [Utility PushtoLoginPage:self.navigationController];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self setViewMovedUp: YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self setViewMovedUp:NO];
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    
    // if you want to slide up the view
    [UIView setAnimationDuration:0.3];
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

@end
