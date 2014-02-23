//
//  DetailViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/23/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "DetailViewController.h"
#import "Setting.h"
@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize ProductList;
@synthesize indexRow;
@synthesize img_line;
@synthesize img_product;
@synthesize lb_orgPrice;
@synthesize lb_percent;
@synthesize lb_Price;
@synthesize lb_prodDescription;
@synthesize lb_productName;
@synthesize badgeView;
@synthesize btn_favorite;
@synthesize btn_purchase;
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
    ProductsWithCategory *catObj = [ProductList objectAtIndex:indexRow];
    if (catObj.isCategory == FALSE) {
        ProductObject *obj = catObj.obj;
        if (![obj.prodPhotoURL isEqualToString:@""]){
            [img_product setImageURL:[NSURL URLWithString:obj.prodPhotoURL]];
        }
        if ([obj.prodOrgPrice isEqualToString:@""]) {
            badgeView.hidden = YES;
        }
        else{
            badgeView.hidden = NO;
            
        }
        
        NSString *pro = @"%";
        int percents = (int)(([obj.prodOrgPrice floatValue] - [obj.prodCurPrice floatValue]) / [obj.prodOrgPrice floatValue] * 100);
        lb_percent.text = [pro stringByAppendingString:[NSString stringWithFormat:@"%d", percents]];
        NSLog(@"%f", badgeView.frame.origin.x);
        CGRect tmpRect;
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            lb_productName.text = obj.prodTitleEn;
            lb_prodDescription.text = obj.prodDescEn;
            
            lb_productName.textAlignment = NSTextAlignmentLeft;
            lb_prodDescription.textAlignment = NSTextAlignmentLeft;
            self.lb_date.textAlignment = NSTextAlignmentLeft;
            
            tmpRect = badgeView.frame;
            tmpRect.origin.x = 223;
            badgeView.frame = tmpRect;
        }
        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
            lb_productName.text = obj.prodTitleAr;
            lb_prodDescription.text = obj.prodDescAr;
            lb_productName.textAlignment = NSTextAlignmentRight;
            lb_prodDescription.textAlignment = NSTextAlignmentRight;
            self.lb_date.textAlignment = NSTextAlignmentRight;
            
            tmpRect = badgeView.frame;
            tmpRect.origin.x = 20;
            badgeView.frame = tmpRect;
            
        }
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
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            self.lb_date.text = [NSString stringWithFormat:@"From %@ To %@, or until stocks", startTimeStr, endTimeStr];
        else
            self.lb_date.text = [NSString stringWithFormat:@"من %@ الي %@, أو حتي نفاد الكمية", startTimeStr, endTimeStr];
        
        if (![obj.prodCurPrice isEqualToString:@""]){
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                lb_Price.text = [NSString stringWithFormat:@"Price: %@ KD", obj.prodCurPrice];
            else
                lb_Price.text = [NSString stringWithFormat:@"السعر: %@ KD", obj.prodCurPrice];
        }
        img_line.hidden = YES;
        lb_orgPrice.hidden = YES;
        if (![obj.prodOrgPrice isEqualToString:@""]){
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                lb_orgPrice.text = [NSString stringWithFormat:@"Instead of: %@ KD", obj.prodOrgPrice];
            else
                lb_orgPrice.text = [NSString stringWithFormat:@"بدلا من: %@ KD", obj.prodOrgPrice];
            img_line.hidden = NO;
            lb_orgPrice.hidden = NO;
        }
        NSString *imageStr;
        if ([obj.prodFavoriteProducts isEqualToString:@""]){
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
                imageStr = @"arab_unsel_favorite.png";
            else
                imageStr = @"btn_unsel_favorite.png";
        }
        else{
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
                imageStr = @"arab_sel_favorite.png";
            else
                imageStr = @"btn_sel_favorite.png";
        }
        [btn_favorite setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        [btn_favorite setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateHighlighted];
        [btn_favorite setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateSelected];
        
        NSDate *today = [[NSDate alloc]init];
        if ([today compare:prodEndDate] != NSOrderedAscending){
            btn_purchase.userInteractionEnabled = NO;
            btn_purchase.alpha = 0.5;
        }
        if ([obj.prodPurchasedProducts isEqualToString:@""]){
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
                imageStr = @"arab_unsel_purchase.png";
            else
                imageStr = @"btn_unsel_purchase.png";
        }
        else{
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
                imageStr = @"arab_sel_purchase.png";
            else
                imageStr = @"btn_sel_purchase.png";
            
        }
        [btn_purchase setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        [btn_purchase setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateHighlighted];
        [btn_purchase setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateSelected];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPurchase:(id)sender {
    if (![[Setting sharedInstance].customer.customerID isEqualToString:@"0"]){
    ProductsWithCategory *catObj = [ProductList objectAtIndex:indexRow];
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
            [[Setting sharedInstance] addPurchaseProduct:[Setting sharedInstance].customer.customerID withProdID:catObj.obj.prodID withDate:catObj.obj.prodAddPurchaseDate withCompany:catObj.obj.prodCompanyID];
            [[Setting sharedInstance] sendPurchaseRequest:catObj.obj];
            NSString *imageStr;
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
                imageStr = @"arab_sel_purchase.png";
            else
                imageStr = @"btn_sel_purchase.png";

            [btn_purchase setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
            [btn_purchase setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateHighlighted];
            [btn_purchase setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateSelected];
            
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
            NSString *imageStr;
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
                imageStr = @"arab_unsel_purchase.png";
            else
                imageStr = @"btn_unsel_purchase.png";
            
            [btn_purchase setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
            [btn_purchase setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateHighlighted];
            [btn_purchase setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateSelected];
            
        }
    }
    }
    else{
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                        message:@" الرجاء تسجيل الدخول لإضافة/حذف المشتريات" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
            
            [mes show];
        }else{
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"You must login to add/remove purchase product." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        }
    }
}

- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)onFavorite:(id)sender {
    if (![[Setting sharedInstance].customer.customerID isEqualToString:@"0"]){
    ProductsWithCategory *catObj = [ProductList objectAtIndex:indexRow];

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
            NSString *imageStr;
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
                imageStr = @"arab_sel_favorite.png";
            else
                imageStr = @"btn_sel_favorite.png";

            [btn_favorite setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
            [btn_favorite setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateHighlighted];
            [btn_favorite setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateSelected];
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
            NSString *imageStr;
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
                imageStr = @"arab_unsel_favorite.png";
            else
                imageStr = @"btn_unsel_favorite.png";
            
            [btn_favorite setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
            [btn_favorite setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateHighlighted];
            [btn_favorite setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateSelected];
            
        }
    }
    }
    else{
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                        message:@" الرجاء تسجيل الدخول لإضافة/حذف المفضله" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
            
            [mes show];
        }else{
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"You must login to add/remove favorite product." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        }
    }
}
@end
