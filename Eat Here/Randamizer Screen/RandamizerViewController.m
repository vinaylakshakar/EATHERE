//
//  RandamizerViewController.m
//  Eat Here
//
//  Created by Silstone on 01/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "RandamizerViewController.h"
#import "EatHere.pch"
#import "RandamizeDetailViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface RandamizerViewController ()<SMWheelControlDelegate, SMWheelControlDataSource>
{
    CGRect frame;
    NSMutableArray *CategoryNameArray,*CategoryImageArray,*selectedCategory;
    SMWheelControl *wheelFirst;
}
@property (nonatomic, weak) SMWheelControl *wheel;

@end

@implementation RandamizerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    selectedCategory = [[NSMutableArray alloc]init];
    CategoryNameArray = [Utility convertString:AllCategories];
    CategoryImageArray = [[NSMutableArray alloc]initWithObjects:@"bbq",@"cafe",@"fast_food",@"taste_the_world",@"vegan",@"around_me",@"healthy_choice",@"bar",@"you_got_a_eat_here",@"desserts", nil];


    frame = self.lineView.frame;
    [self.randamizerBtn setSelected:YES];
    self.categoryTable.tableFooterView = self.footerView;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"StopWheel"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeSuperView" object:self userInfo:nil];
    wheelFirst = [[SMWheelControl alloc] initWithFrame:self.wheelContainer.bounds];
    [wheelFirst addTarget:self action:@selector(wheelDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    [wheelFirst insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]] atIndex:0];
    wheelFirst.delegate = self;
    wheelFirst.dataSource = self;
    [wheelFirst reloadData];
    [self.wheelContainer addSubview:wheelFirst];
    self.wheel = wheelFirst;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Randomizer view");
    
    
}

- (void)receiveNotification:(NSNotification *)notification
{
//    wheelFirst = [[SMWheelControl alloc] initWithFrame:self.wheelContainer.bounds];
//    [wheelFirst addTarget:self action:@selector(wheelDidChangeValue:) forControlEvents:UIControlEventValueChanged];
//    [wheelFirst insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]] atIndex:0];
//    wheelFirst.delegate = self;
//    wheelFirst.dataSource = self;
//    [wheelFirst setRotationDisabled:YES];
    
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
    return CategoryNameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    
    static NSString *propertyIdentifier = @"SelectCategoryCell";
    
    SelectCategoryCell *cell = (SelectCategoryCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier];
    
    if (cell == nil)
    {
        
        NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"SelectCategoryCell" owner:self options:nil];
        cell = [nib1 objectAtIndex:0];
    }
    cell.categoryName.text = CategoryNameArray[indexPath.row];
    cell.categoryImage.image =[UIImage imageNamed:[CategoryImageArray objectAtIndex:indexPath.row]];
    
    if ([selectedCategory containsObject:CategoryNameArray[indexPath.row]])
    {
        [cell.categoryBtn setSelected:YES];
    } else {
        [cell.categoryBtn setSelected:NO];
    }
    
    cell.categoryBtn.tag = indexPath.row;
    [cell.categoryBtn addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 54;
//}

-(void)selectCategory:(UIButton*)sender
{
    NSString *categoryName = [CategoryNameArray objectAtIndex:[sender tag]];
    
    if (![selectedCategory containsObject:categoryName]) {
        [selectedCategory addObject:categoryName];
        [sender setSelected:YES];
    } else {
        [selectedCategory removeObject:categoryName];
        [sender setSelected:NO];
    }
    
    if (selectedCategory.count>0) {
        [self.findRestaurantBtn setEnabled:YES];
    }else
    {
        [self.findRestaurantBtn setEnabled:NO];
    }
    
}


#pragma mark - Wheel delegate

- (void)wheelDidEndDecelerating:(SMWheelControl *)wheel
{
    if([self.randamizerBtn isSelected])
    {
        self.valueLabel.text = [NSString stringWithFormat:@"Selected index: %lu", (unsigned long)self.wheel.selectedIndex];
        NSLog(@"%@",[CategoryNameArray objectAtIndex:self.wheel.selectedIndex]);
        [self ShowDetail:[CategoryNameArray objectAtIndex:self.wheel.selectedIndex]];
    }
}

- (void)wheel:(SMWheelControl *)wheel didRotateByAngle:(CGFloat)angle
{
//     [player stop];
//    NSLog(@"%f",angle);
//    player.rate = 1.0; ///< Playback Speed
//    [player play];
    
}

#pragma mark - Wheel dataSource

- (NSUInteger)numberOfSlicesInWheel:(SMWheelControl *)wheel
{
    return 10;
}

- (UIView *)wheel:(SMWheelControl *)wheel viewForSliceAtIndex:(NSUInteger)index
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@" %lu", (unsigned long)index];
    return label;
}

