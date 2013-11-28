//
//  ProductViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/16/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "ProductViewController.h"
#import "FriendViewController.h"
#import "DetailViewController.h"
#import "PPRevealSideViewController.h"
#import "Setting.h"
@interface ProductViewController ()
@property (nonatomic, assign) BOOL errEncounter;
@property (nonatomic, assign) int categories;
@end

@implementation ProductViewController
@synthesize selOffer;
@synthesize arrayProduct;
@synthesize xmlParser;
@synthesize webData;
@synthesize recordResults;
@synthesize soapResults;
@synthesize productObj;
@synthesize errEncounter;
@synthesize table_Products;
@synthesize lb_endDate;
@synthesize lb_OfferDesc;
@synthesize lb_OfferTitle;
@synthesize lb_remainDays;
@synthesize lb_startDate;
@synthesize lb_title;
@synthesize searchBar;
@synthesize offerStartDate;
@synthesize offerStopDate;
@synthesize categories;
@synthesize arrayProductsWithCategory;
@synthesize progressBar;
@synthesize progressBarBg;- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        lb_OfferTitle.text = selOffer.offerTitleEn;
        lb_OfferDesc.text = selOffer.offerDescEn;
    }
    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
        lb_OfferTitle.text = selOffer.offerTitleAr;
        lb_OfferDesc.text = selOffer.offerDescAr;
    }
    lb_title.text = self.companyName;
    NSString *startTimeStr = [selOffer.offerStartDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];

    NSString *endTimeStr = [selOffer.offerEndDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [df setLocale:locale];
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [df setTimeZone:tz];
    offerStartDate = [df dateFromString:startTimeStr];
    [df setDateFormat:@"YYYY/MM/dd"];
    startTimeStr = [df stringFromDate:offerStartDate];
    lb_startDate.text = startTimeStr;
    
    
    NSDateFormatter *df1 = [[NSDateFormatter alloc]init];
    [df1 setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSLocale *locale1 = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [df1 setLocale:locale1];
    NSTimeZone *tz1 = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [df1 setTimeZone:tz1];
    offerStopDate = [df1 dateFromString:endTimeStr];
    [df1 setDateFormat:@"YYYY/MM/dd"];
    endTimeStr = [df1 stringFromDate:offerStopDate];
    lb_endDate.text = endTimeStr;
    NSDate *today = [[NSDate alloc]init];

        if ([today compare:offerStopDate] == NSOrderedAscending){
            NSCalendar *sysCalendar = [NSCalendar currentCalendar];
            // Get conversion to months, days, hours, minutes
            unsigned int unitFlags = NSDayCalendarUnit;
            
            NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:today  toDate:offerStopDate  options:0];
            int after_days = [conversionInfo day];
            lb_remainDays.text = [NSString stringWithFormat:@"%d", after_days];
            
            NSDateComponents *conversionInfo1 = [sysCalendar components:unitFlags fromDate:offerStartDate  toDate:offerStopDate  options:0];
            int duration_days = [conversionInfo1 day];
            if (duration_days <= after_days)
                progressBar.progress = 0;
            else
            {
                float days = (float)(duration_days - after_days) / duration_days;
                progressBar.progress = days;
            }
            
        }
        else{
            lb_remainDays.text = @"0";
            progressBar.progress = 1;
        }
        

    
    self.btnCancel.hidden = YES;
    self.searchBar.hidden = YES;
    self.searchBar.placeholder=@"search in products";
    self.searchBar.backgroundColor=[UIColor clearColor];
    self.searchBar.backgroundImage = [UIImage new];
    
    self.searchBar.delegate = self ;
    [self.searchBar setTranslucent:YES];
    //remove background of searchbar
    for (UIView *subview in self.searchBar.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    }
    [progressBar setProgressTintColor:[UIColor greenColor]];
 //   [progressBar setTrackImage:[UIImage imageNamed:@"progressbar.png"]];

    CGRect tmpRect = progressBar.frame;
    tmpRect.origin.y = progressBarBg.frame.origin.y + (progressBarBg.frame.size.height - tmpRect.size.height) / 2;
    [progressBar setFrame:tmpRect];
        table_Products.separatorStyle = UITableViewCellSeparatorStyleNone;
    table_Products.backgroundColor = [UIColor clearColor];
  /*  [table_Products setBackgroundColor:[UIColor clearColor]];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_back.png"]];
    [tempImageView setFrame:table_Products.frame];
    table_Products.backgroundView = tempImageView;*/
    [[Setting sharedInstance].myFavoriteList removeAllObjects];
    [[Setting sharedInstance].myPurchaseList removeAllObjects];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<GetOfferProducts xmlns=\"http://tempuri.org/\">\n"
                             "<OfferID>%@</OfferID>\n"
                             "<LastUpdateTime>%@</LastUpdateTime>\n"
                             "<CustomerID>0</CustomerID>\n"
                             "</GetOfferProducts>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", selOffer.offerID, @"2013-07-15T00:00:00"];
	NSLog(@"soapMessage = %@\n", soapMessage);
    
    
	NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=GetOfferProducts"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://tempuri.org/GetOfferProducts" forHTTPHeaderField:@"SOAPAction"];
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
    arrayProductsWithCategory = [[NSMutableArray alloc]init];
 }
