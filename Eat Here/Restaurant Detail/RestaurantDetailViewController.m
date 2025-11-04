//
//  RestaurantDetailViewController.m
//  Eat Here
//
//  Created by Silstone on 09/07/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "RestaurantDetailViewController.h"
#import "EatHere.pch"

@interface RestaurantDetailViewController ()
{
    NSMutableArray *CategoryNameArray,*CategoryImageArray;
    NSMutableDictionary *restaurantDetailDict;
}

@end

@implementation RestaurantDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.addressView.layer.cornerRadius = 5;
    self.addressView.layer.masksToBounds = NO;
    
    self.addressView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.addressView.layer.shadowOpacity = 0.1;
    self.addressView.layer.shadowRadius = 0.5;
    self.addressView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
//    CategoryNameArray = [[NSMutableArray alloc]initWithObjects:@"BBQ",@"Bar & Drinks",@"Healthy Coice",@"Cafe", nil];
//    CategoryImageArray = [[NSMutableArray alloc]initWithObjects:@"bbq_big",@"bar_big",@"healthy_big",@"cafe_big", nil];
    CategoryImageArray = [[NSMutableArray alloc]init];
    CategoryNameArray = [[NSMutableArray alloc]init];
    
    [self.scrollView setContentSize:CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height)];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CategoryCell" bundle:nil] forCellWithReuseIdentifier:@"CategoryCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.restaurantImage.clipsToBounds = YES;
    [self GetRestaurantDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)GetRestaurantDetail
{

    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.restaurantId forKey:@"id"];


    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]GetRestaurantDetail:^(id object)
     {
         
          NSLog(@"%@",object);
         
         {
             restaurantDetailDict = [[NSMutableDictionary alloc]initWithDictionary:object];
             [self setLayout];

         }
\
         [kAppDelegate hideProgressHUD];
         
         
     }
                                                 onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

-(void)setLayout
{
    [self.contentView setHidden:NO];
    
    NSLog(@"%@",self.newsfeedImageStr);
    
    if (!self.newsfeedImageStr)
    {
        [self setRating:[[restaurantDetailDict valueForKey:@"rating"] intValue]];
        [self.restaurantImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[restaurantDetailDict  valueForKey:@"image_url"]]] placeholderImage:nil options:0 progress:nil completed:nil];
        self.restaurantName.text =[[restaurantDetailDict valueForKey:@"name"] uppercaseString];
    }
    else
    {
        [self setRating:[_ratingStr intValue]];
//        [self.restaurantImage sd_setImageWithURL:[NSURL URLWithString:self.newsfeedImageStr] placeholderImage:nil options:0 progress:nil completed:nil];
        [self.restaurantImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[restaurantDetailDict  valueForKey:@"image_url"]]] placeholderImage:nil options:0 progress:nil completed:nil];
        self.restaurantName.text =[self.restaurantNameStr uppercaseString];
    }
    

    self.phoneNumber.text =[NSString stringWithFormat:@"Call Now: %@",[restaurantDetailDict valueForKey:@"display_phone"]];
     [self.phoneNumber setFont:[UIFont fontWithName:@"SegoeUI" size:21]];
    
    NSMutableArray *addressArray = [[restaurantDetailDict valueForKey:@"location"] valueForKey:@"display_address"];
    self.addressLineFirst.text =[addressArray objectAtIndex:0];
    
    if (addressArray.count>1) {
        self.addressLineSecond.text =[addressArray objectAtIndex:1];
    }
    if(addressArray.count>2)
    {
        self.addressLineSecond.text =[NSString stringWithFormat:@"%@ %@",[addressArray objectAtIndex:1],[addressArray objectAtIndex:2]];
    }

    NSMutableArray *categoriesArray = [restaurantDetailDict valueForKey:@"categories"];
    NSMutableArray *newCategory = [[NSMutableArray alloc]init];
    
    for (NSMutableDictionary *categoryDict in categoriesArray) {
        [newCategory addObject:[categoryDict valueForKey:@"title"]];
        NSString *categoryName = [self categoryName:[Utility setImage:categoryDict]];
        if (![CategoryNameArray containsObject:categoryName]) {
            [CategoryNameArray addObject:categoryName];
            [CategoryImageArray addObject:[Utility setImage:categoryDict]];
        }
        
        
    }
    [self.collectionView reloadData];
    
    self.cuisineLable.text = [newCategory componentsJoinedByString:@", "];
    [self.cuisineLable sizeToFit];
    self.averageCostLable.text = [restaurantDetailDict valueForKey:@"price"];
     [self.averageCostLable sizeToFit];
    
    NSArray *hoursArray = [restaurantDetailDict valueForKey:@"hours"];
    BOOL isOpen = [[[hoursArray objectAtIndex:0] valueForKey:@"is_open_now"] boolValue];
    
    if (isOpen) {
        self.timeLable.text = @"OPEN NOW";
    }else
    {
        
        self.timeLable.text = @"CLOSED NOW";
    }
    [self.timeLable setFont:[UIFont fontWithName:@"SegoeUI-Light" size:15]];
    
    NSArray *dateTimeArray =[[hoursArray objectAtIndex:0] valueForKey:@"open"];
    NSMutableArray *newDateTimeArray = [[NSMutableArray alloc]init];
    
    for (NSMutableDictionary *dateTimeDict in dateTimeArray)
    {
        NSString *dayTime = [self getdayTime:[dateTimeDict valueForKey:@"start"] :[dateTimeDict valueForKey:@"end"] :[[dateTimeDict valueForKey:@"day"] intValue]];
        
        if (![dateTimeArray containsObject:dayTime])
        {
            [newDateTimeArray addObject:dayTime];
        }
  
        
    }
    
