//
//  RandamizeDetailViewController.m
//  Eat Here
//
//  Created by Silstone on 01/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "RandamizeDetailViewController.h"
#import "EatHere.pch"

@interface RandamizeDetailViewController ()
{
    NSMutableDictionary *Restaurantdict;
    BOOL isfromDashboard;
}

@end

@implementation RandamizeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     restaurantArray = [[NSMutableArray alloc]init];
    self.viewMoreBtn.layer.cornerRadius = self.viewMoreBtn.frame.size.height/2;
    self.viewMoreBtn.layer.masksToBounds = YES;
    self.spinAgainBtn.layer.cornerRadius = self.spinAgainBtn.frame.size.height/2;
    self.spinAgainBtn.layer.masksToBounds = YES;
    
    self.mainView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.mainView.layer.shadowOpacity = 0.5;
    self.mainView.layer.shadowRadius = 2;
    self.mainView.layer.shadowOffset = CGSizeMake(3.0f, 5.0f);
    
    
    mainImage.layer.cornerRadius = 5.0;
    smallImageView.layer.cornerRadius = 5.0;
    smallImageView.layer.masksToBounds = YES;
    mainImage.layer.masksToBounds = YES;
    
//    if(self.fromRandomPage)
//    {
//        //[self callApiForCategory];
//        //vinay here-
//        [self updateCategory];
//    }else
//    {
//        //vinay here-
//        [self updateCategory];
//        [self.viewMoreBtn setHidden:YES];
//        [self.backBtn setHidden:YES];
//        [self.spinAgainBtn setTitle:@"Randomize Again" forState:UIControlStateNormal];
//    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"removeSuperView"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"Randomizer"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
        if(self.fromRandomPage)
        {
            //[self callApiForCategory];
            //vinay here-
            [self updateCategory];
    
        }else
        {
            //vinay here-
            [self updateCategory];
            [self.viewMoreBtn setHidden:YES];
            [self.backBtn setHidden:YES];
            [self.spinAgainBtn setTitle:@"Randomize Again" forState:UIControlStateNormal];
        }
    
    //[self callApiForCategory];
}

- (IBAction)viewMoreAction:(id)sender
{
    [self.moreOptionsView setHidden:NO];
    [self.viewMoreTable reloadData];
}

- (IBAction)backBtnAction:(id)sender
{
    
    if(self.fromRandomPage)
    {
        [self.view removeFromSuperview];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StopWheel" object:self userInfo:nil];
}

- (void)receiveNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"removeSuperView"])
    {
        [self.view removeFromSuperview];
    }
    else
    {
        if (!isfromDashboard) {
            [self callApiForCategory];
        }
       
        //vinay here-
       // [self updateCategory];
    }
    
}

