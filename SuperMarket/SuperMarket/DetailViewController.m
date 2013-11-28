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
        
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            lb_productName.text = obj.prodTitleEn;
            lb_prodDescription.text = obj.prodDescEn;
            
        }
        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
            lb_productName.text = obj.prodTitleAr;
            lb_prodDescription.text = obj.prodDescAr;
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
        self.lb_date.text = [NSString stringWithFormat:@"From %@ To %@, or until stocks", startTimeStr, endTimeStr];
        
        if (![obj.prodCurPrice isEqualToString:@""]){
            lb_Price.text = [NSString stringWithFormat:@"Price: %@ KD", obj.prodCurPrice];
        }
        img_line.hidden = YES;
        lb_orgPrice.hidden = YES;
        if (![obj.prodOrgPrice isEqualToString:@""]){
            lb_orgPrice.text = [NSString stringWithFormat:@"Instead of: %@ KD", obj.prodOrgPrice];
            img_line.hidden = NO;
            lb_orgPrice.hidden = NO;
        }
        
        
        if ([obj.prodFavoriteProducts isEqualToString:@""]){
            [btn_favorite setBackgroundImage:[UIImage imageNamed:@"btn_unsel_favorite.png"] forState:UIControlStateNormal];
            [btn_favorite setBackgroundImage:[UIImage imageNamed:@"btn_unsel_favorite.png"] forState:UIControlStateHighlighted];
            [btn_favorite setBackgroundImage:[UIImage imageNamed:@"btn_unsel_favorite.png"] forState:UIControlStateSelected];
            
        }
        else{
            [btn_favorite setBackgroundImage:[UIImage imageNamed:@"btn_sel_favorite.png"] forState:UIControlStateNormal];
            [btn_favorite setBackgroundImage:[UIImage imageNamed:@"btn_sel_favorite.png"] forState:UIControlStateHighlighted];
            [btn_favorite setBackgroundImage:[UIImage imageNamed:@"btn_sel_favorite.png"] forState:UIControlStateSelected];
        }
        

        if ([obj.prodPurchasedProducts isEqualToString:@""]){
            [btn_purchase setBackgroundImage:[UIImage imageNamed:@"btn_unsel_purchase.png"] forState:UIControlStateNormal];
            [btn_purchase setBackgroundImage:[UIImage imageNamed:@"btn_unsel_purchase.png"] forState:UIControlStateHighlighted];
            [btn_purchase setBackgroundImage:[UIImage imageNamed:@"btn_unsel_purchase.png"] forState:UIControlStateSelected];
        }
        else{
            [btn_purchase setBackgroundImage:[UIImage imageNamed:@"btn_sel_purchase.png"] forState:UIControlStateNormal];
            [btn_purchase setBackgroundImage:[UIImage imageNamed:@"btn_sel_purchase.png"] forState:UIControlStateHighlighted];
            [btn_purchase setBackgroundImage:[UIImage imageNamed:@"btn_sel_purchase.png"] forState:UIControlStateSelected];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPurchase:(id)sender {
    ProductsWithCategory *catObj = [ProductList objectAtIndex:indexRow];
    if (catObj.isCategory == FALSE){
        if ([catObj.obj.prodPurchasedProducts isEqualToString:@""]){
            catObj.obj.prodPurchasedProducts = @"true";
            [btn_purchase setBackgroundImage:[UIImage imageNamed:@"btn_sel_purchase.png"] forState:UIControlStateNormal];
            [btn_purchase setBackgroundImage:[UIImage imageNamed:@"btn_sel_purchase.png"] forState:UIControlStateHighlighted];
            [btn_purchase setBackgroundImage:[UIImage imageNamed:@"btn_sel_purchase.png"] forState:UIControlStateSelected];
            [[Setting sharedInstance].myPurchaseList addObject:catObj.obj];
        }
        else{
            catObj.obj.prodPurchasedProducts = @"";
            [btn_purchase setBackgroundImage:[UIImage imageNamed:@"btn_unsel_purchase.png"] forState:UIControlStateNormal];
            [btn_purchase setBackgroundImage:[UIImage imageNamed:@"btn_unsel_purchase.png"] forState:UIControlStateHighlighted];
            [btn_purchase setBackgroundImage:[UIImage imageNamed:@"btn_unsel_purchase.png"] forState:UIControlStateSelected];
            for (int i = 0; i < [Setting sharedInstance].myPurchaseList.count; i++){
                ProductObject *obj = [[Setting sharedInstance].myPurchaseList objectAtIndex:i];
                if ([obj.prodID isEqualToString:catObj.obj.prodID])
                {
                    [[Setting sharedInstance].myPurchaseList removeObjectAtIndex:i];
                    break;
                }
            }
        }
    }
}

- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)onFavorite:(id)sender {
    ProductsWithCategory *catObj = [ProductList objectAtIndex:indexRow];
    if (catObj.isCategory == FALSE){
        if ([catObj.obj.prodFavoriteProducts isEqualToString:@""]){
            catObj.obj.prodFavoriteProducts = @"true";
            [[Setting sharedInstance].myFavoriteList addObject:catObj.obj];
            [btn_favorite setBackgroundImage:[UIImage imageNamed:@"btn_sel_favorite.png"] forState:UIControlStateNormal];
            [btn_favorite setBackgroundImage:[UIImage imageNamed:@"btn_sel_favorite.png"] forState:UIControlStateHighlighted];
            [btn_favorite setBackgroundImage:[UIImage imageNamed:@"btn_sel_favorite.png"] forState:UIControlStateSelected];
        }
        else{
            catObj.obj.prodFavoriteProducts = @"";
            [btn_favorite setBackgroundImage:[UIImage imageNamed:@"btn_unsel_favorite.png"] forState:UIControlStateNormal];
            [btn_favorite setBackgroundImage:[UIImage imageNamed:@"btn_unsel_favorite.png"] forState:UIControlStateHighlighted];
            [btn_favorite setBackgroundImage:[UIImage imageNamed:@"btn_unsel_favorite.png"] forState:UIControlStateSelected];
            for (int i = 0; i < [Setting sharedInstance].myFavoriteList.count; i++){
                ProductObject *obj = [[Setting sharedInstance].myFavoriteList objectAtIndex:i];
                if ([obj.prodID isEqualToString:catObj.obj.prodID])
                {
                    [[Setting sharedInstance].myFavoriteList removeObjectAtIndex:i];
                    break;
                }
            }
        }
    }
}
@end
