

#import "DashBoardViewController.h"
#import <objc/runtime.h>


#define latitude_Zoom 0.9
#define longitude_Zoom 0.9

@implementation DashBoardViewController
@synthesize locationManager;
- (void)viewDidLoad {
    [super viewDidLoad];
    Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
    UILabel *placeholderLabel = object_getIvar(_searchField, ivar);
    placeholderLabel.textColor = [UIColor whiteColor];
    
    self.mapView.showsPointsOfInterest = NO;
    myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.tabBarController setSelectedIndex:myAppDelegate.selectedTab];
    offsetLimit =0;
    restaurantArray = [[NSMutableArray alloc]init];
    mainRestaurantArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner stopAnimating];
    spinner.hidesWhenStopped = YES;
    spinner.frame = CGRectMake(0, 0, 320, 44);
    
    //vinay here-
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delegate = self;
    [self.mapView addGestureRecognizer:singleTap];
    
    dashBoardTable.tableFooterView = spinner;
    self.annotationDetailView.layer.cornerRadius = 5.0;
    self.annotationDetailView.layer.masksToBounds = YES;
    [self.searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    UIButton *clearButton = [self.searchField valueForKey:@"_clearButton"];
    [clearButton setBackgroundImage:[UIImage imageNamed:@"clear_search"] forState:UIControlStateNormal];
    
    Clatitude = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:AddressLatitude]];
    Clongitude = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:AddressLongitude]];
    [self loadAllArry];
    [self CurrentLocationIdentifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"advanceSearch"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UpdateWithZipCode:)
                                                 name:@"UpdateWithZipCode"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectNewsFeed:)
                                                 name:@"selectNewsFeed"
                                               object:nil];
}
- (void)selectNewsFeed:(NSNotification *)notification{
    [self.tabBarController setSelectedIndex:3];
}

- (void)UpdateWithZipCode:(NSNotification *)notification
{
    Clatitude = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:AddressLatitude]];
    Clongitude = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:AddressLongitude]];
    MKCoordinateRegion region = self.mapView.region;
    region.center = CLLocationCoordinate2DMake([Clatitude doubleValue], [Clongitude doubleValue]);
    region.span.longitudeDelta = longitude_Zoom; // Bigger the value, closer the map view
    region.span.latitudeDelta = latitude_Zoom;
    [self.mapView setRegion:region animated:YES];
    [self initViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    Clatitude = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:AddressLatitude]];
    Clongitude = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:AddressLongitude]];
    [self.searchView setHidden:YES];
    [self.view endEditing:YES];
    myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myAppDelegate.selectedTab = 0;
    //vinay here-
    [self setListUnselected];
}

-(void)setListUnselected{
    [self.flipBtn setSelected:NO];
    [dashBoardTable setHidden:YES];
     [emptyLbl setHidden:YES];
    [animationView setHidden:YES];
    [self StopLottieAnimation];
    [self.flipImage setImage:[UIImage imageNamed:@"Group 789"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer
                         :(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)CurrentLocationIdentifier
{
    geocoder = [[CLGeocoder alloc] init];
    if (locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
    }
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusDenied:
                NSLog(@"HH: kCLAuthorizationStatusDenied");
                [Utility showAlertMessage:@"App Permission Denied" message:@"You have disabled your location services to enable it again please go to  Settings > Eathere > Location."];
                [self initViews];
                
                break;
            case kCLAuthorizationStatusRestricted:
                NSLog(@"HH: kCLAuthorizationStatusRestricted");
                
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
                NSLog(@"HH: kCLAuthorizationStatusAuthorizedAlways");
                if([[USERDEFAULTS objectForKey:AppKilled] isEqualToString:@"true"])
                {
                    [USERDEFAULTS setObject:@"false" forKey:AppKilled];
                    [USERDEFAULTS synchronize];
//                    [self initViews];
                    [locationManager requestWhenInUseAuthorization];
                    [locationManager startUpdatingLocation];
                }
                else{
                    [locationManager requestWhenInUseAuthorization];
                    [locationManager startUpdatingLocation];
                }
                
                
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                NSLog(@"HH: kCLAuthorizationStatusAuthorizedWhenInUse");
                
                if([[USERDEFAULTS objectForKey:AppKilled] isEqualToString:@"true"])
                {
                    [USERDEFAULTS setObject:@"false" forKey:AppKilled];
                    [USERDEFAULTS synchronize];
//                     [self initViews];
                    [locationManager requestWhenInUseAuthorization];
                    [locationManager startUpdatingLocation];
                }
                else{
                    [locationManager requestWhenInUseAuthorization];
                    [locationManager startUpdatingLocation];
                }
                
                
                
                break;
            case kCLAuthorizationStatusNotDetermined:
                NSLog(@"HH: kCLAuthorizationStatusNotDetermined");
                [self initViews];
              
                break;
            default:
                break;
        }
    }
    else{
        [Utility showAlertMessage:@"Location Services" message:@"To re-enable, please go to Settings and turn on Location Services of your phone"];
    }
    //------
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    MKCoordinateRegion region = self.mapView.region;
    region.center = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    region.span.longitudeDelta = longitude_Zoom; // Bigger the value, closer the map view
    region.span.latitudeDelta = latitude_Zoom;
    [self.mapView setRegion:region animated:YES];
    
    Clatitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    Clongitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    
    [USERDEFAULTS setObject:Clatitude forKey:AddressLatitude];
    [USERDEFAULTS setObject:Clongitude forKey:AddressLongitude];
    
    [USERDEFAULTS setObject:Clatitude forKey:CurrentAddressLatitude];
    [USERDEFAULTS setObject:Clongitude forKey:CurrentAddressLongitude];
    [USERDEFAULTS synchronize];
    
    [self initViews];
    
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Cannot find the location.");
    [kAppDelegate hideProgressHUD];
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    [self.view endEditing:YES];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:[gestureRecognizer locationInView:self.mapView] toCoordinateFromView:self.mapView];
    
    NSLog(@"Map touched %f, %f.", coordinate.latitude, coordinate.longitude);
    
    Clatitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    Clongitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target: self
                                   selector: @selector(callAfterSixtySecond:) userInfo: nil repeats: NO];
}