#pragma mark - Wheel Control

- (void)wheelDidChangeValue:(id)sender
{
    
    
}

- (CGFloat)snappingAngleForWheel:(id)sender
{
    return M_PI / 2;
}

- (IBAction)foodFinderAction:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.lineView.frame = CGRectMake(frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
        [sender setSelected:YES];
        [self.randamizerBtn setSelected:NO];
        [self.categoryTable setHidden:NO];
        
    }completion:^(BOOL finished) {
        //        ...
//         [wheelFirst setRotationDisabled:YES];
        
    }];
}

- (IBAction)randamizerAction:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.lineView.frame = frame;
        [sender setSelected:YES];
        [self.foodFinderBtn setSelected:NO];
        [self.categoryTable setHidden:YES];
        //        ...
        
    }completion:^(BOOL finished) {
        //        ...
        
    }];
}
- (IBAction)findRestaurant:(id)sender
{
    
    NSLog(@"selectedCategory %@",selectedCategory);
    FoodFinderViewController *foodFinder =[self.storyboard instantiateViewControllerWithIdentifier:@"FoodFinderViewController"];
    foodFinder.selectedArray = [self addSubcategoryFromCategory:selectedCategory];
    foodFinder.selectedCategory = selectedCategory;
    //NSLog(@"added subcategory -%@",[self addSubcategoryFromCategory:selectedCategory]);
    [self.navigationController pushViewController:foodFinder animated:YES];
    
}

-(NSMutableArray*)addSubcategoryFromCategory:(NSMutableArray*)selectedCategory
{
//    @"bbq",@"cafe",@"fast_food",@"taste_the_world",@"vegan",@"around_me",@"healthy_choice",@"bar",@"you_got_a_eat_here",@"deserts",
    NSMutableArray *appendSubCategory = [[NSMutableArray alloc]init];
    for (NSString *category in selectedCategory) {
        
        if ([category isEqualToString:@"BBQ"]) {
            [appendSubCategory addObjectsFromArray:[Utility convertString:BBQ]];
        }
        if ([category isEqualToString:@"Cafe"]) {
            [appendSubCategory addObjectsFromArray:[Utility convertString:CAFE]];
        }
        if ([category isEqualToString:@"Fast Food"]) {
             [appendSubCategory addObjectsFromArray:[Utility convertString:FASTFOOD]];
        }
        if ([category isEqualToString:@"Taste the World"]) {
             [appendSubCategory addObjectsFromArray:[Utility convertString:EAT_WORLD]];
        }
        if ([category isEqualToString:@"Vegan"]) {
             [appendSubCategory addObjectsFromArray:[Utility convertString:Vegan]];
        }
//        if ([category isEqualToString:@"Around Me"]) {
//             [appendSubCategory addObjectsFromArray:[Utility convertString:AROOUNDME]];
//        }
        if ([category isEqualToString:@"Healthy Choice"]) {
             [appendSubCategory addObjectsFromArray:[Utility convertString:HEALTHY]];
        }
        if ([category isEqualToString:@"Bar"]) {
             [appendSubCategory addObjectsFromArray:[Utility convertString:BARS]];
        }
        if ([category isEqualToString:@"You gotta Eat here!"]) {
             [appendSubCategory addObjectsFromArray:[Utility convertString:HIGH_RAT]];
        }
        if ([category isEqualToString:@"Desserts"]) {
             [appendSubCategory addObjectsFromArray:[Utility convertString:Deserts]];
        }
    }
    
    return appendSubCategory;
}




-(void)ShowDetail:(NSString *)CategoryName
{
    RandamizeDetailViewController *foodFinder =[self.storyboard instantiateViewControllerWithIdentifier:@"RandamizeDetailViewController"];
    foodFinder.fromRandomPage = true;
    foodFinder.CategoryName = CategoryName;
    [self addChildViewController:foodFinder];
    [self.view addSubview:foodFinder.view];
    [foodFinder didMoveToParentViewController:self];
    
}
@end