//    if (dateTimeArray.count>6) {
//        [self.scrollView setContentSize:CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height+150)];
//    }else
//    {
//        [self.scrollView setContentSize:CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height+250)];
//    }
    
    self.showDateTimeLabel.text =[newDateTimeArray componentsJoinedByString:@",\n\n"];
    [self.showDateTimeLabel sizeToFit];
    [self.scrollView setContentSize:CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height+self.showDateTimeLabel.frame.size.height-70)];
   
}
-(NSString*)getdayTime:(NSString *)StartDate :(NSString*)EndDate :(int)dayNumber
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HHmm";
    NSDate *date = [dateFormatter dateFromString:StartDate];
    
    dateFormatter.dateFormat = @"hh:mm a";
    NSString *startDateString = [dateFormatter stringFromDate:date];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.dateFormat = @"HHmm";
    NSDate *date1 = [dateFormatter1 dateFromString:EndDate];
    
    dateFormatter1.dateFormat = @"hh:mm a";
    NSString *EndDateString = [dateFormatter stringFromDate:date1];
    
    NSString *retunStr;
    if (dayNumber==0) {
        retunStr =[NSString stringWithFormat:@"Monday: %@-%@",startDateString,EndDateString];
    }
    if (dayNumber==1) {
        retunStr =[NSString stringWithFormat:@"Tuesday: %@-%@",startDateString,EndDateString];
    }
    if (dayNumber==2) {
        retunStr =[NSString stringWithFormat:@"Wednesday: %@-%@",startDateString,EndDateString];
    }
    if (dayNumber==3) {
        retunStr =[NSString stringWithFormat:@"Thursday: %@-%@",startDateString,EndDateString];
    }
    if (dayNumber==4) {
        retunStr =[NSString stringWithFormat:@"Friday: %@-%@",startDateString,EndDateString];
    }
    if (dayNumber==5) {
        retunStr =[NSString stringWithFormat:@"Saturday: %@-%@",startDateString,EndDateString];
    }
    if (dayNumber==6) {
        retunStr =[NSString stringWithFormat:@"Sunday: %@-%@",startDateString,EndDateString];
    }
    
    NSLog(@"pmamDateString %@",retunStr);
    
    return retunStr;
}