-(void)callAfterSixtySecond:(NSTimer*) t
{
    NSLog(@"%id",isAnnotationClicked);
    
    if (isAnnotationClicked)
    {
        isAnnotationClicked= NO;
    }
    else
    {
        offsetLimit = 0;
        [USERDEFAULTS setObject:Clatitude forKey:AddressLatitude];
        [USERDEFAULTS setObject:Clongitude forKey:AddressLongitude];
        [USERDEFAULTS synchronize];
        [self.annotationDetailView setHidden:YES];
        
        if (isAdvanceSearch==YES)
        {
            [self AdvanceSearch];
        } else
        {
            //latest change-
            self.searchField.text = @"";
            [self textFieldDidChange:self.searchField];
            //[self DashboardListing];
        }
    }
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField.text isEqualToString:@""])
    {
        NSLog(@"search tapped with empty data");
         [self.searchView setHidden:YES];
    }
    else{
    NSLog(@"search tapped");
    offsetLimit=0;
    isAdvanceSearch=NO;
    [self searchRestaurant];
    }
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidChange:(UITextField *)textField
{    searchTextString=self.searchField.text;
    NSLog(@"textFieldDidChange");
    if ([searchTextString isEqualToString:@""])
    {
        [self.searchView setHidden:YES];
        isFilter= NO;
        //vinay here-
        [self.view endEditing:true];
//        [self DashboardListing];
        [self initViews];
    }else
    {
        [self updateSearchArray:searchTextString];
        isFilter= YES;
    }
    
    
}

-(void)updateSearchArray:(NSString *)searchText
{
    [self autoCompleteSearch:searchText];
    
}
-(void)searchRestaurant
{
    if(isFilter)
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:self.searchField.text forKey:@"term"];
        //        [dict setObject:@"" forKey:@"open_now"];
        [dict setObject:@"10000" forKey:@"radius"];
        [dict setObject:@"50" forKey:@"limit"];
        [dict setObject:@"distance" forKey:@"sort_by"];
        [dict setObject:Clatitude forKey:@"latitude"];
        [dict setObject:Clongitude forKey:@"longitude"];
        [dict setObject:@"restaurants,food" forKey:@"categories"];
        
        NSLog(@"%@",[USERDEFAULTS valueForKey:recentSearch]);
        
        if (![USERDEFAULTS valueForKey:recentSearch]) {
            
            recentSearchArray = [[NSMutableArray alloc]initWithObjects:self.searchField.text, nil];
            [USERDEFAULTS setObject:recentSearchArray forKey:recentSearch];
        }else
        {
            recentSearchArray = [[USERDEFAULTS valueForKey:recentSearch] mutableCopy];
            [recentSearchArray insertObject:self.searchField.text atIndex:0];
            [USERDEFAULTS setObject:recentSearchArray forKey:recentSearch];
        }
        if (isAdvanceSearch) {
            [self restaurantAdvancedSearch:dict];
        } else {
            [self restaurantListing:dict];
        }
        //Latest changes
        //[self restaurantAdvancedSearch:dict];
        
        [self.searchView setHidden:YES];
        //vinay here-
        [self.view endEditing:true];
        [self.searchTable reloadData];
        //[self addAllPins];
    }
    else
    {
        restaurantArray = [mainRestaurantArray mutableCopy];
        [self addAllPins];
        [dashBoardTable reloadData];
    }
}

- (void)receiveNotification:(NSNotification *)notification
{
    
    if ([[notification name] isEqualToString:@"advanceSearch"]) {
        // NSDictionary *myDictionary = (NSDictionary *)notification.object;
        //doSomething here.
        offsetLimit=0;
        isAdvanceSearch=YES;
        [self.clearBtn setHidden:NO];
        AdvanceSearchDict = [notification.userInfo mutableCopy];
        [self AdvanceSearch];
        
    }
}

-(void)AdvanceSearch
{
    [self.annotationDetailView setHidden:YES];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    if ([self.searchField.text isEqualToString:@""]) {
        [dict setObject:@"restaurants" forKey:@"term"];
    } else {
        [dict setObject:self.searchField.text forKey:@"term"];
    }
    
    [dict setObject:[AdvanceSearchDict valueForKey:@"radius"] forKey:@"radius"];
    [dict setObject:[AdvanceSearchDict valueForKey:@"limit"] forKey:@"limit"];
    if (![[AdvanceSearchDict valueForKey:@"categories"] isEqualToString:@""]) {
        [dict setObject:[AdvanceSearchDict valueForKey:@"categories"] forKey:@"categories"];
    }
    
    [dict setObject:Clatitude forKey:@"latitude"];
    [dict setObject:Clongitude forKey:@"longitude"];
    [dict setObject:@"distance" forKey:@"sort_by"];
    
    [self restaurantAdvancedSearch:dict];
}


