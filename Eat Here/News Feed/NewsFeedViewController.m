//
//  NewsFeedViewController.m
//  Eat Here
//
//  Created by Silstone on 03/07/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "NewsFeedViewController.h"


@implementation NewsFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    newsFeedArray =[[NSMutableArray alloc]init];
    offsetLimit =1;
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner stopAnimating];
    spinner.hidesWhenStopped = YES;
    spinner.frame = CGRectMake(0, 0, 320, 44);
    self.newsFeedTable.tableFooterView = spinner;
    [emptyLbl setHidden:YES];
    [animationView setHidden:YES];
    [self StopLottieAnimation];
    //for autolauout cell height-
    //    self.newsFeedTable.rowHeight = UITableViewAutomaticDimension;
    //    self.newsFeedTable.estimatedRowHeight = 414;
    
    sampleProtocol = [[TokenProcess alloc]init];
    sampleProtocol.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(LoginNewsFeed)
                                                 name:@"LoginNewsFeed"
                                               object:nil];
}

- (void)LoginNewsFeed
{
    [Utility PushtoLoginPage:self.navigationController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([USERDEFAULTS valueForKey:kuserID])
    {
        offsetLimit  = 1;
        self.newsFeedTable.hidden = false;
        [newsFeedArray removeAllObjects];
        [self Newsfeedlist];
    }
    else{
        //        self.newsFeedTable.hidden = true;
        //         [self showAlert:@"you need to be login to view the news feed"];
    }
    
}

#pragma mark - Sample protocol delegate
-(void)processCompleted {
    NSLog(@"Process complete");
    if ([apiName isEqualToString:@"Newsfeedlist"]) {
        [self Newsfeedlist];
    }else if ([apiName isEqualToString:@"Deletenewsfeed"]) {
        [self Deletenewsfeed:tagValue];
    }
    
}

-(void)Newsfeedlist
{
    NSString *offsetStr = [NSString stringWithFormat:@"%d",offsetLimit];
    //[dict setObject:offsetStr forKey:@"offset"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:offsetStr forKey:@"offset"];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
    [dict setObject:[USERDEFAULTS valueForKey:AddressLatitude] forKey:@"latitude"];
    [dict setObject:[USERDEFAULTS valueForKey:AddressLongitude] forKey:@"longitude"];
    
    NSLog(@"%@",dict);
    if (offsetLimit==1)
    {
        [kAppDelegate showProgressHUD];
    }
    
    [[NetworkEngine sharedNetworkEngine]Newsfeedlist:^(id object)
     {
         
         NSLog(@"%@",object);
         [spinner stopAnimating];
         
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             [emptyLbl setHidden:YES];
             [animationView setHidden:YES];
             [self StopLottieAnimation];
             //[kAppDelegate hideProgressHUD];
             NSMutableArray *arr= [[object valueForKey:@"FeedNewsList"] mutableCopy];
             for (int i=0; i<arr.count; i++) {
                 [newsFeedArray addObject:[arr objectAtIndex:i]];
             }
             [self.newsFeedTable reloadData];
             
         } else if ([[object valueForKey:@"Message"] isEqualToString:@"Authorization failed."])
         {
             apiName =@"Newsfeedlist";
             [sampleProtocol startSampleProcess];
         }
         else
         {
             if (newsFeedArray.count == 0) {
                 emptyLbl.text = @"No posts in your area. Be the first to review!";
                 [animationView setHidden:NO];
                 [self playLottieAnimation];
                 [emptyLbl setHidden:NO];
             }
//             emptyLbl.text = @"No posts in your area. Be the first to review!";
//             [animationView setHidden:NO];
//             [self playLottieAnimation];
//             [emptyLbl setHidden:NO];
             [self.newsFeedTable reloadData];
//             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!"
//                                                                           message:@"No posts in your area. Be the first to review!"
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//
//             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
//                                                                 style:UIAlertActionStyleDefault
//                                                               handler:^(UIAlertAction * action)
//                                         {
//                                             [self.navigationController popToRootViewControllerAnimated:YES];
//                                         }];
//
//             [alert addAction:yesButton];
//
//             [self presentViewController:alert animated:YES completion:nil];
         }
         
         if (offsetLimit==1)
         {
             [kAppDelegate hideProgressHUD];
         }
         
         
         
     }
                                             onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return newsFeedArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    
    static NSString *propertyIdentifier = @"NewsFeedCell";
    
    NewsFeedCell *cell = (NewsFeedCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier];
    
    if (cell == nil)
    {
        
        NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"NewsFeedCell" owner:self options:nil];
        cell = [nib1 objectAtIndex:0];
    }
    NSMutableDictionary *dic = [newsFeedArray objectAtIndex:indexPath.row];
    cell.restaurantName.text =[[dic valueForKey:@"RestaurantName"] uppercaseString];
    cell.restaurantAddress.text =[dic valueForKey:@"address"];
    
    int ReviewNumber = [[dic valueForKey:@"allUserReviewNumber"] intValue];
    if (ReviewNumber>1) {
        cell.reviewNumber.text =[NSString stringWithFormat:@"%d Reviews",ReviewNumber];
    } else {
        cell.reviewNumber.text =[NSString stringWithFormat:@"%d Review",ReviewNumber];
    }
    
    cell.restaurantRating.text =[NSString stringWithFormat:@"%@",[dic valueForKey:@"RestaurantRating"]];
    
    cell.commentLable.text =[dic valueForKey:@"Comment"];
    cell.profileName.text =[dic valueForKey:@"username"];
    int userRating = [[[newsFeedArray objectAtIndex:indexPath.row] valueForKey:@"UserRating"] intValue];
    
    CGFloat floored1 = floor([[dic valueForKey:@"UserRating"] doubleValue]);
    int UserRating = (int)floored1;
    
    [self addRating:cell :UserRating];
    NSString *restaurantImg = [[NSString stringWithFormat:@"%@",[dic  valueForKey:@"RestaurantImage"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.restaurantImage sd_setImageWithURL:[NSURL URLWithString:restaurantImg] placeholderImage:[UIImage imageNamed:@"list_placeholder"] options:SDWebImageDelayPlaceholder progress:nil completed:nil];
    NSString *userImg = [[NSString stringWithFormat:@"%@",[dic valueForKey:@"userImage"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:userImg] placeholderImage:[UIImage imageNamed:@"profile_placeholder"] options:SDWebImageContinueInBackground progress:nil completed:nil];
    [self setRoundedView:cell.profileImage toDiameter:45.0];
    cell.profileImage.clipsToBounds = YES;
    cell.restaurantImage.layer.masksToBounds = YES;
    cell.shareBtn.tag = indexPath.row;
    [cell.shareBtn addTarget:self action:@selector(sharePost:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *PostUserID = [dic valueForKey:@"PostUserID"];
    NSString *UserID = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:kuserID]];
    
    if ([PostUserID isEqualToString:UserID])
    {
        [cell.deletePostBtn setHidden:NO];
        cell.deletePostBtn.tag = indexPath.row;
        [cell.deletePostBtn addTarget:self action:@selector(deletePost:) forControlEvents:UIControlEventTouchUpInside];
    }else
    {
        [cell.deletePostBtn setHidden:YES];
        cell.shareBtn.frame = CGRectMake(cell.deletePostBtn.frame.origin.x, cell.shareBtn.frame.origin.y, cell.shareBtn.frame.size.width, cell.shareBtn.frame.size.height);
        cell.shareBackImage.frame = CGRectMake(cell.shareBtn.frame.origin.x-5, cell.shareBackImage.frame.origin.y, cell.shareBackImage.frame.size.width-cell.deletePostBtn.frame.size.width, cell.shareBackImage.frame.size.height);
    }
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantDetailViewController *restaurantDetail =[self.storyboard instantiateViewControllerWithIdentifier:@"RestaurantDetailViewController"];
    restaurantDetail.restaurantId = [[newsFeedArray objectAtIndex:indexPath.row] valueForKey:@"ResturantId"];
    restaurantDetail.ratingStr = [[newsFeedArray objectAtIndex:indexPath.row] valueForKey:@"RestaurantRating"];
    restaurantDetail.restaurantNameStr = [[newsFeedArray objectAtIndex:indexPath.row] valueForKey:@"RestaurantName"];
    restaurantDetail.newsfeedImageStr = [[NSString stringWithFormat:@"%@",[newsFeedArray[indexPath.row]  valueForKey:@"RestaurantImage"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.navigationController pushViewController:restaurantDetail animated:YES];
}

-(void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
                  willDecelerate:(BOOL)decelerate{
    
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 50;
    if(y > h + reload_distance) {
        NSLog(@"load more data");
        [spinner setHidden:NO];
        [spinner startAnimating];
        
        offsetLimit =offsetLimit+1;
        
        [self Newsfeedlist];
        
        
        
    }
}

-(void)deletePost:(UIButton*)sender
{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!"
                                                                  message:@"Are you sure to want to delete post?"
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    tagValue = [sender tag];
                                    [self Deletenewsfeed:tagValue];
                                }];
    UIAlertAction* CancelBtn = [UIAlertAction actionWithTitle:@"CANCEL"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    
                                }];
    
    [alert addAction:yesButton];
    [alert addAction:CancelBtn];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)Deletenewsfeed:(NSInteger)feedID
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[newsFeedArray objectAtIndex:feedID]valueForKey:@"newsfeedid"] forKey:@"id"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]Deletenewsfeed:^(id object)
     {
         
         NSLog(@"%@",object);
         
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             //[kAppDelegate hideProgressHUD];
             
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!"
                                                                           message:[object valueForKey:@"Message"]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action)
                                         {
                                             [newsFeedArray removeObjectAtIndex:feedID];
                                             [self.newsFeedTable reloadData];
                                         }];
             
             [alert addAction:yesButton];
             
             [self presentViewController:alert animated:YES completion:nil];
             
         } else
         {
             apiName =@"Deletenewsfeed";
             [sampleProtocol startSampleProcess];
         }
         
         [kAppDelegate hideProgressHUD];
         
         
     }
                                               onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

