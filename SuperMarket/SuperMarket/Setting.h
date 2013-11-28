//
//  Setting.h
//  VideoUploading
//
//  Created by phoenix on 10/13/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Setting : NSObject
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *myLanguage;
@property (nonatomic, strong) NSMutableArray *arrayCompany;
@property (nonatomic, strong) NSMutableArray *MainCategories;
@property (nonatomic, strong) NSMutableArray *SubCategories;
@property (nonatomic, strong) NSMutableArray *arrayMeasures;
@property (nonatomic, strong) NSMutableArray *Areas;
@property (nonatomic, strong) NSMutableArray *Cities;
@property (nonatomic, strong) NSMutableArray *myFavoriteList;
@property (nonatomic, strong) NSMutableArray *myPurchaseList;
+ (Setting *)sharedInstance;
@property (strong, nonatomic) UITabBarController *tabBarController;
- (void)customizeTabBar;
- (NSString*)getMeasure:(NSString*)measureID;
- (NSString*)getMainCategoryName:(NSString*)mainCatID;
- (NSString*)getSubCategoryName:(NSString*)subCatID;
- (NSString *)getCityName:(NSString *)cityID;
- (NSString *)getAreaName:(NSString *)areaID;
- (NSString*)getMeasureID:(NSString *)measureName;
- (BOOL)isPurchaseExist:(NSString *)prodID;
- (BOOL)isFavoriteExist:(NSString *)prodID;

- (NSString*)getSortNum:(NSString*)ID withType:(NSString*)responseType;


@end