-(void)DashboardListing
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"restaurants" forKey:@"term"];
    [dict setObject:@"10000" forKey:@"radius"];
    [dict setObject:@"50" forKey:@"limit"];
    [dict setObject:Clatitude forKey:@"latitude"];
    [dict setObject:Clongitude forKey:@"longitude"];
    [dict setObject:@"restaurants,food" forKey:@"categories"];
    [dict setObject:@"distance" forKey:@"sort_by"];
    [self restaurantListing:dict];
    
}

#pragma mark-Api methods

-(void)GetRestaurantDetail:(NSString*)restaurantId
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:restaurantId forKey:@"id"];
    
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]GetRestaurantDetail:^(id object)
     {
         
         NSLog(@"%@",object);
         
         {
//             restaurantDetailDict = [[NSMutableDictionary alloc]initWithDictionary:object];
//             [self setLayout];
             
             if (offsetLimit==0) {
                 [restaurantArray removeAllObjects];
                 [mainRestaurantArray removeAllObjects];
                 [dashBoardTable setContentOffset:CGPointZero animated:YES];
             }
             [restaurantArray addObject:[[NSMutableDictionary alloc]initWithDictionary:object]];
             mainRestaurantArray = restaurantArray;
             [dashBoardTable reloadData];
             [dashBoardTable setContentOffset:CGPointZero animated:YES];
             
             
             
             [spinner stopAnimating];
             [self addAllPins];
             //             dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
             //             dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
             //                 [self addAllPins];
             //             });
             if (restaurantArray.count>0)
             {
                 [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:YES];
                 [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:YES];
             }else
             {
                 [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:NO];
                 [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:NO];
             }
             
             [self.view setUserInteractionEnabled:true];
             
         }
         [kAppDelegate hideProgressHUD];
         
         
     }
                                                    onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
        [self showAlert:@"No Restaurant Found"];
     }params:dict];
}