-(void)sharePost:(UIButton*)sender
{
    NSInteger tag = [(UIButton *)sender tag];
    NSLog(@"%ld",(long)tag);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    NewsFeedCell *cell = [self.newsFeedTable cellForRowAtIndexPath:indexPath];
    
    NSString *textToShare = cell.commentLable.text;
    NSString *restaurantName = [NSString stringWithFormat:@"%@/n",cell.restaurantName.text];
    NSString *userName = [NSString stringWithFormat:@"%@/n",cell.profileName.text];
    //NSURL *myWebsite = [NSURL URLWithString:@"http://www.messagingapp.com/"];
    UIImage * image = cell.restaurantImage.image;
    
    NSArray *objectsToShare = @[image,restaurantName,userName,textToShare];
    
    
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    //    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
    //                                   UIActivityTypePrint,
    //                                   UIActivityTypeAssignToContact,
    //                                   UIActivityTypeSaveToCameraRoll,
    //                                   UIActivityTypeAddToReadingList,
    //                                   UIActivityTypePostToFlickr,
    //                                   UIActivityTypePostToVimeo];
    
    //activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark - custom rating method

-(void)addRating:(NewsFeedCell *)cell :(int)rating
{
    if (rating>=1) {
        cell.firstRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
        
    }
    if (rating>=2) {
        cell.secondRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
        
    }
    if (rating>=3) {
        cell.thirdRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
        
    }
    if (rating>=4) {
        cell.fourthRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
        
    }
    if (rating>=5) {
        cell.fifthRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
    }
}

- (IBAction)postFeedAction:(id)sender {
    
    if (![USERDEFAULTS valueForKey:kuserID])
    {
        [self showAlert:@"you need to be login to view the news feed"];
    }else
    {
        CreatePostViewController *createPost = [self.storyboard instantiateViewControllerWithIdentifier:@"CreatePostViewController"];
        [self.navigationController pushViewController:createPost animated:YES];
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

-(void)playLottieAnimation {
    hello_loader = [LOTAnimationView animationNamed:@"ice_cream_animation"];
    hello_loader.contentMode = UIViewContentModeScaleAspectFill;
    double newWidth = animationView.frame.size.width;
    hello_loader.frame = CGRectMake(0, 0,newWidth, newWidth);
    [animationView addSubview:hello_loader];
    hello_loader.loopAnimation = YES;
    [hello_loader play];
}

-(void)StopLottieAnimation {
    [hello_loader stop];
}

@end
