//
//  Setting.h
//  VideoUploading
//
//  Created by phoenix on 10/13/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerObject.h"
#import "ProductObject.h"
#import "FriendObject.h"
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
@property (nonatomic, strong) NSMutableArray *arrayFavorite;
@property (nonatomic, strong) NSMutableArray *arrayPurchase;
@property (nonatomic, strong) NSMutableArray *arrayPendingFriends;
@property (nonatomic, strong) NSMutableArray *arrayRealFriends;
@property (nonatomic, strong) NSString *searchSubCatID;
@property (nonatomic, strong) CustomerObject *customer;
@property (nonatomic, strong) FriendObject *myFriend;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, assign) 	BOOL recordResults;
@property(nonatomic, assign) 	BOOL errEncounter;
@property (nonatomic, strong) NSString *errString;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) UITabBarController *ENtabBarController;
@property (strong, nonatomic) UITabBarController *ARtabBarController;
@property (nonatomic, assign) int searchIndex;
@property (nonatomic, strong) NSString *deviceTokenString;
+ (Setting *)sharedInstance;
-(BOOL)checkAndDelete:(NSDate*)endDate withOfferID:(NSString*)offerID;
- (void)customizeTabBar;
- (void)getFriendsFromOnline;
- (NSString*)getMeasure:(NSString*)measureID;
- (NSString*)getMainCategoryName:(NSString*)mainCatID;
- (NSString*)getSubCategoryName:(NSString*)subCatID;
- (NSString *)getCityName:(NSString *)cityID;
- (NSString *)getAreaName:(NSString *)areaID;
- (NSString*)getMeasureID:(NSString *)measureName;
- (NSString*)getCompanyName:(NSString*)companyID;
- (BOOL)isPurchaseExist:(NSString *)prodID;
- (BOOL)isFavoriteExist:(NSString *)prodID;
- (void)loadFavoriteListFromLocalDB:(NSString*)customerID;
- (NSString*)getSortNum:(NSString*)ID withType:(NSString*)responseType;
- (void)addFavoriteProduct:(NSString*)customerID withProdID:(NSString*)prodID withDate:(NSString*)addDate withCompany:(NSString*)companyID;
- (void)removeFavoriteProduct:(NSString*)customerID withProdID:(NSString*)prodID;
- (void)sendFavoriteRequest:(ProductObject*)obj;
- (void)loadPurchaseListFromLocalDB:(NSString*)customerID;

- (void)addPurchaseProduct:(NSString*)customerID withProdID:(NSString*)prodID withDate:(NSString*)addDate withCompany:(NSString*)companyID;
- (void)removePurchaseProduct:(NSString*)customerID withProdID:(NSString*)prodID;
- (void)sendPurchaseRequest:(ProductObject*)obj;
- (NSMutableArray*)getArraySubCategory:(NSString*)mainID;
@end