-(void)restaurantListing:(NSMutableDictionary*)dict
{
    NSString *offsetStr = [NSString stringWithFormat:@"%d",offsetLimit];
    [dict setObject:offsetStr forKey:@"offset"];
    
    if (offsetLimit==0) {
        [kAppDelegate showProgressHUD];
    }
    
    NSLog(@"%@",dict);
    [self.view setUserInteractionEnabled:false];
    
    [[NetworkEngine sharedNetworkEngine]DashboardListing:^(id object)
     {
         
         // NSLog(@"%@",object);
         dispatch_async(dispatch_get_main_queue(), ^{
         
         if ([object valueForKey:@"businesses"])
         {
                 NSMutableArray *arr = [object valueForKey:@"businesses"];
                 
                 if(arr.count<=0)
                 {
                     if(isFilter)
                     {
                         if(offsetLimit<=0)
                         {
                            [self showAlert:@"No Restaurant Found"];
                         }
                         
                     }
                     else{
                         if(offsetLimit<=0)
                         {
                          [self showAlert:@"No Restaurants found around your Location."];
                         }
                     }
                 }
             
             if (offsetLimit==0) {
                 [restaurantArray removeAllObjects];
                 [mainRestaurantArray removeAllObjects];
                 [dashBoardTable setContentOffset:CGPointZero animated:YES];
             }
             for (int i=0; i<arr.count; i++) {
                 [restaurantArray addObject:[arr objectAtIndex:i]];
             }
             mainRestaurantArray = restaurantArray;
             if(arr.count<=0)
             {
                 if(offsetLimit>0)
                 {
                      //[dashBoardTable reloadData];
                 }
                 else{
                     [dashBoardTable reloadData];
                 }
                 
             }
             else{
             [dashBoardTable reloadData];
                 [dashBoardTable setContentOffset:CGPointZero animated:YES];
             }
             
             
             [spinner stopAnimating];
             [self addAllPins];
//             dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
//             dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                 [self addAllPins];
//             });
             if (restaurantArray.count>0)
             {
                 [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:YES];
                 [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:YES];
             }else
             {
                 [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:NO];
                 [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:NO];
             }
             
             [self.view setUserInteractionEnabled:true];
             
         }
         if (offsetLimit==0) {
             [kAppDelegate hideProgressHUD];
         }
             
             });
         
         
         
     }
                                                 onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
    
}

//Praagma Mark:- For Advanced Search
-(void)restaurantAdvancedSearch:(NSMutableDictionary*)dict
{
    NSString *offsetStr = [NSString stringWithFormat:@"%d",offsetLimit];
    [dict setObject:offsetStr forKey:@"offset"];
    
    if (offsetLimit==0) {
        [kAppDelegate showProgressHUD];
    }
    
    NSLog(@"%@",dict);
    [self.view setUserInteractionEnabled:false];
    
    [[NetworkEngine sharedNetworkEngine]DashboardListingForFinder:^(id object)
     {
         
         // NSLog(@"%@",object);
         dispatch_async(dispatch_get_main_queue(), ^{
             
             if ([object valueForKey:@"businesses"])
             {
                 NSMutableArray *arr = [object valueForKey:@"businesses"];
                 
                 if(arr.count<=0)
                 {
                     if(isFilter)
                     {
                         if(offsetLimit<=0)
                         {
                             [self showAlert:@"No Restaurant Found"];
                         }
                         
                     }
                     else{
                         if(offsetLimit<=0)
                         {
                             [self showAlert:@"No Restaurants found around your Location."];
                         }
                     }
                 }
                 
                 if (offsetLimit==0) {
                     [restaurantArray removeAllObjects];
                     [mainRestaurantArray removeAllObjects];
                     [dashBoardTable setContentOffset:CGPointZero animated:YES];
                 }
                 for (int i=0; i<arr.count; i++) {
                     [restaurantArray addObject:[arr objectAtIndex:i]];
                 }
                 mainRestaurantArray = restaurantArray;
                 if(arr.count<=0)
                 {
                     if(offsetLimit>0)
                     {
                         //[dashBoardTable reloadData];
                     }
                     else{
                         [dashBoardTable reloadData];
                     }
                     
                 }
                 else{
                     [dashBoardTable reloadData];
                     [dashBoardTable setContentOffset:CGPointZero animated:YES];
                 }
                 
                 
                 [spinner stopAnimating];
                 [self addAllPins];
                 //             dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
                 //             dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                 //                 [self addAllPins];
                 //             });
                 if (restaurantArray.count>0)
                 {
                     [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:YES];
                     [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:YES];
                 }else
                 {
                     [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:NO];
                     [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:NO];
                 }
                 
                 [self.view setUserInteractionEnabled:true];
                 
             }
             if (offsetLimit==0) {
                 [kAppDelegate hideProgressHUD];
             }
             
         });
         
         
         
     }
                                                 onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
    
}


-(void)autoCompleteSearch:(NSString*)searchText
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:searchText forKey:@"text"];
    [dict setObject:Clatitude forKey:@"latitude"];
    [dict setObject:Clongitude forKey:@"longitude"];
     [dict setObject:@"en_CA" forKey:@"locale"];
    
    [[NetworkEngine sharedNetworkEngine]autoCompleteSearch:^(id object)
     {
         
         NSLog(@"%@",object);
         
         if ([object valueForKey:@"terms"])
        // if (restaurantArray.count>0)
         {
             recentSearchArray = [[object valueForKey:@"businesses"] valueForKey:@"name"];
             searchRestaurantIDArray = [[object valueForKey:@"businesses"] valueForKey:@"id"];
             //latest changes-
//             NSPredicate *p = [NSPredicate predicateWithFormat:@"name CONTAINS [cd]%@", self.searchField.text];
//             NSArray *filtered = [restaurantArray filteredArrayUsingPredicate:p];
//             recentSearchArray = [filtered valueForKey:@"name"];
//             NSLog(@"HERE %@",recentSearchArray);
             
             if (recentSearchArray.count<1)
             {
                 NSString *str = [NSString stringWithFormat:@"No Result Found for %@",searchText];
                 recentSearchArray = [NSMutableArray arrayWithObject:str];
                 //[self.searchView setHidden:YES];
                 [self.searchView setHidden:NO];
             } else {
                 [self.searchView setHidden:NO];
             }
             
             [self.searchTable reloadData];
         } else
         {
             
             
         }
         
         
         
     }
                                                   onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.searchTable)
    {
        if (recentSearchArray.count>3) {
            return 3;
        }
        return recentSearchArray.count;
    }
    return restaurantArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    
    if (tableView==self.searchTable)
    {
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        cell.textLabel.text = recentSearchArray[indexPath.row];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithName:@"SegoeUI" size:15];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor =  [UIColor blackColor];
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
    }
    
    static NSString *propertyIdentifier = @"DashBoardCell";
    
    DashBoardCell *cell = (DashBoardCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier];
    
    if (cell == nil)
    {
        
        NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"DashBoardCell" owner:self options:nil];
        cell = [nib1 objectAtIndex:0];
    }
    NSMutableDictionary *dic = restaurantArray[indexPath.row];
    cell.restaurantName.text =[dic valueForKey:@"name"];
    NSArray *addressArray = [[dic valueForKey:@"location"] valueForKey:@"display_address"];
    cell.restaurantAddress.text = [addressArray componentsJoinedByString:@""];
    if ([[dic valueForKey:@"is_closed"] boolValue]) {
      cell.timeLable.text = @"Closed Now";
        
    } else {
        
        cell.timeLable.text = @"Open Now";
        
    }
    int rate = roundf([[dic valueForKey:@"rating"] intValue]);
    
    [self addRating:cell :rate];
    
    [cell.restaurantImage sd_setImageWithURL:[NSURL URLWithString:[dic valueForKey:@"image_url"]] placeholderImage:[UIImage imageNamed:@"list_placeholder"] options:SDWebImageDelayPlaceholder progress:nil completed:nil];
    
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
    if (tableView==dashBoardTable)
    {
        RestaurantDetailViewController *restaurantDetail =[self.storyboard instantiateViewControllerWithIdentifier:@"RestaurantDetailViewController"];
        restaurantDetail.restaurantId = [restaurantArray[indexPath.row]  valueForKey:@"id"];
        NSLog(@"%@",[restaurantArray[indexPath.row]  valueForKey:@"id"]);
        [self.navigationController pushViewController:restaurantDetail animated:YES];
    }else
    {
        [self.searchView setHidden:YES];
        
        NSString *str = [recentSearchArray objectAtIndex:indexPath.row];
        
        if (![str containsString:@"No Result Found"]) {
            offsetLimit=0;
            isFilter = true;
            self.searchField.text = [recentSearchArray objectAtIndex:indexPath.row];
            [self.searchField resignFirstResponder];
            //[self searchRestaurant];
            //latest changes-
            [self GetRestaurantDetail:[searchRestaurantIDArray objectAtIndex:indexPath.row]];
        }
        
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
                  willDecelerate:(BOOL)decelerate{
    NSLog(@"scrollViewDidEndDragging calling");
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
        
        if (isAdvanceSearch)
        {
            [self AdvanceSearch];
        } else {
            if (isFilter) {
                [self searchRestaurant];
            } else {
                [self initViews];
            }
        }
        
        
        
    }
}
#pragma mark - mapkit Annotations

