//
//  PurchaseViewController.m
//  SuperMarket
//
//  Created by phoenix on 12/8/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "PurchaseViewController.h"
#import "PPRevealSideViewController.h"
#import "FriendViewController.h"
#import "Setting.h"
#import "ProductObject.h"
#import "AsyncImageView.h"
#import "ProductsWithCategory.h"
@interface PurchaseViewController ()

@end

@implementation PurchaseViewController
@synthesize img_back;
@synthesize arrayCurrentFavorite;
@synthesize arrayExpireFavorite;
@synthesize tableState;
@synthesize favoriteTable;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    arrayCurrentFavorite = [[NSMutableArray alloc]init];
    arrayExpireFavorite = [[NSMutableArray alloc]init];
    tableState = TRUE;
}
- (void )viewWillAppear:(BOOL)animated{
    [arrayCurrentFavorite removeAllObjects];
    [arrayExpireFavorite removeAllObjects];
    [[Setting sharedInstance] loadFavoriteListFromLocalDB:[Setting sharedInstance].customer.customerID];
    [[Setting sharedInstance] loadPurchaseListFromLocalDB:[Setting sharedInstance].customer.customerID];
    NSString *companyID = @"";
    NSMutableArray *currentFavor = [[NSMutableArray alloc]init];
    NSMutableArray *expireFavor = [[NSMutableArray alloc]init];
    
    if ([Setting sharedInstance].myPurchaseList.count > 1){
        for (int i = 0; i < [Setting sharedInstance].myPurchaseList.count - 1; i++){
            ProductObject *tmpObj = [[Setting sharedInstance].myPurchaseList objectAtIndex:i];
            ProductObject *firstObj = [[Setting sharedInstance].myPurchaseList objectAtIndex:i];
            int index = i;
            for (int j = i + 1; j < [Setting sharedInstance].myPurchaseList.count; j++){
                ProductObject *secondObj = [[Setting sharedInstance].myPurchaseList objectAtIndex:j];
                NSString *sortNum1 = [[Setting sharedInstance] getSortNum:tmpObj.prodCompanyID withType:@"company"];
                NSString *sortNum2 = [[Setting sharedInstance] getSortNum:secondObj.prodCompanyID withType:@"company"];
                if ([sortNum1 intValue] > [sortNum2 intValue]) {
                    tmpObj = secondObj;
                    index = j;
                    
                }
            }
            
            [[Setting sharedInstance].myPurchaseList replaceObjectAtIndex:i withObject:tmpObj];
            [[Setting sharedInstance].myPurchaseList replaceObjectAtIndex:index withObject:firstObj];
            
        }
    }
    
    for (int i = 0; i < [Setting sharedInstance].myPurchaseList.count; i++)
    {
        ProductObject *obj = [[Setting sharedInstance].myPurchaseList objectAtIndex:i];
        if ([[Setting sharedInstance] isFavoriteExist:obj.prodID] == TRUE) {
            obj.prodFavoriteProducts = @"true";
        }
        else
            obj.prodFavoriteProducts = @"";
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [df setLocale:locale];
        NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        [df setTimeZone:tz];
        NSDate *endDate = [df dateFromString:obj.prodEndDate];
        NSDate *today = [[NSDate alloc]init];
        
        if ([today compare:endDate] == NSOrderedAscending){
            [currentFavor addObject:obj];
        }
        else{
            [expireFavor addObject:obj];
        }
    }
    for (int i = 0; i < currentFavor.count; i++)
    {
        ProductsWithCategory *catObj = [[ProductsWithCategory alloc]init];
        ProductObject *obj = [currentFavor objectAtIndex:i];
        
        if (![companyID isEqualToString:obj.prodCompanyID])
        {
            catObj.isCategory = TRUE;
            catObj.obj = Nil;
            catObj.mainID = obj.prodMainCatID;
            catObj.subID = obj.prodSubCatID;
            catObj.companyID = obj.prodCompanyID;
            [arrayCurrentFavorite addObject:catObj];
            ProductsWithCategory *conObj = [[ProductsWithCategory alloc]init];
            conObj.isCategory = FALSE;
            conObj.obj = obj;
            [arrayCurrentFavorite addObject:conObj];
        }
        else
        {
            catObj.isCategory = FALSE;
            catObj.obj = obj;
            [arrayCurrentFavorite addObject:catObj];
        }
        companyID = obj.prodCompanyID;
        
    }
    companyID = @"";
    for (int i = 0; i < expireFavor.count; i++)
    {
        ProductsWithCategory *catObj = [[ProductsWithCategory alloc]init];
        ProductObject *obj = [expireFavor objectAtIndex:i];
        
        if (![companyID isEqualToString:obj.prodCompanyID])
        {
            catObj.isCategory = TRUE;
            catObj.obj = Nil;
            catObj.mainID = obj.prodMainCatID;
            catObj.subID = obj.prodSubCatID;
            catObj.companyID = obj.prodCompanyID;
            [arrayExpireFavorite addObject:catObj];
            ProductsWithCategory *conObj = [[ProductsWithCategory alloc]init];
            conObj.isCategory = FALSE;
            conObj.obj = obj;
            [arrayExpireFavorite addObject:conObj];
        }
        else
        {
            catObj.isCategory = FALSE;
            catObj.obj = obj;
            [arrayExpireFavorite addObject:catObj];
        }
        companyID = obj.prodCompanyID;
        
    }
    [favoriteTable reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtnCurrentOffer:(id)sender {
    img_back.image = [UIImage imageNamed:@"favorite_tab_bg.png"];
    tableState = TRUE;
    [favoriteTable reloadData];
}

- (IBAction)onBtnExpiredOffer:(id)sender {
    img_back.image = [UIImage imageNamed:@"favorite_tab1_bg.png"];
    tableState = FALSE;
    [favoriteTable reloadData];
}

- (IBAction)onBtnList:(id)sender {
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // Session is open
    FriendViewController *c = [mainstoryboard instantiateViewControllerWithIdentifier:@"FriendManageView"];
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:c];
    c.navigationController.navigationBarHidden = YES;
    [self.revealSideViewController pushViewController:n onDirection:PPRevealSideDirectionRight withOffset:158 animated:TRUE];
    PP_RELEASE(c);
    PP_RELEASE(n);
}

- (IBAction)onBtnRemove:(id)sender {
    NSIndexPath *indexPath = [favoriteTable indexPathForCell:(UITableViewCell *)[[sender superview]superview]];
    if (tableState == TRUE){
        ProductsWithCategory *catObj = [arrayCurrentFavorite objectAtIndex:indexPath.row];
        if (catObj.isCategory == FALSE){
            catObj.obj.prodPurchasedProducts = @"";
            catObj.obj.prodAddPurchaseDate = @"";
            for (int i = 0; i < [Setting sharedInstance].myPurchaseList.count; i++){
                ProductObject *obj = [[Setting sharedInstance].myPurchaseList objectAtIndex:i];
                if ([obj.prodID isEqualToString:catObj.obj.prodID])
                {
                    [[Setting sharedInstance].myPurchaseList removeObjectAtIndex:i];
                    [[Setting sharedInstance] removePurchaseProduct:[Setting sharedInstance].customer.customerID withProdID:catObj.obj.prodID];
                    break;
                }
            }
            BOOL delFlag = FALSE;
            ProductsWithCategory *tmpObj1 = [arrayCurrentFavorite objectAtIndex:indexPath.row - 1];
            ProductsWithCategory *tmpObj2 = [arrayCurrentFavorite objectAtIndex:indexPath.row];
            if (indexPath.row == arrayCurrentFavorite.count - 1) {
                tmpObj2 = nil;
            }
            else
                tmpObj2 = [arrayCurrentFavorite objectAtIndex:indexPath.row + 1];
            
            if (tmpObj1.isCategory == TRUE){
                if (tmpObj2 == nil || tmpObj2.isCategory == TRUE)
                    delFlag = TRUE;
            }
            
            [arrayCurrentFavorite removeObjectAtIndex:indexPath.row];
            if (delFlag == TRUE)
                [arrayCurrentFavorite removeObjectAtIndex:indexPath.row - 1];
        }
    }
    else{
        ProductsWithCategory *catObj = [arrayExpireFavorite objectAtIndex:indexPath.row];
        if (catObj.isCategory == FALSE){
            catObj.obj.prodPurchasedProducts = @"";
            catObj.obj.prodAddPurchaseDate = @"";
            for (int i = 0; i < [Setting sharedInstance].myPurchaseList.count; i++){
                ProductObject *obj = [[Setting sharedInstance].myPurchaseList objectAtIndex:i];
                if ([obj.prodID isEqualToString:catObj.obj.prodID])
                {
                    [[Setting sharedInstance].myPurchaseList removeObjectAtIndex:i];
                    [[Setting sharedInstance] removePurchaseProduct:[Setting sharedInstance].customer.customerID withProdID:catObj.obj.prodID];
                    break;
                }
            }
            BOOL delFlag = FALSE;
            ProductsWithCategory *tmpObj1 = [arrayExpireFavorite objectAtIndex:indexPath.row - 1];
            ProductsWithCategory *tmpObj2 = [arrayExpireFavorite objectAtIndex:indexPath.row];
            if (indexPath.row == arrayExpireFavorite.count - 1) {
                tmpObj2 = nil;
            }
            else
                tmpObj2 = [arrayExpireFavorite objectAtIndex:indexPath.row + 1];
            
            if (tmpObj1.isCategory == TRUE){
                if (tmpObj2 == nil || tmpObj2.isCategory == TRUE)
                    delFlag = TRUE;
            }
            
            [arrayExpireFavorite removeObjectAtIndex:indexPath.row];
            if (delFlag == TRUE)
                [arrayExpireFavorite removeObjectAtIndex:indexPath.row - 1];
        }
    }
    
    [favoriteTable reloadData];
}

- (IBAction)onBtnPurchase:(id)sender {
    
    NSIndexPath *indexPath = [favoriteTable indexPathForCell:(UITableViewCell *)[[sender superview]superview]];
    ProductsWithCategory *catObj;
    if (tableState == TRUE){
        catObj = [arrayCurrentFavorite objectAtIndex:indexPath.row];
    }
    else
    {
        catObj = [arrayExpireFavorite objectAtIndex:indexPath.row];
    }
    
    
    if (catObj.isCategory == FALSE){
        if ([catObj.obj.prodFavoriteProducts isEqualToString:@""]){
            catObj.obj.prodFavoriteProducts = @"true";
            NSDate *addDate = [[NSDate alloc]init];
            NSDateFormatter *df1 = [[NSDateFormatter alloc]init];
            [df1 setDateFormat:@"dd/MM/yyyy"];
            NSLocale *locale1 = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            [df1 setLocale:locale1];
            NSTimeZone *tz1 = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
            [df1 setTimeZone:tz1];
            catObj.obj.prodAddDate = [df1 stringFromDate:addDate];
            [[Setting sharedInstance].myFavoriteList addObject:catObj.obj];
            [[Setting sharedInstance] addFavoriteProduct:[Setting sharedInstance].customer.customerID withProdID:catObj.obj.prodID withDate:catObj.obj.prodAddPurchaseDate withCompany:catObj.obj.prodCompanyID];
            [[Setting sharedInstance] sendFavoriteRequest:catObj.obj];
        }
        else{
            catObj.obj.prodFavoriteProducts = @"";
            catObj.obj.prodAddDate = @"";
            for (int i = 0; i < [Setting sharedInstance].myFavoriteList.count; i++){
                ProductObject *obj = [[Setting sharedInstance].myFavoriteList objectAtIndex:i];
                if ([obj.prodID isEqualToString:catObj.obj.prodID])
                {
                    [[Setting sharedInstance].myFavoriteList removeObjectAtIndex:i];
                    [[Setting sharedInstance] removeFavoriteProduct:[Setting sharedInstance].customer.customerID withProdID:catObj.obj.prodID];
                    break;
                }
            }
        }
    }
    
    [favoriteTable reloadData];
}

- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    ProductsWithCategory *catObj;
    if (tableState == TRUE)
        catObj = [arrayCurrentFavorite objectAtIndex:indexPath.row];
    else
        catObj = [arrayExpireFavorite objectAtIndex:indexPath.row];
    
    if (catObj.isCategory == TRUE)
    {
        cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"CompanyNameCell"];
        if (cell == Nil)
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CompanyNameCell"];
        UILabel *lb_company = (UILabel*)[cell viewWithTag:999];
        NSString *companyName = [[Setting sharedInstance] getCompanyName:catObj.companyID];
        lb_company.text = companyName;
    }
    else {
        cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"FavoriteCell"];
        if (cell == Nil)
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FavoriteCell"];
        ProductObject *obj = catObj.obj;
        if (![obj.prodPhotoURL isEqualToString:@""]){
            AsyncImageView *img_product = (AsyncImageView*)[cell viewWithTag:111];
            [img_product setImageURL:[NSURL URLWithString:obj.prodPhotoURL]];
        }
        UIView *badge_view = (UIView*)[cell viewWithTag:119];
        if ([obj.prodOrgPrice isEqualToString:@""]) {
            badge_view.hidden = YES;
        }
        else{
            badge_view.hidden = NO;
            
        }
        UILabel *lb_percent = (UILabel*)[cell viewWithTag:112];
        NSString *pro = @"%";
        int percents = (int)(([obj.prodOrgPrice floatValue] - [obj.prodCurPrice floatValue]) / [obj.prodOrgPrice floatValue] * 100);
        lb_percent.text = [pro stringByAppendingString:[NSString stringWithFormat:@"%d", percents]];
        UILabel *lb_prod_title = (UILabel*)[cell viewWithTag:102];
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            lb_prod_title.text = obj.prodTitleEn;
        }
        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
            lb_prod_title.text = obj.prodTitleAr;
        }
        
        
        UILabel *lb_mainCat = (UILabel*)[cell viewWithTag:103];
        NSString *mainStr = [[Setting sharedInstance] getMainCategoryName:obj.prodMainCatID];
        lb_mainCat.text = mainStr;
        
        UILabel *lb_addDate = (UILabel*)[cell viewWithTag:104];
        lb_addDate.text = [NSString stringWithFormat:@"Added: %@", obj.prodAddPurchaseDate];
        
        
        UILabel *lb_date = (UILabel*)[cell viewWithTag:105];
        NSString *startTimeStr = [obj.prodStartDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        
        NSString *endTimeStr = [obj.prodEndDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [df setLocale:locale];
        NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        [df setTimeZone:tz];
        NSDate *prodStartDate = [df dateFromString:startTimeStr];
        [df setDateFormat:@"MMM dd"];
        startTimeStr = [df stringFromDate:prodStartDate];
        
        NSDateFormatter *df1 = [[NSDateFormatter alloc]init];
        [df1 setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSLocale *locale1 = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [df1 setLocale:locale1];
        NSTimeZone *tz1 = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        [df1 setTimeZone:tz1];
        NSDate *prodEndDate = [df1 dateFromString:endTimeStr];
        [df1 setDateFormat:@"MMM dd"];
        endTimeStr = [df1 stringFromDate:prodEndDate];
        lb_date.text = [NSString stringWithFormat:@"From %@ To %@, or until stocks", startTimeStr, endTimeStr];
        
        if (![obj.prodCurPrice isEqualToString:@""]){
            UILabel *lb_price = (UILabel*)[cell viewWithTag:106];
            lb_price.text = [NSString stringWithFormat:@"%@ KD", obj.prodCurPrice];
        }
        UIImageView *imgLine = (UIImageView*)[cell viewWithTag:120];
        imgLine.hidden = YES;
        UILabel *lb_orgPrice = (UILabel*)[cell viewWithTag:107];
        lb_orgPrice.hidden = YES;
        if (![obj.prodOrgPrice isEqualToString:@""]){
            lb_orgPrice.text = [NSString stringWithFormat:@"%@ KD", obj.prodOrgPrice];
            imgLine.hidden = NO;
            lb_orgPrice.hidden = NO;
        }
        
        
        UIButton *btnPurchase = (UIButton*)[cell viewWithTag:109];
        if ([obj.prodFavoriteProducts isEqualToString:@""]){
            [btnPurchase setBackgroundImage:[UIImage imageNamed:@"btn_unsel_favorite.png"] forState:UIControlStateNormal];
            [btnPurchase setBackgroundImage:[UIImage imageNamed:@"btn_unsel_favorite.png"] forState:UIControlStateHighlighted];
            [btnPurchase setBackgroundImage:[UIImage imageNamed:@"btn_unsel_favorite.png"] forState:UIControlStateSelected];
        }
        else{
            [btnPurchase setBackgroundImage:[UIImage imageNamed:@"btn_sel_favorite.png"] forState:UIControlStateNormal];
            [btnPurchase setBackgroundImage:[UIImage imageNamed:@"btn_sel_favorite.png"] forState:UIControlStateHighlighted];
            [btnPurchase setBackgroundImage:[UIImage imageNamed:@"btn_sel_favorite.png"] forState:UIControlStateSelected];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableState == TRUE)
        return arrayCurrentFavorite.count;
    else
        return arrayExpireFavorite.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableState == TRUE)
    {
        ProductsWithCategory *obj = [arrayCurrentFavorite objectAtIndex:indexPath.row];
        if (obj.isCategory == TRUE){
            return 41;
        }
        else
            return 94;
    }
    else{
        ProductsWithCategory *obj = [arrayExpireFavorite objectAtIndex:indexPath.row];
        if (obj.isCategory == TRUE){
            return 41;
        }
        else
            return 94;
    }
}
@end
