//
//  FoodFinderViewController.m
//  Eat Here
//
//  Created by Silstone on 03/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "FoodFinderViewController.h"
#import "EatHere.pch"

@interface FoodFinderViewController ()
{
    NSMutableArray *CategoryImageArray;
}

@end

@implementation FoodFinderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    offsetLimit = 0;
    restaurantArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner stopAnimating];
    spinner.hidesWhenStopped = YES;
    spinner.frame = CGRectMake(0, 0, 320, 44);
    self.foodFinderTable.tableFooterView = spinner;
    
    
    NSLog(@"%@",self.selectedArray);
   // CategoryImageArray = [[NSMutableArray alloc]initWithObjects:@"bbq_big",@"bar_big",@"healthy_big",@"cafe_big", nil];
    CategoryImageArray = [[NSMutableArray alloc]initWithArray:self.selectedCategory];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CategoryCell" bundle:nil] forCellWithReuseIdentifier:@"CategoryCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self foodFinderListing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark collectionview methods-
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return CategoryImageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCell" forIndexPath:indexPath];
    cell.categoryImage.image =[Utility GetImageFromcategoryName:[CategoryImageArray objectAtIndex:indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.frame.size.height-20, collectionView.frame.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 15;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    
}

- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableview methods-


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return restaurantArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    static NSString *propertyIdentifier = @"DashBoardCell";
    
    DashBoardCell *cell = (DashBoardCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier];
    
    if (cell == nil)
    {
        
        NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"DashBoardCell" owner:self options:nil];
        cell = [nib1 objectAtIndex:0];
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
    [cell.restaurantImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[restaurantArray[indexPath.row]  valueForKey:@"image_url"]]] placeholderImage:[UIImage imageNamed:@"list_placeholder"] options:0 progress:nil completed:nil];
    cell.whiteImage.alpha = 0.8;
    cell.whiteImage.layer.cornerRadius = 5.0;
    cell.restaurantImage.layer.cornerRadius = 5.0;
    cell.restaurantImage.layer.masksToBounds = YES;
    cell.whiteImage.layer.masksToBounds = YES;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantDetailViewController *restaurantDetail =[self.storyboard instantiateViewControllerWithIdentifier:@"RestaurantDetailViewController"];
    restaurantDetail.restaurantId = [restaurantArray[indexPath.row]  valueForKey:@"id"];
    NSLog(@"%@",[restaurantArray[indexPath.row]  valueForKey:@"id"]);
    [self.navigationController pushViewController:restaurantDetail animated:YES];
    
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
        
        offsetLimit =offsetLimit+50;
        [self foodFinderListing];
        
    }
}

-(void)foodFinderListing
{
    NSString *strCategories;
    if (self.selectedCategory.count==1&&[self.selectedCategory containsObject:@"Around Me"]) {
        strCategories= @"food";
    } else {
       
        NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:self.selectedArray];
        NSArray *arrayWithoutDuplicates = [orderedSet array];
         strCategories = [arrayWithoutDuplicates componentsJoinedByString:@","];
    }
    
  
//    for (int i=0; i<self.selectedArray.count; i++) {
//        if(str.length>=1)
//        {
//            str = [NSString stringWithFormat: @"%@,%@",str,[self getCategoriesString:[self.selectedArray objectAtIndex:i]]];
//        }
//        else{
//            str = [NSString stringWithFormat: @"%@",[self getCategoriesString:[self.selectedArray objectAtIndex:i]]];
//        }
//    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"restaurants" forKey:@"term"];
    [dict setObject:strCategories forKey:@"categories"];
    [dict setObject:@"10000" forKey:@"radius"];   //40000 change to 10000
    [dict setObject:@"50" forKey:@"limit"];
    [dict setObject:[USERDEFAULTS valueForKey:AddressLatitude] forKey:@"latitude"];
    [dict setObject:[USERDEFAULTS valueForKey:AddressLongitude] forKey:@"longitude"];

    //distance in heigh priority-
    
    if ([self.selectedCategory containsObject:@"Around Me"]&&[self.selectedCategory containsObject:@"You gotta Eat here!"])
    {

        [dict setObject:@"distance" forKey:@"sort_by"];  // change rating to Distance
    } else if ([self.selectedCategory containsObject:@"Around Me"])
    {

        [dict setObject:@"distance" forKey:@"sort_by"];
    }else if ([self.selectedCategory containsObject:@"You gotta Eat here!"])
    {
        [dict setObject:@"distance" forKey:@"sort_by"];    // change rating to Distance
    }else
    {
        [dict setObject:@"distance" forKey:@"sort_by"];
    }

    
    [self restaurantListing:dict];
    
}

-(void)restaurantListing:(NSMutableDictionary*)dict
{
    NSString *offsetStr = [NSString stringWithFormat:@"%d",offsetLimit];
    [dict setObject:offsetStr forKey:@"offset"];
    
    NSLog(@"%@",dict);
    
    if (offsetLimit==0) {
        [restaurantArray removeAllObjects];
        [kAppDelegate showProgressHUD];
    }
    
    
    [[NetworkEngine sharedNetworkEngine]DashboardListingForFinder:^(id object)
     {
         
         // NSLog(@"%@",object);
         
         if ([object valueForKey:@"businesses"])
         {
             {
                 NSMutableArray *arr = [object valueForKey:@"businesses"];
                 if(arr.count>=1)
                 {
                 for (int i=0; i<arr.count; i++) {
                     [restaurantArray addObject:[arr objectAtIndex:i]];
                 }
                 [self.foodFinderTable reloadData];
                 }
                 else{
                     [self showAlert];
                 }
             }
             [spinner stopAnimating];
         }
         
         if (offsetLimit==0) {
             [kAppDelegate hideProgressHUD];
         }
         
         
         
     }
                                                 onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
    
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

- (IBAction)showDetailBtn:(id)sender
{
    //    RestaurantDetailViewController *restaurantDetail =[self.storyboard instantiateViewControllerWithIdentifier:@"RestaurantDetailViewController"];
    //    restaurantDetail.restaurantId = [restaurantArray[viewTag]  valueForKey:@"id"];
    //    [self.navigationController pushViewController:restaurantDetail animated:YES];
}

-(NSString *)getCategoriesString:(NSString *)name
{
    NSString *categories;
    if([name isEqualToString:@"BBQ"])
    {
        categories = BBQ;
    }
    else if ([name isEqualToString:@"Cafe"])
    {
        categories = CAFE;
    }
    else if ([name isEqualToString:@"Fast Food"])
    {
        categories = FASTFOOD;
    }
    else if ([name isEqualToString:@"Taste the World"]) //
    {
        categories = EAT_WORLD;
    }
    else if ([name isEqualToString:@"Vegan"])
    {
        categories = Vegan;
    }
    else if ([name isEqualToString:@"Around Me"])
    {
        categories = AROOUNDME;
    }
    else if ([name isEqualToString:@"Healthy Choice"])
    {
        categories = HEALTHY;
    }
    else if ([name isEqualToString:@"Bar"])
    {
        categories = BARS;
    }
    else if ([name isEqualToString:@"You gotta Eat here!"]) //-
    {
        categories = HIGH_RAT;
    }
    else if ([name isEqualToString:@"Desserts"])
    {
        categories = Deserts;
    }
    
    return categories;
    
}

-(void)showAlert
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Eat Here!"
                                 message:@"No restaurant found"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                 //  [self.navigationController popViewControllerAnimated:YES];
                                }];
    
    //Add your buttons to alert controller
    
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