-(NSString*)categoryName:(UIImage*)image
{
    NSString *categoryName;
    
    //    CategoryNameArray = [[NSMutableArray alloc]initWithObjects:@"BBQ",@"Bar & Drinks",@"Healthy Choice",@"Cafe", nil];
    if ([self firstimage:image isEqualTo:[UIImage imageNamed:@"fastfood_big"]]) // YES
    {
        // Do something
        categoryName =@"Fast Food";
    }
    else if ([self firstimage:image isEqualTo:[UIImage imageNamed:@"bar_big"]])
    {
        categoryName =@"Bar";
    }
    else if ([self firstimage:image isEqualTo:[UIImage imageNamed:@"bbq_big"]])
    {
        categoryName =@"BBQ";
    }
    else if ([self firstimage:image isEqualTo:[UIImage imageNamed:@"cafe_big"]])
    {
        categoryName =@"Cafe";
    }
    else if ([self firstimage:image isEqualTo:[UIImage imageNamed:@"dessert_big"]])
    {
        categoryName =@"Dessert";
    }
    else if ([self firstimage:image isEqualTo:[UIImage imageNamed:@"healthy_big"]])
    {
        categoryName =@"Healthy Choice";
    }
    else if ([self firstimage:image isEqualTo:[UIImage imageNamed:@"vegan_big"]])
    {
        categoryName =@"Vegan";
    }
    else if  ([self firstimage:image isEqualTo:[UIImage imageNamed:@"world_big"]])
    {
        categoryName =@"World";
    }
    else
    {
        categoryName =@"World";
    }
    return categoryName;
}

-(BOOL)firstimage:(UIImage *)image1 isEqualTo:(UIImage *)image2 {
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqualToData:data2];
}

-(void)setRating:(int)rating
{
    if (rating>0) {
        [self.ratingStarFirst setImage:[UIImage imageNamed:@"star_yellow"]];
    }
    if (rating>1) {
        [self.ratingStarSecond setImage:[UIImage imageNamed:@"star_yellow"]];
    }
    if (rating>2) {
        [self.ratingStarThird setImage:[UIImage imageNamed:@"star_yellow"]];
    }
    if (rating>3) {
        [self.ratingStarFourth setImage:[UIImage imageNamed:@"star_yellow"]];
    }
    if (rating>4) {
        [self.ratingStarFifth setImage:[UIImage imageNamed:@"star_yellow"]];
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return CategoryImageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCell" forIndexPath:indexPath];
    cell.categoryImage.image =[CategoryImageArray objectAtIndex:indexPath.row];
    cell.categoryName.text = [CategoryNameArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.frame.size.height-20, collectionView.frame.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{

    return 0.0;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
   
    
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(0, 100, 0, 0);
//}


- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)createPostBtn:(id)sender
{
    if (![USERDEFAULTS valueForKey:kuserID])
    {
        [self showAlert:@"You are not register user. Please login!"];
    }else
    {
        CreatePostViewController *createPost = [self.storyboard instantiateViewControllerWithIdentifier:@"CreatePostViewController"];
        createPost.restaurantID = self.restaurantId;
        createPost.restaurantNameStr = self.restaurantName.text;
        createPost.AddressStr =[NSString stringWithFormat:@"%@/n%@",self.addressLineFirst.text,self.addressLineSecond.text];
        createPost.restaurantLatitude = [[restaurantDetailDict valueForKey:@"coordinates"] valueForKey:@"latitude"];
        createPost.restaurantLongitude = [[restaurantDetailDict valueForKey:@"coordinates"] valueForKey:@"longitude"];
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


-(bool)CheckLocation
{
    self.isCurrentEnable = false;
    if ([CLLocationManager locationServicesEnabled]) {
        
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusDenied:
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
                self.isCurrentEnable = true;
                
                
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                self.isCurrentEnable = true;
                break;
            case kCLAuthorizationStatusNotDetermined:
                break;
            default:
                break;
        }
    }
    else{
        self.isCurrentEnable = false;
    }
    return self.isCurrentEnable;
}

//[USERDEFAULTS setObject:Clatitude forKey:CurrentAddressLatitude];
//[USERDEFAULTS setObject:Clongitude forKey:CurrentAddressLongitude];


- (IBAction)restaurantRoute:(id)sender
{
   
    [kAppDelegate showProgressHUD];
   // [self.view setUserInteractionEnabled:false];
    CLLocationCoordinate2D start;
    NSMutableDictionary* restaurantCoordinate =  [restaurantDetailDict valueForKey:@"coordinates"];
    NSMutableDictionary *destinationlocation = [restaurantDetailDict valueForKey:@"location"];
    
//    NSString *strDestinationAddress = [NSString stringWithFormat:@"%@, %@, %@, %@",[destinationlocation valueForKey:@"address1"],[destinationlocation valueForKey:@"city"],[destinationlocation valueForKey:@"zip_code"], [destinationlocation valueForKey:@"country"]];
    //vinay here-
    NSString *strDestinationAddress = [NSString stringWithFormat:@"%@, %@, %@",[destinationlocation valueForKey:@"address1"],[destinationlocation valueForKey:@"zip_code"], [destinationlocation valueForKey:@"country"]];
    
    start.latitude = [[USERDEFAULTS valueForKey:AddressLatitude] doubleValue];
    start.longitude = [[USERDEFAULTS valueForKey:AddressLongitude] doubleValue];
    CLLocationCoordinate2D destination = { [[restaurantCoordinate valueForKey:@"latitude"] doubleValue], [[restaurantCoordinate valueForKey:@"longitude"] doubleValue]};
    
    if([self CheckLocation])
    {
        start.latitude = [[USERDEFAULTS valueForKey:CurrentAddressLatitude] doubleValue];
        start.longitude = [[USERDEFAULTS valueForKey:CurrentAddressLongitude] doubleValue];
    }
    
  
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Run your loop here
        //vinay here-
        [self getRestaurantCoordinate:strDestinationAddress];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            //stop your HUD here
            //This is run on the main thread
            [kAppDelegate hideProgressHUD];
            
        });
    });
    
   
    //vinay here-
//    NSString *startLatitude = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:AddressLatitude]];
//    NSString *startLongitude = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:AddressLongitude]];
//
//    NSString* directionsURL = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%@,%@&daddr=%f,%f", startLatitude,  startLongitude, destination.latitude, destination.longitude];
////    NSString* directionsURL = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%@,%@&daddr=%@", self.startLatitude,  self.startLongitude, strDestinationAddress];
// //   directionsURL = [directionsURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    NSURL *url = [NSURL URLWithString:directionsURL];
//    if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
//        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
//
//        }];
//    } else {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: directionsURL]];
//    }

}

