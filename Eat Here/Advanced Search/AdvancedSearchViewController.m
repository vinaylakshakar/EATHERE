

#import "AdvancedSearchViewController.h"
#import "EatHere.pch"
#import <QuartzCore/QuartzCore.h>

@interface AdvancedSearchViewController ()
{
    NSString *distance,*type,*typeTagValue;
    NSArray*  tags,*tag_alias_Array,*tag_original_Array;
    CGFloat height;
    NSMutableArray *selectedArry,*selectedIndexArray;
}

@end

@implementation AdvancedSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedArry = [[NSMutableArray alloc]init];
    selectedIndexArray = [[NSMutableArray alloc]init];
    distance = @"10000";
    type = @"";
    
    
    
    // Do any additional setup after loading the view.
    [self setLayOut];
    testytheWorld.layer.cornerRadius = 15;
    Healthychoice.layer.cornerRadius = 15;
    testytheWorld.clipsToBounds = YES;
    Healthychoice.clipsToBounds = YES;
    if(_selectedDic != nil)
    {
        [self selectDistance:[NSString stringWithFormat:@"%@",[_selectedDic objectForKey:@"radius"]]];
        [selectedArry removeAllObjects];
        [selectedIndexArray removeAllObjects];
        NSArray *arr = [[_selectedDic objectForKey:@"categories"] componentsSeparatedByString:@","];
        selectedArry  = [arr mutableCopy];
        selectedIndexArray = [_selectedDic objectForKey:@"SelectedCategory"];
        [self selectedFood:[_selectedDic objectForKey:@"TypeOfFood"]];
        
    } else {
        [self selectDistance:@"40000"];
        [selectedArry removeAllObjects];
        [selectedIndexArray removeAllObjects];
        [self selectedFood:@"41"];
       // selectedIndexArray = [_selectedDic objectForKey:@"SelectedCategory"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

-(void)setLayOut
{
    self.firstFilterImage.alpha = 0.1;
    self.firstFilterImage.layer.cornerRadius = 5.0;
    self.secondFilterImage.alpha = 0.1;
    self.secondFilterImage.layer.cornerRadius = 5.0;
    self.thirdFilterImage.alpha = 0.1;
    self.thirdFilterImage.layer.cornerRadius = 5.0;
    self.fourthFilterImage.alpha = 0.1;
    self.fourthFilterImage.layer.cornerRadius = 5.0;
    
    [self.scrollView setContentSize:CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height)];
    _tagContent.frame = CGRectMake(_tagContent.frame.origin.x, _tagContent.frame.origin.y, _tagContent.frame.size.width,  70);
    [self setTagView];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)setTagView
{
    //    NSArray*  tags = @[@"Music",@"Food",@"Sport",@"Travel",@"Art",@"Books",@"To do's",@"Fashion",@"Film & TV",@"News",@"Movies",@"History",@"Bucket List",@"DIY",@"Music",@"Food",@"Sport",@"Travel",@"Art",@"Books",@"To do's",@"Fashion",@"Film & TV",@"News",@"Movies",@"History",@"Bucket List",@"DIY",@"Music",@"Food",@"Sport",@"Travel",@"Art",@"Books",@"To do's",@"Fashion",@"Film & TV",@"News",@"Movies",@"History",@"Bucket List",@"DIY",@"Music",@"Food",@"Sport",@"Travel",@"Art",@"Books",@"To do's",@"Fashion",@"Film & TV",@"News",@"Movies",@"History",@"Bucket List",@"DIY"];
    
    [_tagView removeAllTags];
    _tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    
    TTGTextTagConfig *config = [TTGTextTagConfig new];
    //    config.tagTextFont = [UIFont systemFontOfSize:15];
    
    // config.tagTextColor = DARKBULE_COLOR;
    config.tagTextColor = [UIColor blackColor];
    config.tagSelectedTextColor = [UIColor whiteColor];
    config.tagExtraSpace = CGSizeMake(15, 15);
    config.tagCornerRadius = 13;
    config.tagSelectedCornerRadius = 13;
    
    
    NSUInteger location = 0;
    NSUInteger length = tags.count;
    //  config.tagBackgroundColor = PURPLE_COLOR_Category;
    config.tagShadowOpacity = 0.0;
    config.tagBorderColor = [UIColor clearColor];
    config.tagSelectedBorderColor = [UIColor clearColor];
    config.tagBackgroundColor = [UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1.0];
    config.tagSelectedBackgroundColor = [UIColor colorWithRed:0.98 green:0.29 blue:0.14 alpha:1.0];
    //    config.tagTextFont = [UIFont fontWithName:@"SFProText-Regular" size:13];
    config.tagTextFont = [UIFont systemFontOfSize:13];
    config.extraData = @{@"key": @"1"};
    [_tagView addTags:[tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[config copy]];
    if(selectedIndexArray)
    {
        for (int i=0; i<selectedIndexArray.count; i++) {
            int selectedInt = [[selectedIndexArray objectAtIndex:i] intValue];
            [_tagView setTagAtIndex:selectedInt selected:YES];
        }
    }
    
    
    
    [_tagView setShowsHorizontalScrollIndicator:NO];
    [_tagView setShowsVerticalScrollIndicator:NO];
    
    _tagView.delegate = self;
    
    _tagContent.frame = CGRectMake(_tagContent.frame.origin.x, _tagContent.frame.origin.y, _tagContent.frame.size.width,  _tagContent.frame.size.height-height);
    height = _tagView.contentSize.height;
    _tagContent.frame = CGRectMake(_tagContent.frame.origin.x, _tagContent.frame.origin.y, _tagContent.frame.size.width, height+ _tagContent.frame.size.height);
    _tagView.frame = CGRectMake(_tagView.frame.origin.x, _tagContent.frame.origin.y+50, _tagView.frame.size.width,height);
    self.firstFilterImage.frame = CGRectMake(self.firstFilterImage.frame.origin.x, self.firstFilterImage.frame.origin.y, _tagView.frame.size.width,height);
    
    if (tags==nil) {
        [self.firstFilterImage setHidden:YES];
        [self.subcategoryLable setHidden:YES];
    }else
    {
        [self.firstFilterImage setHidden:NO];
        [self.subcategoryLable setHidden:NO];
    }
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height+height)];
    [self.scrollView addSubview:self.searchBtn];
    [self.scrollView addSubview:self.tagView];
    _searchBtn.frame = CGRectMake(self.searchBtn.frame.origin.x, _tagContent.frame.origin.y+_tagContent.frame.size.height, _searchBtn.frame.size.width,self.searchBtn.frame.size.height);
    _tagView.frame = CGRectMake(self.tagView.frame.origin.x, _tagContent.frame.origin.y+50, self.tagView.frame.size.width,self.tagView.frame.size.height);
    self.firstFilterImage.frame = CGRectMake(self.firstFilterImage.frame.origin.x, self.firstFilterImage.frame.origin.y, _tagView.frame.size.width+30,height+60);
    
}

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    didTapTag:(NSString *)tagText
                      atIndex:(NSUInteger)index
                     selected:(BOOL)selected
                    tagConfig:(TTGTextTagConfig *)config
{
    //    [_tagView removeAllTags];
    //    [self setTagView];
    NSString * tagName = [tags objectAtIndex:index];
    int indexVal = (int)[tag_original_Array indexOfObject:tagName];
    
    NSString * alias = [tag_alias_Array objectAtIndex:indexVal];
    if ([selectedArry containsObject:alias])
    {
        [_tagView setTagAtIndex:index selected:NO];
        [selectedArry removeObject:alias];
        [selectedIndexArray removeObject:[NSString stringWithFormat:@"%lu",(unsigned long)index]];
    } else {
        [_tagView setTagAtIndex:index selected:YES];
        [selectedArry addObject:alias];
        [selectedIndexArray addObject:[NSString stringWithFormat:@"%lu",(unsigned long)index]];
    }
    if(selectedArry.count>=1)
    {
        // enable
        [_searchBtn setSelected:true];
        [_searchBtn setEnabled:true];
    }
    else{
        //disable
        [_searchBtn setSelected:false];
        [_searchBtn setEnabled:false];
    }
    
    
}

- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

//- (IBAction)visitTimeAction:(id)sender
//{
//
//    for (int i = 11; i<=14; i++) {
//        UIButton *visitTimeBtn = [self.view viewWithTag:i];
//        [visitTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [visitTimeBtn setSelected:NO];
//    }
//
//     UIButton *visitTimeBtn = [self.view viewWithTag:[sender tag]];
//    [visitTimeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//    [visitTimeBtn setSelected:YES];
//}
//
//- (IBAction)spendTimeAction:(id)sender
//{
//    for (int i = 21; i<=24; i++) {
//        UIButton *visitTimeBtn = [self.view viewWithTag:i];
//        [visitTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [visitTimeBtn setSelected:NO];
//    }
//
//
//    UIButton *spendTimeBtn = [self.view viewWithTag:[sender tag]];
//    [spendTimeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//    [spendTimeBtn setSelected:YES];
//}

- (IBAction)restaurantDistance:(id)sender
{
    for (int i = 31; i<=34; i++) {
        UIButton *visitTimeBtn = [self.view viewWithTag:i];
        [visitTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [visitTimeBtn setSelected:NO];
    }
    
    UIButton *DistanceBtn = [self.view viewWithTag:[sender tag]];
    [DistanceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [DistanceBtn setSelected:YES];
    
    if ([sender tag]==31)
    {
        distance =@"40000";
    } else if ([sender tag]==32)
    {
        distance =@"5000";
    } else if ([sender tag]==33)
    {
        distance =@"10000";
    }else
    {
        distance =@"20000";
    }
    
    //vinay here-
    if ((![distance isEqualToString:@"40000"] && [type isEqualToString:@""]) || selectedArry.count>0) {
        //enable
        [_searchBtn setSelected:true];
        [_searchBtn setEnabled:true];
    }else{
        //disable
        [_searchBtn setSelected:false];
        [_searchBtn setEnabled:false];
    }
}

-(void)selectDistance:(NSString *)radius
{
    for (int i = 31; i<=34; i++) {
        UIButton *visitTimeBtn = [self.view viewWithTag:i];
        [visitTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [visitTimeBtn setSelected:NO];
    }
    
    if ([radius isEqualToString:@"40000"])
    {
        UIButton *DistanceBtn = [self.view viewWithTag:31];
        [DistanceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [DistanceBtn setSelected:YES];
        distance =@"40000";
        
    } else if ([radius isEqualToString:@"5000"])
    {
        UIButton *DistanceBtn = [self.view viewWithTag:32];
        [DistanceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [DistanceBtn setSelected:YES];
        distance =@"5000";
        
    } else if ([radius isEqualToString:@"10000"])
    {
        UIButton *DistanceBtn = [self.view viewWithTag:33];
        [DistanceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [DistanceBtn setSelected:YES];
        distance =@"10000";
        
    }else
    {
        UIButton *DistanceBtn = [self.view viewWithTag:34];
        [DistanceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [DistanceBtn setSelected:YES];
        distance =@"20000";
    }
}



- (IBAction)restaurantType:(id)sender
{
    for (int i = 41; i<=49; i++) {
        UIButton *visitTimeBtn = [self.view viewWithTag:i];
        [visitTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [visitTimeBtn setSelected:NO];
        if(i == 43 ||i == 49)
        {
            [visitTimeBtn setBackgroundColor:[UIColor colorWithRed:(149.0 / 255.0) green:(149.0 / 255.0)
                                                              blue:(149.0 / 255.0) alpha: 1]];
        }
        
    }
    
    
    
    UIButton *TypeBtn = [self.view viewWithTag:[sender tag]];
    [TypeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [TypeBtn setSelected:YES];
    if([sender tag] == 43 ||[sender tag] == 49)
    {
        [TypeBtn setBackgroundColor:[UIColor colorWithRed:(249.0 / 255.0) green:(73.0 / 255.0)
                                                     blue:(36.0 / 255.0) alpha: 1]];
    }
    
    if ([sender tag]==41)
    {
        type =@"";
        tags= nil;
        typeTagValue = @"41";
        //vinay here-
        //disable
        [_searchBtn setSelected:false];
        [_searchBtn setEnabled:false];
    } else if ([sender tag]==42)
    {
        type =@"BBQ";
        typeTagValue = @"42";
        tags = [self returnSortedAlphabetically:[Utility convertString:BBQ_title]];
        tag_alias_Array = [Utility convertString:BBQ];
        tag_original_Array =[Utility convertString:BBQ_title];
    } else if ([sender tag]==43)
    {
        type =@"Taste the World";
        typeTagValue = @"43";
        tags = [self returnSortedAlphabetically:[Utility convertString:EAT_WORLD_title]];
        tag_alias_Array = [Utility convertString:EAT_WORLD];
        tag_original_Array =[Utility convertString:EAT_WORLD_title];
    }if ([sender tag]==44)
    {
        type =@"Bar";
        typeTagValue = @"44";
        tags = [self returnSortedAlphabetically:[Utility convertString:BARS_title]];
        tag_alias_Array = [Utility convertString:BARS];
        tag_original_Array =[Utility convertString:BARS_title];
    } else if ([sender tag]==45)
    {
        type =@"Cafe";
        typeTagValue = @"45";
        tags = [self returnSortedAlphabetically:[Utility convertString:CAFE_title]];
        tag_alias_Array = [Utility convertString:CAFE];
        tag_original_Array =[Utility convertString:CAFE_title];
    } else if ([sender tag]==46)
    {
        type =@"Desserts";
        typeTagValue = @"46";
        tags = [self returnSortedAlphabetically:[Utility convertString:Deserts_title]];
        tag_alias_Array = [Utility convertString:Deserts];
        tag_original_Array =[Utility convertString:Deserts_title];
    } else if ([sender tag]==47)
    {
        type =@"Fast Food";
        typeTagValue = @"47";
        tags = [self returnSortedAlphabetically:[Utility convertString:FASTFOOD_title]];
        tag_alias_Array = [Utility convertString:FASTFOOD];
        tag_original_Array =[Utility convertString:FASTFOOD_title];
    } else if ([sender tag]==48)
    {
        type =@"Vegan";
        typeTagValue = @"48";
        tags = [self returnSortedAlphabetically:[Utility convertString:Vegan_title]];
        tag_alias_Array = [Utility convertString:Vegan];
        tag_original_Array =[Utility convertString:Vegan_title];
    }else if ([sender tag]==49)
    {
        type =@"Healthy Choice";
        typeTagValue = @"49";
        tags = [self returnSortedAlphabetically:[Utility convertString:HEALTHY_title]];
        tag_alias_Array = [Utility convertString:HEALTHY];
        tag_original_Array =[Utility convertString:HEALTHY_title];
    }
    
   // [self setTagView];
    [selectedArry removeAllObjects];
    [selectedIndexArray removeAllObjects];
    [self setTagView];
    
    //vinay here-
    if (![distance isEqualToString:@"40000"] && [type isEqualToString:@""]) {
        //enable
        [_searchBtn setSelected:true];
        [_searchBtn setEnabled:true];
    }else{
        //disable
        [_searchBtn setSelected:false];
        [_searchBtn setEnabled:false];
    }
}

-(void)selectedFood:(NSString *)tag
{
    int typeTag = [tag intValue];
    for (int i = 41; i<=49; i++) {
        UIButton *visitTimeBtn = [self.view viewWithTag:i];
        [visitTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [visitTimeBtn setSelected:NO];
    }
    
    UIButton *TypeBtn = [self.view viewWithTag:typeTag];
    [TypeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [TypeBtn setSelected:YES];
    
    if (typeTag==41)
    {
        type =@"";
        tags= nil;
        typeTagValue = @"41";
    } else if (typeTag==42)
    {
        type =@"BBQ";
        typeTagValue = @"42";
        tags = [self returnSortedAlphabetically:[Utility convertString:BBQ_title]];
        tag_alias_Array = [Utility convertString:BBQ];
        tag_original_Array =[Utility convertString:BBQ_title];
    } else if (typeTag==43)
    {
        type =@"Taste the World";
        typeTagValue = @"43";
        tags = [self returnSortedAlphabetically:[Utility convertString:EAT_WORLD_title]];
        tag_alias_Array = [Utility convertString:EAT_WORLD];
        tag_original_Array =[Utility convertString:EAT_WORLD_title];
    }if (typeTag==44)
    {
        type =@"Bar";
        typeTagValue = @"44";
        tags = [self returnSortedAlphabetically:[Utility convertString:BARS_title]];
        tag_alias_Array = [Utility convertString:BARS];
        tag_original_Array =[Utility convertString:BARS_title];
    } else if (typeTag==45)
    {
        type =@"Cafe";
        typeTagValue = @"45";
        tags = [self returnSortedAlphabetically:[Utility convertString:CAFE_title]];
        tag_alias_Array = [Utility convertString:CAFE];
        tag_original_Array =[Utility convertString:CAFE_title];
    } else if (typeTag==46)
    {
        type =@"Desserts";
        typeTagValue = @"46";
        tags = [self returnSortedAlphabetically:[Utility convertString:Deserts_title]];
        tag_alias_Array = [Utility convertString:Deserts];
        tag_original_Array =[Utility convertString:Deserts_title];
    } else if (typeTag==47)
    {
        type =@"Fast Food";
        typeTagValue = @"47";
        tags = [self returnSortedAlphabetically:[Utility convertString:FASTFOOD_title]];
        tag_alias_Array = [Utility convertString:FASTFOOD];
        tag_original_Array =[Utility convertString:FASTFOOD_title];
    } else if (typeTag==48)
    {
        type =@"Vegan";
        typeTagValue = @"48";
        tags = [self returnSortedAlphabetically:[Utility convertString:Vegan_title]];
        tag_alias_Array = [Utility convertString:Vegan];
        tag_original_Array =[Utility convertString:Vegan_title];
    }else if (typeTag==49)
    {
        type =@"Healthy Choice";
        typeTagValue = @"49";
        tags = [self returnSortedAlphabetically:[Utility convertString:HEALTHY_title]];
        tag_alias_Array = [Utility convertString:HEALTHY];
        tag_original_Array = [Utility convertString:HEALTHY_title];
    }
    
    [self setTagView];
}

-(NSArray *)returnSortedAlphabetically:(NSArray*)array
{
    NSArray *sortedArray = [array sortedArrayUsingSelector:
                            @selector(localizedCaseInsensitiveCompare:)];
    return sortedArray;
}

- (IBAction)advanceSearch:(id)sender
{
    
    // NSArray *selectedArry = [_tagView allSelectedTags];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    if ([type isEqualToString:@""]&&[distance isEqualToString:@"40000"] )
    {
        //vinay here-
       // [Utility showAlertMessage:nil message:@"Please Select The Category!"];
    }
    
    else if (selectedArry.count==0&&![type isEqualToString:@""])
    {
        [Utility showAlertMessage:nil message:@"Please Select The Subcategory!"];
    }
    else
    {
        if ([type isEqualToString:@""]) {
            [dict setObject:@"restaurants,food" forKey:@"categories"];
        } else {
            
            if (selectedArry.count==0) {
                [dict setObject:type forKey:@"categories"];
            } else {

                [dict setObject:[selectedArry componentsJoinedByString:@","] forKey:@"categories"];
            }
            
        }
        [dict setObject:@"restaurants" forKey:@"term"];
        
        //vinay here-
        if ([distance isEqualToString:@"40000"]) {
            distance = @"15000";
        }
        
        [dict setObject:distance forKey:@"radius"];
        [dict setObject:typeTagValue forKey:@"TypeOfFood"];
        [dict setObject:selectedIndexArray forKey:@"SelectedCategory"];
        
        [dict setObject:@"50" forKey:@"limit"];
        [dict setObject:[USERDEFAULTS valueForKey:AddressLatitude] forKey:@"latitude"];
        [dict setObject:[USERDEFAULTS valueForKey:AddressLongitude] forKey:@"longitude"];
        [dict setObject:@"distance" forKey:@"sort_by"];
        
        NSLog(@"dict %@",dict);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"advanceSearch" object:self userInfo:dict];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}
@end
