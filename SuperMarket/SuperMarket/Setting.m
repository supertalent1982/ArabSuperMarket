//
//  Setting.m
//  VideoUploading
//
//  Created by phoenix on 10/13/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "Setting.h"
#import "Measures.h"
#import "MainCategory.h"
#import "SubCategory.h"
#import "State.h"
#import "Area.h"
#import "ProductObject.h"
static Setting *instance = nil;
@implementation Setting

@synthesize userEmail;
@synthesize myLanguage;
@synthesize arrayCompany;
@synthesize MainCategories;
@synthesize SubCategories;
@synthesize arrayMeasures;
@synthesize Areas;
@synthesize Cities;
@synthesize myFavoriteList;
@synthesize myPurchaseList;
+ (Setting *)sharedInstance
{
    if (instance == nil)
    {
     instance = [[Setting alloc] init];
    }
    
    return instance;
}

- (id)init
{
    self = [super init];
    arrayCompany = [[NSMutableArray alloc]init];
    myFavoriteList = [[NSMutableArray alloc]init];
    myPurchaseList = [[NSMutableArray alloc]init];
    return self;
}

- (void)customizeTabBar{
 //   UITabBar *tabBar = [Setting sharedInstance].tabBarController.tabBar;
  //  [tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg.png"]];
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabbar_bg.png"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
}
- (NSString*)getMainCategoryName:(NSString *)mainCatID
{
    NSString* mainCatName;
    for (int i = 0; i < MainCategories.count; i++)
    {
        MainCategory *mainCat = [MainCategories objectAtIndex:i];
        if ([mainCat.mainCatID isEqualToString:mainCatID]){
            if ([myLanguage isEqualToString:@"En"])
                mainCatName = mainCat.mainCatNameEn;
            else if ([myLanguage isEqualToString:@"Arab"])
                mainCatName = mainCat.mainCatNameAr;
            return mainCatName;
        }
    }
    return @"Unknown";
}
- (NSString*)getMeasureID:(NSString *)measureName
{

    for (int i = 0; i < arrayMeasures.count; i++)
    {
        Measures *measureData = [arrayMeasures objectAtIndex:i];
        NSString *mName;
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            mName = measureData.measureNameEn;
        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
            mName = measureData.measureNameAr;
        
        if ([mName isEqualToString:measureName]){
            return measureData.measureID;
        }
    }
    return @"Unknown";
}

- (NSString *)getMeasure:(NSString *)measureID{
    NSString* measure;
    for (int i = 0; i < arrayMeasures.count; i++)
    {
        Measures *measureData = [arrayMeasures objectAtIndex:i];
        if ([measureData.measureID isEqualToString:measureID]){
            if ([myLanguage isEqualToString:@"En"])
                measure = measureData.measureNameEn;
            else if ([myLanguage isEqualToString:@"Arab"])
                measure = measureData.measureNameAr;
            return measure;
        }
    }
    return @"Unknown";
}
-(NSString *)getSubCategoryName:(NSString *)subCatID{
    NSString* subCatName;
    for (int i = 0; i < SubCategories.count; i++)
    {
        SubCategory *subCat = [SubCategories objectAtIndex:i];
        if ([subCat.subCatID isEqualToString:subCatID]){
            if ([myLanguage isEqualToString:@"En"])
                subCatName = subCat.subCatEn;
            else if ([myLanguage isEqualToString:@"Arab"])
                subCatName = subCat.subCatAr;
            return subCatName;
        }
    }
    return @"Unknown";
}
-(NSString *)getCityName:(NSString *)cityID{
    NSString* cityName;
    for (int i = 0; i < SubCategories.count; i++)
    {
        State *city = [Cities objectAtIndex:i];
        if ([city.stateID isEqualToString:cityID]){
            if ([myLanguage isEqualToString:@"En"])
                cityName = city.stateNameEn;
            else if ([myLanguage isEqualToString:@"Arab"])
                cityName = city.stateNameAr;
            return cityName;
        }
    }
    return @"Unknown";
}
-(NSString *)getAreaName:(NSString *)areaID{
    NSString* areaName;
    for (int i = 0; i < Areas.count; i++)
    {
        Area *area = [Areas objectAtIndex:i];
        if ([area.areaID isEqualToString:areaID]){
            if ([myLanguage isEqualToString:@"En"])
                areaName = area.areaNameEn;
            else if ([myLanguage isEqualToString:@"Arab"])
                areaName = area.areaNameAr;
            return areaName;
        }
    }
    return @"Unknown";
}
- (NSString*)getSortNum:(NSString*)ID withType:(NSString*)responseType;
{
    NSString *sortNum = @"Unknown";
    if ([responseType isEqualToString:@"main"])
    {
        for (int i = 0; i < MainCategories.count; i++)
        {
            MainCategory *obj = [MainCategories objectAtIndex:i];
            if ([obj.mainCatID isEqualToString:ID]){
                sortNum = obj.sort;
                return sortNum;
            }
        }
    }
    if ([responseType isEqualToString:@"sub"])
    {
        for (int i = 0; i < SubCategories.count; i++)
        {
            SubCategory *obj = [SubCategories objectAtIndex:i];
            if ([obj.subCatID isEqualToString:ID]){
                sortNum = obj.sort;
                return sortNum;
            }
        }
    }
    if ([responseType isEqualToString:@"area"])
    {
        for (int i = 0; i < Areas.count; i++)
        {
            Area *obj = [Areas objectAtIndex:i];
            if ([obj.areaID isEqualToString:ID]){
                sortNum = obj.sort;
                return sortNum;
            }
        }
    }
    if ([responseType isEqualToString:@"city"])
    {
        for (int i = 0; i < Cities.count; i++)
        {
            State *obj = [Cities objectAtIndex:i];
            if ([obj.stateID isEqualToString:ID]){
                sortNum = obj.sort;
                return sortNum;
            }
        }
    }
    if ([responseType isEqualToString:@"measure"])
    {
        for (int i = 0; i < arrayMeasures.count; i++)
        {
            Measures *obj = [arrayMeasures objectAtIndex:i];
            if ([obj.measureID isEqualToString:ID]){
                sortNum = obj.sort;
                return sortNum;
            }
        }
    }
    return sortNum;
}
- (BOOL)isPurchaseExist:(NSString *)prodID{

    for (int i = 0; i < self.myPurchaseList.count; i++){
        ProductObject *obj = [self.myPurchaseList objectAtIndex:i];
        if ([obj.prodID isEqualToString:prodID])
            return TRUE;
    }
    return FALSE;
}
- (BOOL)isFavoriteExist:(NSString *)prodID{
    
    for (int i = 0; i < self.myFavoriteList.count; i++){
        ProductObject *obj = [self.myFavoriteList objectAtIndex:i];
        if ([obj.prodID isEqualToString:prodID])
            return TRUE;
    }
    return FALSE;
}
@end