-(void)updateCategory{
    isfromDashboard = true;
   // [kAppDelegate showProgressHUD];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"restaurants" forKey:@"term"];
    
    if (self.fromRandomPage)
    {
        [dict setObject:[self getCategoriesString] forKey:@"categories"];
    } else {
        [dict setObject:@"restaurants,food" forKey:@"categories"];
    }
    
    
    [dict setObject:@"10000" forKey:@"radius"];
    [dict setObject:@"50" forKey:@"limit"];
    [dict setObject:@"0" forKey:@"offset"];
    [dict setObject:[USERDEFAULTS valueForKey:AddressLatitude] forKey:@"latitude"];
    [dict setObject:[USERDEFAULTS valueForKey:AddressLongitude] forKey:@"longitude"];
    if([self.CategoryName isEqualToString:@"You gotta Eat here!"])
    {
        [dict setObject:@"distance" forKey:@"sort_by"];
    }
    else{
        [dict setObject:@"distance" forKey:@"sort_by"];
    }
    
    
    [[NetworkEngine sharedNetworkEngine]DashboardListingForFinder:^(id object)
     {
         
         NSLog(@"%@",object);
          restaurantArray = [[NSMutableArray alloc]init];
         if ([object valueForKey:@"businesses"])
         {
             NSMutableArray *arr = [object valueForKey:@"businesses"];
             for (int i=0; i<arr.count; i++) {
                 [restaurantArray addObject:[arr objectAtIndex:i]];
             }
             if(restaurantArray.count>=1)
             {
                 
                 if (self.fromRandomPage) {
                     NSUInteger randomIndex = arc4random() % restaurantArray.count;
                     Restaurantdict = [restaurantArray objectAtIndex:randomIndex];
                     
                 } else {
                     NSUInteger randomIndex = arc4random() % restaurantArray.count;
                     Restaurantdict = [restaurantArray objectAtIndex:randomIndex];
                 }
                 
                 //                categoryImage;
                 [mainImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[Restaurantdict  valueForKey:@"image_url"]]] placeholderImage:[UIImage imageNamed:@"list_placeholder"] options:0 progress:nil completed:nil];
                 mainImage.layer.cornerRadius = 5.0;
                 mainImage.layer.masksToBounds = YES;
                 
                 restaurantName.text = [Restaurantdict valueForKey:@"name"];
                 NSArray *addressArray = [[Restaurantdict  valueForKey:@"location"] valueForKey:@"display_address"];
                 restaurantAddress.text = [addressArray componentsJoinedByString:@""];
                 BOOL isClosed = [[Restaurantdict valueForKey:@"is_closed"] boolValue];
                 if (isClosed) {
                     restaurantOpen.text = @"Closed Now";
                     
                 } else {
                     
                     restaurantOpen.text = @"Open Now";
                 }
                 int rate = roundf([[Restaurantdict valueForKey:@"rating"] intValue]);
                 
                 
                 [self addRating:rate];
                 
                 //                 [categoryImage setImage:[Utility GetImageFromcategoryName:self.CategoryName]];
                 
                 //vinay here-
                 
                 if (self.fromRandomPage)
                 {
                     [categoryImage setImage:[Utility GetImageFromcategoryName:self.CategoryName]];
                 }
                 else
                 {
                     NSMutableArray *categoriesArray = [Restaurantdict valueForKey:@"categories"];
                     [categoryImage setImage:[Utility setImage:[categoriesArray objectAtIndex:0]]];
                 }
                 
                 [self.restaurantDetailBtn setHidden:NO];
             }else
             {
                 [self.restaurantDetailBtn setHidden:YES];
                 [self showAlert];
                 
             }
             
         }
         //[kAppDelegate hideProgressHUD];
        isfromDashboard = false;
         
         
         
     }
                                                 onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

-(void)callApiForCategory
{
  
    
    if (restaurantArray.count > 0 && !(self.fromRandomPage)) {

        NSUInteger randomIndex = arc4random() % restaurantArray.count;
        Restaurantdict = [restaurantArray objectAtIndex:randomIndex];
        //                categoryImage;
        [mainImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[Restaurantdict  valueForKey:@"image_url"]]] placeholderImage:[UIImage imageNamed:@"list_placeholder"] options:0 progress:nil completed:nil];
        mainImage.layer.cornerRadius = 5.0;
        mainImage.layer.masksToBounds = YES;

        restaurantName.text = [Restaurantdict valueForKey:@"name"];
        NSArray *addressArray = [[Restaurantdict  valueForKey:@"location"] valueForKey:@"display_address"];
        restaurantAddress.text = [addressArray componentsJoinedByString:@""];
        BOOL isClosed = [[Restaurantdict valueForKey:@"is_closed"] boolValue];
        if (isClosed) {
            restaurantOpen.text = @"Closed Now";

        } else {

            restaurantOpen.text = @"Open Now";
        }
        int rate = roundf([[Restaurantdict valueForKey:@"rating"] intValue]);


        [self addRating:rate];

        //                 [categoryImage setImage:[Utility GetImageFromcategoryName:self.CategoryName]];

        //vinay here-

        if (self.fromRandomPage)
        {
            [categoryImage setImage:[Utility GetImageFromcategoryName:self.CategoryName]];
        }
        else
        {
            NSMutableArray *categoriesArray = [Restaurantdict valueForKey:@"categories"];
            [categoryImage setImage:[Utility setImage:[categoriesArray objectAtIndex:0]]];
        }

        [self.restaurantDetailBtn setHidden:NO];


    }
    //else
    
    //vinay here-latest changes
    
}