-(void)initViews
{
    //self.propertyMap = [[MKMapView alloc] init];
    [self.searchTable setBackgroundColor:[UIColor clearColor]];
    self.searchField.text =@"";
    [self.annotationDetailView setHidden:YES];
    self.mapView.delegate = self;

    MKCoordinateRegion region = self.mapView.region;
    
    region.center = CLLocationCoordinate2DMake([Clatitude doubleValue], [Clongitude doubleValue]);
    //region.center = CLLocationCoordinate2DMake([Clatitude doubleValue],[Clongitude doubleValue]);
    
    region.span.longitudeDelta = longitude_Zoom; // Bigger the value, closer the map view
    region.span.latitudeDelta = latitude_Zoom;
    
    //    if( [Clatitude doubleValue] > -89 && [Clatitude doubleValue] < 89 && [Clongitude doubleValue] > -179 && [Clongitude doubleValue] < 179 ){
    
    [self.mapView setRegion:region animated:YES];
    NSLog(@"init Views");
    if (isAdvanceSearch==YES) {
        [self AdvanceSearch];
    } else {
        [self DashboardListing];
    }
    
  
    //    }
    //[self.mapView setRegion:region animated:YES]; // Choose if you want animate or not
    
    
}

-(void)addAllPins
{
    isSetBlueRegion= NO;
    self.mapView.delegate=self;
    [self.annotationDetailView setHidden:YES];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    NSString *arrCoordinateStr = [NSString stringWithFormat:@"%f, %f",[Clatitude doubleValue],[Clongitude doubleValue]];
    
    [self addPinWithTitle:@"CurrentUser" AndCoordinate:arrCoordinateStr];
    
    for(int i = 0; i < restaurantArray.count; i++)
    {
        
//        if ([[[restaurantArray objectAtIndex:i] valueForKey:@"id"] isEqualToString:@"01mtkuHgipRFi575Ykz60Q"]) {
//
//            CLLocationCoordinate2D objCordinates = [self getLocationFromAddressString:[[restaurantArray objectAtIndex:i]valueForKey:@"alias"]];
//             NSString *arrCoordinateStr = [NSString stringWithFormat:@"%f, %f",objCordinates.latitude,objCordinates.longitude];
//
//         //   NSString * arrCoordinateStr = @"44.1081713, -79.5938537";
//
//
//            [self addPinWithTitle:@"testing pin" AndCoordinate:arrCoordinateStr];
//        } else {
//            NSMutableDictionary *locationDict = [[restaurantArray objectAtIndex:i] valueForKey:@"coordinates"];
//
//            // NSString *price =[NSString stringWithFormat:@"%@ K",priceStr];
//            NSString *arrCoordinateStr = [NSString stringWithFormat:@"%@, %@",[locationDict valueForKey:@"latitude"],[locationDict valueForKey:@"longitude"]];
//
//            [self addPinWithTitle:[NSString stringWithFormat:@"%d",i] AndCoordinate:arrCoordinateStr];
        
      //  }
        
        //vinay here-
        NSMutableDictionary *locationDict = [[restaurantArray objectAtIndex:i] valueForKey:@"coordinates"];

        // NSString *price =[NSString stringWithFormat:@"%@ K",priceStr];
        NSString *arrCoordinateStr;
        NSLog(@"restaurant in first index-%@",[restaurantArray objectAtIndex:i]);
       // if ([[restaurantArray objectAtIndex:i] valueForKey:@"Glat"]!=nil||[[restaurantArray objectAtIndex:i] valueForKey:@"Glat"])
        if (![[[restaurantArray objectAtIndex:i] valueForKey:@"Glat"] isEqualToString:@""] && [[restaurantArray objectAtIndex:i] valueForKey:@"Glat"]!=nil)
        {
              arrCoordinateStr = [NSString stringWithFormat:@"%@, %@",[[restaurantArray objectAtIndex:i] valueForKey:@"Glat"],[[restaurantArray objectAtIndex:i] valueForKey:@"Glng"]];
        } else {
             arrCoordinateStr = [NSString stringWithFormat:@"%@, %@",[locationDict valueForKey:@"latitude"],[locationDict valueForKey:@"longitude"]];
        }
        
      

        [self addPinWithTitle:[NSString stringWithFormat:@"%d",i] AndCoordinate:arrCoordinateStr];
        
        NSString *restaurantName = [[restaurantArray objectAtIndex:i] valueForKey:@"name"];
        if( [restaurantName caseInsensitiveCompare:self.searchField.text] == NSOrderedSame ) {
            // strings are equal except for possibly case
            if (isSetBlueRegion==NO)
            {
                //NSMutableDictionary *coordinates = [[restaurantArray objectAtIndex:i] valueForKey:@"coordinates"];
                //latest changes-
               // if ([[restaurantArray objectAtIndex:i] valueForKey:@"Glat"]!=nil||[[restaurantArray objectAtIndex:i] valueForKey:@"Glat"])
                if (![[[restaurantArray objectAtIndex:i] valueForKey:@"Glat"] isEqualToString:@""] && [[restaurantArray objectAtIndex:i] valueForKey:@"Glat"]!=nil)
                {
                    [self setRegionForBlueRestaurant:[[restaurantArray objectAtIndex:i] valueForKey:@"Glat"] :[[restaurantArray objectAtIndex:i] valueForKey:@"Glng"]];
                }else
                {
                    [self setRegionForBlueRestaurant:[locationDict valueForKey:@"latitude"] :[locationDict valueForKey:@"longitude"]];
                }
                
                
                
            }
            //[pin setImage:[self setSearchImage:categoriesArray]];
        }
        //vinay here-
        if (isFilter&&!isSearchedWithfilter&&i==restaurantArray.count-1&&!isSetBlueRegion) {
            
            //vinay here-
            if (restaurantArray.count==0) {
                [self showAlert:@"No Restaurants found around your Location."];
            }
            //[self showAlert:@"No Restaurant found"];
        }else{
            isSearchedWithfilter = false;
        }
        
    }
    
    //    NSString *arrCoordinateStr = [NSString stringWithFormat:@"%f, %f",[Clatitude doubleValue],[Clongitude doubleValue]];
    //
    //    [self addPinWithTitle:@"" AndCoordinate:arrCoordinateStr];
    
}