//vinay here-
-(void)getRestaurantCoordinate:(NSString*)strDestinationAddress
{
    NSString *trimmed = [strDestinationAddress stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&key=AIzaSyABrCIdzKuY_EELaxv4OYoxnJ0SGYuf1Ks",trimmed]]];
    
    [request setHTTPMethod:@"POST"];
    NSError *err;
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    if([[dict valueForKey:@"status"] isEqualToString:@"ZERO_RESULTS"])
    {
        [Utility showAlertMessage:@"Eat Here" message:@"Address not valid please check and try again."];
    }
    else{
        NSString *lataddr=[[[[[dict objectForKey:@"results"] objectAtIndex:0]objectForKey:@"geometry"]objectForKey:@"location"]objectForKey:@"lat"];
        
        NSString *longaddr=[[[[[dict objectForKey:@"results"] objectAtIndex:0]objectForKey:@"geometry"]objectForKey:@"location"]objectForKey:@"lng"];
        
        NSString *startLatitude = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:AddressLatitude]];
        NSString *startLongitude = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:AddressLongitude]];
        
        NSString* directionsURL = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%@,%@&daddr=%f,%f", startLatitude,  startLongitude, lataddr.doubleValue, longaddr.doubleValue];
        //    NSString* directionsURL = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%@,%@&daddr=%@", self.startLatitude,  self.startLongitude, strDestinationAddress];
        //   directionsURL = [directionsURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *url = [NSURL URLWithString:directionsURL];
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                
            }];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: directionsURL]];
        }
        
        
    }
    
}

- (IBAction)callNowAction:(id)sender
{
    NSString *phNo = [restaurantDetailDict valueForKey:@"phone"];
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
}
@end