-(NSString *)getCategoriesString
{
    NSString *categories;
    if([self.CategoryName isEqualToString:@"BBQ"])
    {
        categories = BBQ;
    }
    else if ([self.CategoryName isEqualToString:@"Cafe"])
    {
        categories = CAFE;
    }
    else if ([self.CategoryName isEqualToString:@"Fast Food"])
    {
        categories = FASTFOOD;
    }
    else if ([self.CategoryName isEqualToString:@"Taste the World"]) //
    {
        categories = EAT_WORLD;
    }
    else if ([self.CategoryName isEqualToString:@"Vegan"])
    {
        categories = Vegan;
    }
    else if ([self.CategoryName isEqualToString:@"Around Me"])
    {
        categories = AROOUNDME;
    }
    else if ([self.CategoryName isEqualToString:@"Healthy Choice"])
    {
        categories = HEALTHY;
    }
    else if ([self.CategoryName isEqualToString:@"Bar"])
    {
        categories = BARS;
    }
    else if ([self.CategoryName isEqualToString:@"You gotta Eat here!"]) //-
    {
        categories = HIGH_RAT;
    }
    else if ([self.CategoryName isEqualToString:@"Desserts"])
    {
        categories = Deserts;
    }
    
    return categories;
    
}

#pragma mark - custom rating method

-(void)addRating:(int)rating
{
    
    switch (rating) {
        case 1:
            self.firstRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            
            break;
        case 2:
            self.firstRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            self.secondRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            
            break;
        case 3:
            self.firstRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            self.secondRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            self.thirdRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            
            break;
        case 4:
            self.firstRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            self.secondRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            self.thirdRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            self.fourthRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            
            break;
        case 5:
            self.firstRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            self.secondRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            self.thirdRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            self.fourthRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            self.fifthRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            
            break;
            
        default:
            break;
    }
}

#pragma mark tableview methods-



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    
    static NSString *propertyIdentifier = @"DashBoardCell";
    
    DashBoardCell *cell = (DashBoardCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier];
    
    if (cell == nil)
    {
        
        NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"DashBoardCell" owner:self options:nil];
        cell = [nib1 objectAtIndex:0];
    }
    
    static NSString *propertyIdentifier1 = @"RadomizeCellFirst";
    
    RadomizeCellFirst *cell1 = (RadomizeCellFirst *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier1];
    
    if (cell1 == nil)
    {
        
        NSArray *nib2 = [[NSBundle mainBundle] loadNibNamed:@"RadomizeCellFirst" owner:self options:nil];
        cell1 = [nib2 objectAtIndex:0];
    }
    
    if (indexPath.row==0)
    {
        cell1.restaurantName.text =[restaurantArray[indexPath.row]  valueForKey:@"name"];
        NSArray *addressArray = [[restaurantArray[indexPath.row]  valueForKey:@"location"] valueForKey:@"display_address"];
        cell1.restaurantAddress.text = [addressArray componentsJoinedByString:@""];
        cell1.categoryImage.image = categoryImage.image;
        BOOL isClosed = [[restaurantArray[indexPath.row]  valueForKey:@"is_closed"] boolValue];
        if (isClosed) {
            cell1.timeLable.text = @"Closed Now";
            
        } else {
            cell1.timeLable.text = @"Open Now";
        }
        int rate = roundf([[restaurantArray[indexPath.row]  valueForKey:@"rating"] intValue]);
        
        [self addRating1:cell1 :rate];
        [cell1.restaurantImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[restaurantArray[indexPath.row]  valueForKey:@"image_url"]]] placeholderImage:nil options:0 progress:nil completed:nil];
        cell1.whiteImage.alpha = 0.8;
        cell1.whiteImage.layer.cornerRadius = 5.0;
        cell1.restaurantImage.layer.cornerRadius = 5.0;
        cell1.restaurantImage.layer.masksToBounds = YES;
        cell1.whiteImage.layer.masksToBounds = YES;
        
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell1;
    }
    
    cell.restaurantName.text =[restaurantArray[indexPath.row]  valueForKey:@"name"];
    NSArray *addressArray = [[restaurantArray[indexPath.row]  valueForKey:@"location"] valueForKey:@"display_address"];
    cell.restaurantAddress.text = [addressArray componentsJoinedByString:@""];
    BOOL isClosed = [[restaurantArray[indexPath.row]  valueForKey:@"is_closed"] boolValue];
    if (isClosed) {
        cell.timeLable.text = @"Closed Now";
    } else {
        
        
        cell.timeLable.text = @"Open Now";
    }
    int rate = roundf([[restaurantArray[indexPath.row]  valueForKey:@"rating"] intValue]);
    
    [self addRating:cell :rate];
    [cell.restaurantImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[restaurantArray[indexPath.row]  valueForKey:@"image_url"]]] placeholderImage:nil options:0 progress:nil completed:nil];
    cell.whiteImage.alpha = 0.8;
    cell.whiteImage.layer.cornerRadius = 5.0;
    cell.restaurantImage.layer.cornerRadius = 5.0;
    cell.restaurantImage.layer.masksToBounds = YES;
    cell.whiteImage.layer.masksToBounds = YES;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return restaurantArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantDetailViewController *restaurantDetail =[self.storyboard instantiateViewControllerWithIdentifier:@"RestaurantDetailViewController"];
    restaurantDetail.restaurantId = [restaurantArray[indexPath.row]  valueForKey:@"id"];
    NSLog(@"%@",[restaurantArray[indexPath.row]  valueForKey:@"id"]);
    [self.navigationController pushViewController:restaurantDetail animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return 442;
    }
    return 414;
}