//-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
//    double latitude = 0, longitude = 0;
//    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *req = [NSString stringWithFormat:@"https://maps.google.com/maps/api/geocode/json?sensor=false&address=%@&key=AIzaSyABrCIdzKuY_EELaxv4OYoxnJ0SGYuf1Ks", esc_addr];
//    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
//    if (result) {
//        NSScanner *scanner = [NSScanner scannerWithString:result];
//        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
//            [scanner scanDouble:&latitude];
//            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
//                [scanner scanDouble:&longitude];
//            }
//        }
//    }
//    CLLocationCoordinate2D center;
//    center.latitude=latitude;
//    center.longitude = longitude;
//    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
//    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
//    return center;
//
//}


- (void)removeAllPinsButUserLocation1
{
    id userLocation = [self.mapView userLocation];
    [self.mapView removeAnnotations:[self.mapView annotations]];
    
    if ( userLocation != nil ) {
        [self.mapView addAnnotation:userLocation]; // will cause user location pin to blink
    }
}


-(void)addPinWithTitle:(NSString *)title AndCoordinate:(NSString *)strCoordinate
{
    MKPointAnnotation *mapPin = [[MKPointAnnotation alloc] init];
    
    // clear out any white space
    strCoordinate = [strCoordinate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // convert string into actual latitude and longitude values
    NSArray *components = [strCoordinate componentsSeparatedByString:@","];
    
    double latitude = [components[0] doubleValue];
    double longitude = [components[1] doubleValue];
    
    // setup the map pin with all data and add to map view
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    mapPin.title = title;
    mapPin.coordinate = coordinate;
    [self.mapView addAnnotation:mapPin];
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if([annotation isKindOfClass:[annotation class]])
    {
        //Your code
        
        MKAnnotationView *pin = nil; //create MKAnnotationView Property
        
        pin = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier: @"asdf"];
        if (pin == nil)
        {
            pin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"asdf"];
            
        }
        else
        {
            pin.annotation = annotation;
            
        }
        
        // pin.tag =[[self.mapView annotations] indexOfObject:annotation];
        pin.multipleTouchEnabled = NO;
        [pin setEnabled:YES];
        //
        //  NSLog(@"pin.tag %ld",(long)pin.tag);
        [pin setImage:[UIImage imageNamed:@"Symbol 158  1"]];
        if ([annotation.title isEqualToString:@"CurrentUser"])
        {
            pin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"asdfsdsd"];
            pin.tag=1000;
            [pin setImage:[UIImage imageNamed:@"Path 1775"]];
            return pin;
        }
        int countpin = 0;
        if(restaurantArray.count>0)
        {
            countpin = countpin + 1;
            NSMutableArray *categoriesArray = [[restaurantArray objectAtIndex:[annotation.title intValue]] valueForKey:@"categories"];
            pin.tag = [annotation.title intValue];
            NSString *restaurantName = [[restaurantArray objectAtIndex:[annotation.title intValue]] valueForKey:@"name"];
             if( [restaurantName caseInsensitiveCompare:self.searchField.text] == NSOrderedSame ) {
                [pin setImage:[self setSearchImage:categoriesArray]];
                isSearchedWithfilter = true;
                
            } else {
                [pin setImage:[self setImageValue:categoriesArray]];
            }
        }
        
        if (countpin==restaurantArray.count&&isFilter) {
            if (isSearchedWithfilter==false) {
                //vinay here-
               // [self showAlert:@"No Restaurant Found"];
            }else{
                isSearchedWithfilter = false;
            }
        }
        
        return pin;
    }
    
    
    return nil;
}

