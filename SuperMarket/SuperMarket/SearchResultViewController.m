//
//  SearchResultViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/24/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "SearchResultViewController.h"
#import "FriendViewController.h"
#import "PPRevealSideViewController.h"
#import "ProductsWithCategory.h"
#import "DetailViewController.h"
#import "Setting.h"
@interface SearchResultViewController ()

@end

@implementation SearchResultViewController
@synthesize arrayProductsWithCategory;
@synthesize lb_title;
@synthesize table_Products;
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
 
}
- (void)viewWillAppear:(BOOL)animated{
    int resNum = 0;
    for (int i = 0; i < arrayProductsWithCategory.count; i++)
    {
        ProductsWithCategory *obj = [arrayProductsWithCategory objectAtIndex:i];
        if (obj.isCategory == FALSE)
            resNum++;
    }
    lb_title.text = [NSString stringWithFormat:@"SearchResult(%d)", resNum];
    /*    [table_Products setBackgroundColor:[UIColor clearColor]];
     UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_back.png"]];
     [tempImageView setFrame:table_Products.frame];
     table_Products.backgroundView = tempImageView;*/
    table_Products.separatorStyle = UITableViewCellSeparatorStyleNone;
    table_Products.backgroundColor = [UIColor clearColor];
    [[Setting sharedInstance].myFavoriteList removeAllObjects];
    [[Setting sharedInstance].myPurchaseList removeAllObjects];
    [[Setting sharedInstance] loadFavoriteListFromLocalDB:[Setting sharedInstance].customer.customerID];
    [[Setting sharedInstance] loadPurchaseListFromLocalDB:[Setting sharedInstance].customer.customerID];
    for (int i = 0; i < arrayProductsWithCategory.count; i++){
        ProductsWithCategory *obj = [arrayProductsWithCategory objectAtIndex:i];
        if (obj.isCategory == FALSE){
            if ([[Setting sharedInstance] isFavoriteExist:obj.obj.prodID] == FALSE)
            {
                obj.obj.prodFavoriteProducts = @"";
            }
            else{
                obj.obj.prodFavoriteProducts = @"true";
            }
            if ([[Setting sharedInstance] isPurchaseExist:obj.obj.prodID] == FALSE)
            {
                obj.obj.prodPurchasedProducts = @"";
            }
            else{
                obj.obj.prodPurchasedProducts = @"true";
            }
        }
    }
    [table_Products reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtnFavorite:(id)sender {
    if (![[Setting sharedInstance].customer.customerID isEqualToString:@"0"]){
        NSIndexPath *indexPath = [table_Products indexPathForCell:(UITableViewCell *)[[sender superview]superview]];
        ProductsWithCategory *catObj = [arrayProductsWithCategory objectAtIndex:indexPath.row];
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
                [[Setting sharedInstance] addFavoriteProduct:[Setting sharedInstance].customer.customerID withProdID:catObj.obj.prodID withDate:catObj.obj.prodAddDate withCompany:catObj.obj.prodCompanyID];
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
        
        [table_Products reloadData];
    }
    else{
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"You must login to add/remove favorite product." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
    }
}

- (IBAction)onBtnPurchase:(id)sender {
    if (![[Setting sharedInstance].customer.customerID isEqualToString:@"0"]){
        NSIndexPath *indexPath = [table_Products indexPathForCell:(UITableViewCell *)[[sender superview]superview]];
        ProductsWithCategory *catObj = [arrayProductsWithCategory objectAtIndex:indexPath.row];
        if (catObj.isCategory == FALSE){
            if ([catObj.obj.prodPurchasedProducts isEqualToString:@""]){
                catObj.obj.prodPurchasedProducts = @"true";
                NSDate *addDate = [[NSDate alloc]init];
                NSDateFormatter *df1 = [[NSDateFormatter alloc]init];
                [df1 setDateFormat:@"dd/MM/yyyy"];
                NSLocale *locale1 = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                [df1 setLocale:locale1];
                NSTimeZone *tz1 = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
                [df1 setTimeZone:tz1];
                catObj.obj.prodAddPurchaseDate = [df1 stringFromDate:addDate];
                [[Setting sharedInstance].myPurchaseList addObject:catObj.obj];
                [[Setting sharedInstance] addPurchaseProduct:[Setting sharedInstance].customer.customerID withProdID:catObj.obj.prodID withDate:catObj.obj.prodAddDate withCompany:catObj.obj.prodCompanyID];
                [[Setting sharedInstance] sendPurchaseRequest:catObj.obj];
            }
            else{
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
            }
        }
        
        [table_Products reloadData];
    }
    else{
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"You must login to add/remove favorite product." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
    }
}

- (IBAction)onFriend:(id)sender {
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // Session is open
    FriendViewController *c = [mainstoryboard instantiateViewControllerWithIdentifier:@"FriendManageView"];
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:c];
    c.navigationController.navigationBarHidden = YES;
    [self.revealSideViewController pushViewController:n onDirection:PPRevealSideDirectionRight withOffset:158 animated:TRUE];
    PP_RELEASE(c);
    PP_RELEASE(n);
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductsWithCategory *catObj = [arrayProductsWithCategory objectAtIndex:indexPath.row];
    if (catObj.isCategory == FALSE){
        UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetailViewController *vc = [mainstoryboard instantiateViewControllerWithIdentifier:@"ProductDetailView"];
        vc.ProductList = arrayProductsWithCategory;
        vc.indexRow = indexPath.row;
        [self presentViewController:vc animated:YES completion:Nil];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductsWithCategory *catObj = [arrayProductsWithCategory objectAtIndex:indexPath.row];
    if (catObj.isCategory == TRUE)
        return 45;
    else
        return 105;
}
-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    ProductsWithCategory *catObj = [arrayProductsWithCategory objectAtIndex:indexPath.row];
    if (catObj.isCategory == TRUE)
    {
        cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"MainCategoryCell"];
        if (cell == Nil)
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCategoryCell"];
        UILabel *lb_mainCat = (UILabel*)[cell viewWithTag:201];
        NSString *mainCatName = [[Setting sharedInstance] getMainCategoryName:catObj.mainID];
        lb_mainCat.text = mainCatName;
    }
    else {
        cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"ProductCell"];
        if (cell == Nil)
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProductCell"];
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
        UILabel *lb_prod_title = (UILabel*)[cell viewWithTag:113];
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            lb_prod_title.text = obj.prodTitleEn;
        }
        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
            lb_prod_title.text = obj.prodTitleAr;
        }
        
        UILabel *lb_date = (UILabel*)[cell viewWithTag:114];
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
            UILabel *lb_price = (UILabel*)[cell viewWithTag:115];
            lb_price.text = [NSString stringWithFormat:@"%@ KD", obj.prodCurPrice];
        }
        UIImageView *imgLine = (UIImageView*)[cell viewWithTag:120];
        imgLine.hidden = YES;
        UILabel *lb_orgPrice = (UILabel*)[cell viewWithTag:116];
        lb_orgPrice.hidden = YES;
        if (![obj.prodOrgPrice isEqualToString:@""]){
            lb_orgPrice.text = [NSString stringWithFormat:@"%@ KD", obj.prodOrgPrice];
            imgLine.hidden = NO;
            lb_orgPrice.hidden = NO;
        }
        
        UIButton *btnFavor = (UIButton*)[cell viewWithTag:117];
        if ([obj.prodFavoriteProducts isEqualToString:@""]){
            [btnFavor setBackgroundImage:[UIImage imageNamed:@"btn_unsel_favorite.png"] forState:UIControlStateNormal];
            [btnFavor setBackgroundImage:[UIImage imageNamed:@"btn_unsel_favorite.png"] forState:UIControlStateHighlighted];
            [btnFavor setBackgroundImage:[UIImage imageNamed:@"btn_unsel_favorite.png"] forState:UIControlStateSelected];
            
        }
        else{
            [btnFavor setBackgroundImage:[UIImage imageNamed:@"btn_sel_favorite.png"] forState:UIControlStateNormal];
            [btnFavor setBackgroundImage:[UIImage imageNamed:@"btn_sel_favorite.png"] forState:UIControlStateHighlighted];
            [btnFavor setBackgroundImage:[UIImage imageNamed:@"btn_sel_favorite.png"] forState:UIControlStateSelected];
        }
        
        UIButton *btnPurchase = (UIButton*)[cell viewWithTag:118];
        if ([obj.prodPurchasedProducts isEqualToString:@""]){
            [btnPurchase setBackgroundImage:[UIImage imageNamed:@"btn_unsel_purchase.png"] forState:UIControlStateNormal];
            [btnPurchase setBackgroundImage:[UIImage imageNamed:@"btn_unsel_purchase.png"] forState:UIControlStateHighlighted];
            [btnPurchase setBackgroundImage:[UIImage imageNamed:@"btn_unsel_purchase.png"] forState:UIControlStateSelected];
        }
        else{
            [btnPurchase setBackgroundImage:[UIImage imageNamed:@"btn_sel_purchase.png"] forState:UIControlStateNormal];
            [btnPurchase setBackgroundImage:[UIImage imageNamed:@"btn_sel_purchase.png"] forState:UIControlStateHighlighted];
            [btnPurchase setBackgroundImage:[UIImage imageNamed:@"btn_sel_purchase.png"] forState:UIControlStateSelected];
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
    
    return arrayProductsWithCategory.count;
    
}

@end