-(void)viewWillAppear:(BOOL)animated{
    [table_Products reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnSearch:(id)sender {
    self.btnback.hidden = YES;
    self.btnSearch.hidden = YES;
    self.btnShare.hidden = YES;
    self.btnCancel.hidden = NO;
    self.searchBar.hidden = NO;
    self.searchBar.text = @"";
    [self.searchBar becomeFirstResponder];
}

- (IBAction)onBtnShare:(id)sender {
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // Session is open
    FriendViewController *c = [mainstoryboard instantiateViewControllerWithIdentifier:@"FriendManageView"];
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:c];
    c.navigationController.navigationBarHidden = YES;
    [self.revealSideViewController pushViewController:n onDirection:PPRevealSideDirectionRight withOffset:158 animated:TRUE];
    PP_RELEASE(c);
    PP_RELEASE(n);
}
- (IBAction)onBtnCancel:(id)sender {
    self.btnCancel.hidden = YES;
    [self.searchBar resignFirstResponder];
    self.searchBar.hidden = YES;
    self.btnback.hidden = NO;
    self.btnShare.hidden = NO;
    self.btnSearch.hidden = NO;
    [arrayProductsWithCategory removeAllObjects];
    [self sortArrayProduct:arrayProduct];
    [table_Products reloadData];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    NSString *searchText = [self.searchBar.text lowercaseString];
    [arrayProductsWithCategory removeAllObjects];
    NSMutableArray *arraySearchResult = [[NSMutableArray alloc]init];
    for (int i = 0; i < arrayProduct.count; i++)
    {
        ProductObject *obj = [arrayProduct objectAtIndex:i];
        NSString *titleStr;
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            titleStr = [obj.prodTitleEn lowercaseString];
        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
            titleStr = obj.prodTitleAr;
        
        if ([titleStr rangeOfString:searchText].location != NSNotFound) {
            [arraySearchResult addObject:obj];
        }
    }
    [self sortArrayProduct:arraySearchResult];
    [table_Products reloadData];
}

- (IBAction)onBtnFavorite:(id)sender {
    NSIndexPath *indexPath = [table_Products indexPathForCell:(UITableViewCell *)[[sender superview]superview]];
    ProductsWithCategory *catObj = [arrayProductsWithCategory objectAtIndex:indexPath.row];
    if (catObj.isCategory == FALSE){
        if ([catObj.obj.prodFavoriteProducts isEqualToString:@""]){
            catObj.obj.prodFavoriteProducts = @"true";
            [[Setting sharedInstance].myFavoriteList addObject:catObj.obj];
        }
        else{
            catObj.obj.prodFavoriteProducts = @"";
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

    [table_Products reloadData];
}

- (IBAction)onBtnPurchase:(id)sender {
    NSIndexPath *indexPath = [table_Products indexPathForCell:(UITableViewCell *)[[sender superview]superview]];
    ProductsWithCategory *catObj = [arrayProductsWithCategory objectAtIndex:indexPath.row];
    if (catObj.isCategory == FALSE){
        if ([catObj.obj.prodPurchasedProducts isEqualToString:@""]){
            catObj.obj.prodPurchasedProducts = @"true";
            [[Setting sharedInstance].myPurchaseList addObject:catObj.obj];
        }
        else{
            catObj.obj.prodPurchasedProducts = @"";
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
    
    [table_Products reloadData];
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

-(void)sortArrayProduct:(NSMutableArray*)_arrayProduct{
    
    if (_arrayProduct.count > 1){
        for (int i = 0; i < _arrayProduct.count - 1; i++){
            ProductObject *tmpObj = [_arrayProduct objectAtIndex:i];
            ProductObject *firstObj = [_arrayProduct objectAtIndex:i];
            int index = i;
            for (int j = i + 1; j < _arrayProduct.count; j++){
                ProductObject *secondObj = [_arrayProduct objectAtIndex:j];
                NSString *sortNum1 = [[Setting sharedInstance] getSortNum:tmpObj.prodMainCatID withType:@"main"];
                NSString *sortNum2 = [[Setting sharedInstance] getSortNum:secondObj.prodMainCatID withType:@"main"];
                if ([sortNum1 intValue] >= [sortNum2 intValue]) {
                    if ([sortNum1 intValue] > [sortNum2 intValue]){
                        tmpObj = secondObj;
                        index = j;
                    }
                    else {
                            sortNum1 = [[Setting sharedInstance] getSortNum:tmpObj.prodSubCatID withType:@"sub"];
                            sortNum2 = [[Setting sharedInstance] getSortNum:secondObj.prodSubCatID withType:@"sub"];
                        
                            if (sortNum1 > sortNum2)
                            {
                                tmpObj = secondObj;
                                index = j;
                            }
                    }
                }
            }
            
            [_arrayProduct replaceObjectAtIndex:i withObject:tmpObj];
            [_arrayProduct replaceObjectAtIndex:index withObject:firstObj];
            
        }
    }
    int mainCategory = -1;
    for (int i = 0; i < _arrayProduct.count; i++){
        ProductObject *obj = [_arrayProduct objectAtIndex:i];
        ProductsWithCategory *catObj = [[ProductsWithCategory alloc]init];
        if (![obj.prodFavoriteProducts isEqualToString:@""]){
            if ([[Setting sharedInstance] isFavoriteExist:obj.prodID] == FALSE)
                [[Setting sharedInstance].myFavoriteList addObject:obj];
        }
        if (![obj.prodPurchasedProducts isEqualToString:@""]){
            if ([[Setting sharedInstance] isPurchaseExist:obj.prodID] == FALSE)
                [[Setting sharedInstance].myPurchaseList addObject:obj];
        }
        if (mainCategory != [obj.prodMainCatID intValue])
        {
            catObj.isCategory = TRUE;
            catObj.obj = Nil;
            catObj.mainID = obj.prodMainCatID;
            catObj.subID = obj.prodSubCatID;
            [arrayProductsWithCategory addObject:catObj];
            ProductsWithCategory *conObj = [[ProductsWithCategory alloc]init];
            conObj.isCategory = FALSE;
            conObj.obj = obj;
            [arrayProductsWithCategory addObject:conObj];
        }
        else
        {
            catObj.isCategory = FALSE;
            catObj.obj = obj;
            [arrayProductsWithCategory addObject:catObj];
        }
        mainCategory = [obj.prodMainCatID intValue];
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

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	if( [elementName isEqualToString:@"ProductResult"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        if (!productObj)
            productObj = [[ProductObject alloc]init];
        
    }
    if ([elementName isEqualToString:@"ErrMessage"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    
    if ([elementName isEqualToString:@"GetOfferProductsResult"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        arrayProduct = Nil;
        arrayProduct = [[NSMutableArray alloc]init];
        
    }
    
    if ([elementName isEqualToString:@"ID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"OfferID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Quantity"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"MainCatID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"MeasureID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"SubCatID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"OrgPrice"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Price"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Photo"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"DescAr"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"DescEn"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"StartDate"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"EndDate"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"BranchList"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"VisitsCount"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"TitleAr"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"TitleEn"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"IsActive"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"lastUpdateTime"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"FavoriteProducts"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"HomeOrderProducts"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"PurchasedProducts"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if( recordResults )
	{
		[soapResults appendString: string];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"ErrMessage"]){
        recordResults = FALSE;
        if (![soapResults isEqualToString:@""])
            errEncounter = TRUE;
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"GetOfferProductsResult"])
	{
		recordResults = FALSE;
        soapResults = nil;
        if (errEncounter == TRUE)
        {
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"The product data can't be fetched from server." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [mes show];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        [self sortArrayProduct:arrayProduct];
        [table_Products reloadData];
	}
    if( [elementName isEqualToString:@"ProductResult"])
	{
		recordResults = FALSE;
        [arrayProduct addObject:productObj];
        soapResults = nil;
        productObj = nil;
	}
    if ([elementName isEqualToString:@"ID"]){
        recordResults = FALSE;
        productObj.prodID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"OfferID"])
    {
        recordResults = FALSE;
        productObj.OfferID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Quantity"])
    {
        recordResults = FALSE;
        productObj.prodQuantity = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"MainCatID"])
    {
        recordResults = FALSE;
        productObj.prodMainCatID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"MeasureID"])
    {
        recordResults = FALSE;
        productObj.prodMeasureID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"SubCatID"])
    {
        recordResults = FALSE;
        productObj.prodSubCatID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"OrgPrice"])
    {
        recordResults = FALSE;
        productObj.prodOrgPrice = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Price"])
    {
        recordResults = FALSE;
        productObj.prodCurPrice = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Photo"])
    {
        recordResults = FALSE;
        productObj.prodPhotoURL = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"DescAr"])
    {
        recordResults = FALSE;
        productObj.prodDescAr = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"DescEn"])
    {
        recordResults = FALSE;
        productObj.prodDescEn = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"StartDate"])
    {
        recordResults = FALSE;
        productObj.prodStartDate = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"EndDate"])
    {
        recordResults = FALSE;
        productObj.prodEndDate = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"BranchList"])
    {
        recordResults = FALSE;
        productObj.prodBranchList = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"VisitsCount"])
    {
        recordResults = FALSE;
        productObj.prodVisitsCount = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"TitleAr"])
    {
        recordResults = FALSE;
        productObj.prodTitleAr = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"TitleEn"])
    {
        recordResults = FALSE;
        productObj.prodTitleEn = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"IsActive"])
    {
        recordResults = FALSE;
        productObj.prodIsActive = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"lastUpdateTime"])
    {
        recordResults = FALSE;
        productObj.prodlastUpdateTime = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"FavoriteProducts"])
    {
        recordResults = FALSE;
        productObj.prodFavoriteProducts = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"HomeOrderProducts"])
    {
        recordResults = FALSE;
        productObj.prodHomeOrderProducts = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"PurchasedProducts"])
    {
        recordResults = FALSE;
        productObj.prodPurchasedProducts = soapResults;
        soapResults = nil;
    }
}
@end