#pragma mark - custom rating method

-(void)addRating:(DashBoardCell *)cell :(int)rating
{
    
    switch (rating) {
        case 1:
            cell.firstRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            
            break;
        case 2:
            cell.firstRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            cell.secondRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            
            break;
        case 3:
            cell.firstRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            cell.secondRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            cell.thirdRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            
            break;
        case 4:
            cell.firstRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            cell.secondRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            cell.thirdRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            cell.fourthRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            
            break;
        case 5:
            cell.firstRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            cell.secondRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            cell.thirdRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            cell.fourthRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            cell.fifthRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            
            break;
            
        default:
            break;
    }
}

-(void)addRating1:(RadomizeCellFirst *)cell :(int)rating
{
    
    switch (rating) {
        case 1:
            cell.firstRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            
            break;
        case 2:
            cell.firstRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            cell.secondRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            
            break;
        case 3:
            cell.firstRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            cell.secondRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            cell.thirdRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            
            break;
        case 4:
            cell.firstRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            cell.secondRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            cell.thirdRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            cell.fourthRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            
            break;
        case 5:
            cell.firstRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            cell.secondRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            cell.thirdRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            cell.fourthRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            cell.fifthRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
            
            break;
            
        default:
            break;
    }
}

- (IBAction)spinAgainAction:(id)sender
{
    if(self.fromRandomPage)
    {
        [self.view removeFromSuperview];
    }
    else
    {
        [self callApiForCategory];
    }
}
- (IBAction)viewRestaurantDetail:(id)sender
{
    //    if(self.fromRandomPage)
    //    {
    RestaurantDetailViewController *restaurantDetail =[self.storyboard instantiateViewControllerWithIdentifier:@"RestaurantDetailViewController"];
    restaurantDetail.restaurantId = [Restaurantdict  valueForKey:@"id"];
    NSLog(@"%@",[Restaurantdict  valueForKey:@"id"]);
    [self.navigationController pushViewController:restaurantDetail animated:YES];
    //    }
    
}

-(void)showAlert
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Eat Here!"
                                 message:@"No data found"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    if (!self.fromRandomPage) {
                                         [self.tabBarController setSelectedIndex:0];
                                    } else {
                                         [self.view removeFromSuperview];
                                    }
                                    
                                    //vinay here- latest changes
                                   
                                }];
    
    //Add your buttons to alert controller
    
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end