-(void)setRegionForBlueRestaurant:(NSString*)latitude :(NSString*)longitude
{
    MKCoordinateRegion region = self.mapView.region;
    
    region.center = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
    //region.center = CLLocationCoordinate2DMake([Clatitude doubleValue],[Clongitude doubleValue]);
    
    region.span.longitudeDelta = 0.001; // Bigger the value, closer the map view
    region.span.latitudeDelta = 0.001;
    //vinay here-
//    region.span.longitudeDelta = longitude_Zoom; // Bigger the value, closer the map view
//    region.span.latitudeDelta = latitude_Zoom;
    [self.mapView setRegion:region animated:YES];
    isSetBlueRegion = YES;
}

-(UIImage*)setImageValue:(NSMutableArray*)CategoryArray
{
    UIImage *categoryImage;
    
    for (NSMutableDictionary *dict in CategoryArray)
    {
        
        NSString *title = [NSString stringWithFormat:@"%@",[dict valueForKey:@"alias"]];
        if ([FASTFOODArray containsObject:title]) // YES
        {
            // Do something
            categoryImage =[UIImage imageNamed:@"landmark_fastfood"];
            break;
        }
        else if ([BARArray containsObject:title])
        {
            categoryImage =[UIImage imageNamed:@"landmark_bar"];
            break;
        }
        else if ([BBqArray containsObject:title])
        {
            categoryImage =[UIImage imageNamed:@"landmark_bbq"];
            break;
        }
        else if ([CAFEArray containsObject:title])
        {
            categoryImage =[UIImage imageNamed:@"landmark_cafe"];
            break;
        }
        else if ([DESSERTArray containsObject:title])
        {
            categoryImage =[UIImage imageNamed:@"landmark_dessert"];
            break;
        }
        else if ([HEALTHYCHOICEArray containsObject:title])
        {
            categoryImage =[UIImage imageNamed:@"landmark_healthy"];
            break;
        }
        else if ([VEGANArray containsObject:title])
        {
            categoryImage =[UIImage imageNamed:@"landmark_vegan"];
            break;
        }
        else if ([EATTHEWORLDArray containsObject:title])
        {
            categoryImage =[UIImage imageNamed:@"landmark_world"];
            break;
        }
        else if ([AroundMeArray containsObject:title])
        {
            categoryImage =[UIImage imageNamed:@"landmark_fastfood"];
            break;
        }
        else
        {
            categoryImage =[UIImage imageNamed:@"landmark_eathere"];
        }
        
    }
    return categoryImage;
}

-(UIImage*)setSearchImage:(NSMutableArray*)CategoryArray
{
    UIImage *categoryImage;
    
    for (NSMutableDictionary *dict in CategoryArray)
    {
        
        NSString *title = [NSString stringWithFormat:@"%@",[dict valueForKey:@"alias"]];
        if ([FASTFOODArray containsObject:title]) // YES
        {
            // Do something
            categoryImage =[UIImage imageNamed:@"fastfood_blue"];
            break;
        }
        else if ([BARArray containsObject:title])
        {
            categoryImage =[UIImage imageNamed:@"bar_blue"];
            break;
        }
        else if ([BBqArray containsObject:title])
        {
            categoryImage =[UIImage imageNamed:@"bbq_blue"];
            break;
        }
        else if ([CAFEArray containsObject:title])
        {
            categoryImage =[UIImage imageNamed:@"cafe_blue"];
            break;
        }
        else if ([DESSERTArray containsObject:title])
        {
            categoryImage =[UIImage imageNamed:@"dessert_blue"];
            break;
        }
        else if ([HEALTHYCHOICEArray containsObject:title])
        {
            categoryImage =[UIImage imageNamed:@"healthy_blue"];
            break;
        }
        else if ([VEGANArray containsObject:title])
        {
            categoryImage =[UIImage imageNamed:@"vegan_blue"];
            break;
        }
        else if ([EATTHEWORLDArray containsObject:title])
        {
            categoryImage =[UIImage imageNamed:@"world_blue"];
            break;
        }
        else if ([AroundMeArray containsObject:title])
        {
            categoryImage =[UIImage imageNamed:@"fastfood_blue"];
            break;
        }
        else
        {
            categoryImage =[UIImage imageNamed:@"eathere_blue"];
        }
        
    }
    return categoryImage;
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [self.view endEditing:YES];
    isAnnotationClicked = YES;
    viewTag = (int)[view tag];
    if (viewTag==1000) {
        [self.annotationDetailView setHidden:YES];
    }else
    {
        [self.annotationDetailView setHidden:NO];
        
        self.restaurantName.text =[[restaurantArray objectAtIndex:viewTag]  valueForKey:@"name"];
        NSArray *addressArray = [[[restaurantArray objectAtIndex:viewTag]  valueForKey:@"location"] valueForKey:@"display_address"];
        self.restaurantAddress.text = [addressArray componentsJoinedByString:@""];
        BOOL isClosed = [[[restaurantArray objectAtIndex:viewTag]  valueForKey:@"is_closed"] boolValue];
        if (isClosed) {
           
            self.timeLable.text = @"Closed Now";
            
        } else {
             self.timeLable.text = @"Open Now";
        }
        
        int rate = roundf([[[restaurantArray objectAtIndex:viewTag] valueForKey:@"rating"] intValue]);
        [self setRating:rate];
    }
    
    [self.mapView deselectAnnotation:view.annotation animated:YES];
    
    
    
}

