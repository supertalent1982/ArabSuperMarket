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
#import "CompanyObject.h"
#import <sqlite3.h>
static Setting *instance = nil;
@implementation Setting
{
    sqlite3 *projectDB;
    NSString *databasePath;
}
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
@synthesize xmlParser;
@synthesize webData;
@synthesize recordResults;
@synthesize soapResults;
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
    self.customer = [[CustomerObject alloc]init];
    return self;
}

- (void)customizeTabBar{
 //   UITabBar *tabBar = [Setting sharedInstance].tabBarController.tabBar;
  //  [tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg.png"]];
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabbar_bg.png"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
}
- (void)addPurchaseProduct:(NSString*)customerID withProdID:(NSString*)prodID withDate:(NSString*)addDate withCompany:(NSString*)companyID{

    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Q8SuperMarketDB.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == YES)
    {
        sqlite3_stmt    *statement;
        
        
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
        {
            
            NSString *querySQL = [NSString stringWithFormat: @"INSERT INTO PurchasedProducts (CustomerID, ProductID, InsertDate, CompanyID) VALUES (\"%@\", \"%@\", \"%@\", \"%@\")", customerID, prodID, addDate, companyID];
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"purchase product insert success");
                    
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(projectDB);
        }
    }
}
- (void)removePurchaseProduct:(NSString*)customerID withProdID:(NSString*)prodID{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Q8SuperMarketDB.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == YES)
    {
        sqlite3_stmt    *statement;
        
        
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
        {
            
            NSString *querySQL = [NSString stringWithFormat: @"DELETE FROM PurchasedProducts WHERE CustomerID = \"%@\" and ProductID = \"%@\"", customerID, prodID];
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"purchase product remove success");
                    
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(projectDB);
        }
    }
}
- (void)sendPurchaseRequest:(ProductObject*)obj{
    int myLang = 0;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
        myLang = 1;
    }
    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        myLang = 2;
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<PurchasesAddProduct xmlns=\"http://tempuri.org/\">\n"
                             "<CustomerID>%@</CustomerID>\n"
                             "<ProductID>%@</ProductID>\n"
                             "<Language>%d</Language>\n"
                             "</PurchasesAddProduct>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", [Setting sharedInstance].customer.customerID, obj.prodID, myLang];
	NSLog(@"soapMessage = %@\n", soapMessage);
    
	NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=PurchasesAddProduct"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://tempuri.org/PurchasesAddProduct" forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if( theConnection )
	{
		webData = [[NSMutableData alloc]init];
	}
	else
	{
		NSLog(@"theConnection is NULL");
	}
}
- (void)addFavoriteProduct:(NSString*)customerID withProdID:(NSString*)prodID withDate:(NSString*)addDate withCompany:(NSString*)companyID{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Q8SuperMarketDB.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];

    if ([filemgr fileExistsAtPath: databasePath ] == YES)
    {
        sqlite3_stmt    *statement;
        
        
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
        {
            
            NSString *querySQL = [NSString stringWithFormat: @"INSERT INTO FavoriteProducts (CustomerID, ProductID, InsertDate, CompanyID) VALUES (\"%@\", \"%@\", \"%@\", \"%@\")", customerID, prodID, addDate, companyID];
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"favorite product insert success");
                    
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(projectDB);
        }
    }
}
- (void)removeFavoriteProduct:(NSString*)customerID withProdID:(NSString*)prodID{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Q8SuperMarketDB.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == YES)
    {
        sqlite3_stmt    *statement;
        
        
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
        {
            
            NSString *querySQL = [NSString stringWithFormat: @"DELETE FROM FavoriteProducts WHERE CustomerID = \"%@\" and ProductID = \"%@\"", customerID, prodID];
            const char *query_stmt = [querySQL UTF8String];

            if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"favorite product remove success");
                    
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(projectDB);
        }
    }

}
- (void)loadPurchaseListFromLocalDB:(NSString *)customerID{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Q8SuperMarketDB.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    self.myPurchaseList = nil;
    self.myPurchaseList = [[NSMutableArray alloc]init];
    if ([filemgr fileExistsAtPath: databasePath ] == YES)
    {
        sqlite3_stmt    *statement;
        
        
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
        {
            
            NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM PurchasedProducts where CustomerID = \"%@\"", customerID];
            const char *query_stmt = [querySQL UTF8String];
            self.arrayPurchase = [[NSMutableArray alloc]init];
            if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    
                    ProductObject *obj = [[ProductObject alloc]init];
                    obj.prodID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    obj.prodAddPurchaseDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                    obj.prodCompanyID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                    
                    [self.arrayPurchase addObject:obj];
                    
                    
                }
                sqlite3_finalize(statement);
            }
            for (int i = 0; i < self.arrayPurchase.count; i++) {
                ProductObject *obj = [self.arrayPurchase objectAtIndex:i];
                NSString *querySQL1 = [NSString stringWithFormat: @"SELECT * FROM Products where ID = \"%@\"", obj.prodID];
                const char *query_stmt1 = [querySQL1 UTF8String];
                
                if (sqlite3_prepare_v2(projectDB, query_stmt1, -1, &statement, NULL) == SQLITE_OK)
                {
                    while (sqlite3_step(statement) == SQLITE_ROW) {
                        obj.OfferID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                        obj.prodQuantity = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                        obj.prodMainCatID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                        obj.prodMeasureID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                        obj.prodSubCatID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                        obj.prodOrgPrice = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                        obj.prodCurPrice = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                        obj.prodPhotoURL = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                        obj.prodDescAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
                        obj.prodDescEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
                        obj.prodStartDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)];
                        obj.prodEndDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
                        obj.prodBranchList = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 13)];
                        obj.prodVisitsCount = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 14)];
                        obj.prodTitleAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 15)];
                        obj.prodTitleEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 16)];
                        obj.prodIsActive = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 17)];
                        obj.prodlastUpdateTime = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 18)];
                        obj.prodPurchasedProducts = @"true";
                        
                    }
                    sqlite3_finalize(statement);
                }
                
                [self.myPurchaseList addObject:obj];
            }
            sqlite3_close(projectDB);
        }
        
    }
}
- (void)loadFavoriteListFromLocalDB:(NSString*)customerID{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Q8SuperMarketDB.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    self.myFavoriteList = nil;
    self.myFavoriteList = [[NSMutableArray alloc]init];
    if ([filemgr fileExistsAtPath: databasePath ] == YES)
    {
        sqlite3_stmt    *statement;
        
        
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
        {
            
            NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM FavoriteProducts where CustomerID = \"%@\"", customerID];
            const char *query_stmt = [querySQL UTF8String];
            self.arrayFavorite = [[NSMutableArray alloc]init];
            if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    
                    ProductObject *obj = [[ProductObject alloc]init];
                    obj.prodID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    obj.prodAddDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                    obj.prodCompanyID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                    
                    [self.arrayFavorite addObject:obj];
                    
                    
                }
                sqlite3_finalize(statement);
            }
            for (int i = 0; i < self.arrayFavorite.count; i++) {
                ProductObject *obj = [self.arrayFavorite objectAtIndex:i];
                NSString *querySQL1 = [NSString stringWithFormat: @"SELECT * FROM Products where ID = \"%@\"", obj.prodID];
                const char *query_stmt1 = [querySQL1 UTF8String];

                if (sqlite3_prepare_v2(projectDB, query_stmt1, -1, &statement, NULL) == SQLITE_OK)
                {
                    while (sqlite3_step(statement) == SQLITE_ROW) {
                        obj.OfferID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                        obj.prodQuantity = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                        obj.prodMainCatID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                        obj.prodMeasureID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                        obj.prodSubCatID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                        obj.prodOrgPrice = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                        obj.prodCurPrice = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                        obj.prodPhotoURL = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                        obj.prodDescAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
                        obj.prodDescEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
                        obj.prodStartDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)];
                        obj.prodEndDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
                        obj.prodBranchList = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 13)];
                        obj.prodVisitsCount = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 14)];
                        obj.prodTitleAr = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 15)];
                        obj.prodTitleEn = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 16)];
                        obj.prodIsActive = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 17)];
                        obj.prodlastUpdateTime = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 18)];
                        obj.prodFavoriteProducts = @"true";
                        
                    }
                    sqlite3_finalize(statement);
                }
                
                [self.myFavoriteList addObject:obj];
            }
            sqlite3_close(projectDB);
        }

    }
    
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
- (NSString*)getCompanyName:(NSString*)companyID{
    NSString* companyName;
    for (int i = 0; i < arrayCompany.count; i++)
    {
        CompanyObject *obj = [arrayCompany objectAtIndex:i];
        if ([obj.companyID isEqualToString:companyID]){
            if ([myLanguage isEqualToString:@"En"])
                companyName = obj.companyNameEn;
            else if ([myLanguage isEqualToString:@"Arab"])
                companyName = obj.companyNameAr;
            return companyName;
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
    if ([responseType isEqualToString:@"company"])
        
    {
        for (int i = 0; i < arrayCompany.count; i++) {
            CompanyObject *obj = [arrayCompany objectAtIndex:i];
            if ([obj.companyID isEqualToString:ID]){
                sortNum = obj.companyOverallSort;
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
- (void)sendFavoriteRequest:(ProductObject*)obj{
    int myLang = 0;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
        myLang = 1;
    }
    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        myLang = 2;
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<FavoriteAddProduct xmlns=\"http://tempuri.org/\">\n"
                             "<CustomerID>%@</CustomerID>\n"
                             "<ProductID>%@</ProductID>\n"
                             "<Language>%d</Language>\n"
                             "</FavoriteAddProduct>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", [Setting sharedInstance].customer.customerID, obj.prodID, myLang];
	NSLog(@"soapMessage = %@\n", soapMessage);
    
	NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=FavoriteAddProduct"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://tempuri.org/FavoriteAddProduct" forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if( theConnection )
	{
		webData = [[NSMutableData alloc]init];
	}
	else
	{
		NSLog(@"theConnection is NULL");
	}
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"ERROR with theConenction");
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"DONE. Received Bytes: %d", [webData length]);
	NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	NSLog(@"response XML = %@\n", theXML);
    
    xmlParser = Nil;
	xmlParser = [[NSXMLParser alloc] initWithData: webData];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
	
}
- (NSMutableArray*)getArraySubCategory:(NSString*)mainID{
    NSMutableArray *arraySubCategory = [[NSMutableArray alloc]init];
    for (int i = 0; i < [Setting sharedInstance].SubCategories.count; i++) {
        SubCategory *obj = [[Setting sharedInstance].SubCategories objectAtIndex:i];
        if ([obj.mainCatID isEqualToString:mainID]) {
            [arraySubCategory addObject:obj];
        }
    }
    
    return arraySubCategory;
}
@end