-(void)setRating:(int)rating
{
    if (rating>=1) {
        self.firstRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
    }
    if (rating>=2) {
        self.secondRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
    }
    if (rating>=3) {
        self.thirdRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
    }
    if (rating>=4) {
        self.fourthRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
    }
    if (rating>=5) {
        self.fifthRatingImage.image = [UIImage imageNamed:@"small_star_yellow" ];
    }
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

- (IBAction)flipViewAction:(id)sender {
    
    if (![sender isSelected])
    {
        [sender setSelected:YES];
        [dashBoardTable setHidden:NO];
         [dashBoardTable reloadData];
        if(restaurantArray.count<=0)
        {
            emptyLbl.text = @"No data found";
            [animationView setHidden:NO];
            [self playLottieAnimation];
             [emptyLbl setHidden:NO];
        }
        else{
             [emptyLbl setHidden:YES];
             [animationView setHidden:YES];
            [self StopLottieAnimation];
        }
        [self.flipImage setImage:[UIImage imageNamed:@"Symbol 158  1"]];
    }
    else
    {
        [sender setSelected:NO];
        [dashBoardTable setHidden:YES];
         [emptyLbl setHidden:YES];
        [animationView setHidden:YES];
        [self StopLottieAnimation];
        [self.flipImage setImage:[UIImage imageNamed:@"Group 789"]];
    }
    [self.searchField resignFirstResponder];
    
}
- (IBAction)advanceSearchAction:(id)sender
{
    AdvancedSearchViewController *filterSearch =[self.storyboard instantiateViewControllerWithIdentifier:@"AdvancedSearchViewController"];
    filterSearch.selectedDic = AdvanceSearchDict;
    [self.navigationController pushViewController:filterSearch animated:NO];
}
- (IBAction)closeDetailView:(id)sender
{
    [self.annotationDetailView setHidden:YES];
}
- (IBAction)clearRecentSearch:(id)sender
{
    [self.searchView setHidden:YES];
}
- (IBAction)showDetailBtn:(id)sender
{
    RestaurantDetailViewController *restaurantDetail =[self.storyboard instantiateViewControllerWithIdentifier:@"RestaurantDetailViewController"];
    restaurantDetail.restaurantId = [restaurantArray[viewTag]  valueForKey:@"id"];
    [self.navigationController pushViewController:restaurantDetail animated:YES];
}
- (IBAction)clearClicked:(id)sender
{
    [self.clearBtn setHidden:YES];
    isAdvanceSearch = NO;
    AdvanceSearchDict = nil;
    //latest changes-
    isFilter= NO;
    [self initViews];
}
- (IBAction)updateLocation:(id)sender
{
    if ([CLLocationManager locationServicesEnabled]) {
        
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusDenied:
                NSLog(@"HH: kCLAuthorizationStatusDenied");
                [Utility showAlertMessage:@"App Permission Denied" message:@"You have disabled your location services to enable it again please go to  Settings > Eathere > Location."];
                
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
                NSLog(@"HH: kCLAuthorizationStatusAuthorizedAlways");
                [locationManager requestWhenInUseAuthorization];
                [locationManager startUpdatingLocation];
                
                
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                NSLog(@"HH: kCLAuthorizationStatusAuthorizedWhenInUse");
                [locationManager requestWhenInUseAuthorization];
                [locationManager startUpdatingLocation];
                
                
                break;
            case kCLAuthorizationStatusNotDetermined:
                NSLog(@"HH: kCLAuthorizationStatusNotDetermined");
                 [locationManager requestWhenInUseAuthorization];
                 [locationManager startUpdatingLocation];
                
                break;
            default:
                break;
        }
    }
    else{
        [Utility showAlertMessage:@"Location Services" message:@"To re-enable, please go to Settings and turn on Location Services of your phone"];
    }
}

-(void)showAlert:(NSString*)messageText
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Eat Here!" message:messageText preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
//        self.dashBoardTable.hidden = false;
        self.searchField.text = @"";
        isFilter =false;
    }];
    [alert addAction:cancel];
    [alert.view setTintColor:[UIColor redColor]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)loadAllArry
{
    AroundMeArray = [Utility convertString:AROOUNDME];
    BBqArray =[Utility convertString:BBQ];
    CAFEArray = [Utility convertString:CAFE];
    FASTFOODArray =[Utility convertString:FASTFOOD];
    VEGANArray =[Utility convertString:Vegan];
    HEALTHYCHOICEArray =[Utility convertString:HEALTHY];
    BARArray =[Utility convertString:BARS];
    DESSERTArray =[Utility convertString:Deserts];
    EATTHEWORLDArray =[Utility convertString:EAT_WORLD];
    TermsArray =[Utility convertString:TERMS];
    HeighRatedArray = [Utility convertString:HIGH_RAT];
}

-(void)playLottieAnimation
{
   
    hello_loader = [LOTAnimationView animationNamed:@"ice_cream_animation"];
    
    hello_loader.contentMode = UIViewContentModeScaleAspectFill;
    double newWidth = animationView.frame.size.width;
    hello_loader.frame = CGRectMake(0, 0,newWidth, newWidth);
    [animationView addSubview:hello_loader];
     hello_loader.loopAnimation = YES;
    [hello_loader play];
}
-(void)StopLottieAnimation
{
    [hello_loader stop];
}
@end
