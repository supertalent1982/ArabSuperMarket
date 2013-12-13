//
//  SearchViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/1/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "SearchViewController.h"
#import "Setting.h"
#import "CompanyObject.h"
#import "State.h"
#import "Area.h"
#import "MainCategory.h"
#import "SubCategory.h"
#import "ProductsWithCategory.h"
#import "SearchResultViewController.h"
@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize productArray;
@synthesize searchResultArray;
@synthesize productObj;
@synthesize search_list;
@synthesize lb_header;
@synthesize tableView;
@synthesize searchBar;
@synthesize searchText;
@synthesize selectView;
@synthesize subCatID;
@synthesize supermarketID;
@synthesize mainCatID;
@synthesize cityID;
@synthesize priceFrom;
@synthesize priceTo;
@synthesize selectPicker;
@synthesize dataList;
@synthesize selectType;
@synthesize customerID;
@synthesize offerID;
@synthesize myLang;
@synthesize xmlParser;
@synthesize webData;
@synthesize recordResults;
@synthesize soapResults;
@synthesize selIndex;
@synthesize lb_pickerTitle;
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
    search_list = [[NSMutableArray alloc]init];
    [search_list addObject:@"Select All"];
    [search_list addObject:@"Select Supermarket"];
    [search_list addObject:@"Select Main-Category"];
    [search_list addObject:@"Select Sub-Category"];
    [search_list addObject:@"Price start from"];
    [search_list addObject:@"Price to"];
    [search_list addObject:@"Select City"];
    dataList = [[NSMutableArray alloc]init];
    lb_header.text = @"Search";
    searchBar.placeholder = @"Search...";
    selectView.hidden = YES;
    CGRect tmpRect = selectView.frame;
    tmpRect.origin.y = self.view.frame.size.height;
    [selectView setFrame:tmpRect];
    selectType = -1;

    
    supermarketID = @"0";
    mainCatID = @"0";
    subCatID = @"0";
    cityID = @"";
    priceFrom = @"-1";
    priceTo = @"-1";
    offerID = @"0";
    customerID = @"0";
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        myLang = 1;
    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        myLang = 2;
    soapResults = Nil;
    recordResults = FALSE;
    selIndex = -1;
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        UITextField *txtAlert = [actionSheet textFieldAtIndex:0];
        if([txtAlert.text length]==0) {
            selectType = -1;
            return ;
        }
        else{
            if (selectType == 3)
                priceFrom = txtAlert.text;
            else if (selectType == 4)
                priceTo = txtAlert.text;
            selectType = -1;
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selIndex = row;
 
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [dataList count];
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [dataList objectAtIndex:row];
}
- (IBAction)onDone:(id)sender {

    if (selIndex == -1)
        selIndex = 0;
    if (selIndex != -1)
    {
        if (selectType == 0){
            CompanyObject *obj = [[Setting sharedInstance].arrayCompany objectAtIndex:selIndex];
            supermarketID = obj.companyID;
            
        }
        else if (selectType == 1)
        {
            MainCategory *obj = [[Setting sharedInstance].MainCategories objectAtIndex:selIndex];
            mainCatID = obj.mainCatID;
        }
        else if (selectType == 2)
        {
            SubCategory *obj = [[Setting sharedInstance].SubCategories objectAtIndex:selIndex];
            subCatID = obj.subCatID;
        }
        else if (selectType == 5)
        {
            State *obj = [[Setting sharedInstance].Cities objectAtIndex:selIndex];
            cityID = obj.stateID;
        }
    }

    [UIView beginAnimations:@"AdResize" context:nil];
    [UIView setAnimationDuration:0.7];
    
    CGRect newFrame = CGRectMake(selectView.frame.origin.x, self.view.frame.size.height, selectView.frame.size.width, selectView.frame.size.height);
    
    selectView.frame = newFrame;
    [UIView commitAnimations];
        selectType = -1;
        selIndex = -1;
}

- (IBAction)onBtnSearch:(id)sender {
    searchText = searchBar.text;
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<SearchProducts xmlns=\"http://tempuri.org/\">\n"
                             "<CompanyID>%@</CompanyID>\n"
                             "<OfferID>%@</OfferID>\n"
                             "<MainCategorID>%@</MainCategorID>\n"
                             "<SubCategoryID>%@</SubCategoryID>\n"
                             "<SearchKeyword>%@</SearchKeyword>\n"
                             "<PriceFrom>%@</PriceFrom>\n"
                             "<PriceTo>%@</PriceTo>\n"
                             "<CityList>%@</CityList>\n"
                             "<CustomerID>%@</CustomerID>\n"
                             "<Language>%d</Language>\n"
                             "</SearchProducts>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", supermarketID, offerID, mainCatID, subCatID, searchText, priceFrom, priceTo, cityID, [Setting sharedInstance].customer.customerID, myLang];
	NSLog(@"soapMessage = %@\n", soapMessage);
    
	NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=SearchProducts"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://tempuri.org/SearchProducts" forHTTPHeaderField:@"SOAPAction"];
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


- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar{
    [searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar{
    searchText = searchBar.text;
    [searchBar resignFirstResponder];
}
-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"SearchItemCell"];
    if (cell == Nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchItemCell"];
    
    UILabel *lb_item = (UILabel*)[cell viewWithTag:101];
    NSString *strItem = [search_list objectAtIndex:indexPath.row];
    if (indexPath.row == 0){
        UIButton *btnArrow = (UIButton*)[cell viewWithTag:102];
        btnArrow.hidden = YES;
    }
    lb_item.text = strItem;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return search_list.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [searchBar resignFirstResponder];
    searchText = searchBar.text;
    selectView.hidden = NO;
    int index = -1;
    switch (indexPath.row) {
        case 0:
        {
            supermarketID = @"0";
            mainCatID = @"0";
            subCatID = @"0";
            cityID = @"";
            priceFrom = @"-1";
            priceTo = @"-1";
            offerID = @"0";
            customerID = @"0";
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                myLang = 1;
            else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
                myLang = 2;
            soapResults = Nil;
            recordResults = FALSE;
            selIndex = -1;

        }
            break;
        case 1:
        {
            selectType = 0;
            lb_pickerTitle.text = @"Select SuperMarket";
            [dataList removeAllObjects];

            for (int i = 0; i < [Setting sharedInstance].arrayCompany.count; i++) {
                CompanyObject *obj = [[Setting sharedInstance].arrayCompany objectAtIndex:i];
                if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                    [dataList addObject:obj.companyNameEn];
                else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
                    [dataList addObject:obj.companyNameAr];
                if ([obj.companyID isEqualToString:supermarketID] && ![supermarketID isEqualToString:@"0"])
                    index = i;
            }
            [selectPicker reloadAllComponents];
            
            if (index != -1) {
                [selectPicker selectRow:index inComponent:0 animated:YES];
                lb_pickerTitle.text = [dataList objectAtIndex:index];
            }
            else
            {
                [selectPicker selectRow:0 inComponent:0 animated:YES];
            }
            [UIView beginAnimations:@"AdResize" context:nil];
            [UIView setAnimationDuration:0.7];
            
            CGRect newFrame = CGRectMake(selectView.frame.origin.x, self.view.frame.size.height - selectView.frame.size.height, selectView.frame.size.width, selectView.frame.size.height);
            
            selectView.frame = newFrame;
            [UIView commitAnimations];
        }
            break;
        case 2:
        {
            selectType = 1;
            [dataList removeAllObjects];
            lb_pickerTitle.text = @"Select MainCategory";
            for (int i = 0; i < [Setting sharedInstance].MainCategories.count; i++) {
                MainCategory *obj = [[Setting sharedInstance].MainCategories objectAtIndex:i];
                if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                    [dataList addObject:obj.mainCatNameEn];
                else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
                    [dataList addObject:obj.mainCatNameAr];
                if ([obj.mainCatID isEqualToString:mainCatID] && ![mainCatID isEqualToString:@"0"])
                    index = i;
            }
            [selectPicker reloadAllComponents];
            
            if (index != -1) {
                [selectPicker selectRow:index inComponent:0 animated:YES];
                lb_pickerTitle.text = [dataList objectAtIndex:index];
            }
            else
            {
                [selectPicker selectRow:0 inComponent:0 animated:YES];
            }
            [UIView beginAnimations:@"AdResize" context:nil];
            [UIView setAnimationDuration:0.7];
            
            CGRect newFrame = CGRectMake(selectView.frame.origin.x, self.view.frame.size.height - selectView.frame.size.height, selectView.frame.size.width, selectView.frame.size.height);
            
            selectView.frame = newFrame;
            [UIView commitAnimations];
        }
            break;
        case 3:
        {
            selectType = 2;
            lb_pickerTitle.text = @"Select SubCategory";
            [dataList removeAllObjects];
            for (int i = 0; i < [Setting sharedInstance].SubCategories.count; i++) {
                SubCategory *obj = [[Setting sharedInstance].SubCategories objectAtIndex:i];
                if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                    [dataList addObject:obj.subCatEn];
                else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
                    [dataList addObject:obj.subCatAr];
                if ([obj.subCatID isEqualToString:subCatID] && ![subCatID isEqualToString:@"0"])
                    index = i;
            }
            [selectPicker reloadAllComponents];
            
            if (index != -1) {
                [selectPicker selectRow:index inComponent:0 animated:YES];
                lb_pickerTitle.text = [dataList objectAtIndex:index];
            }
            else
            {
                [selectPicker selectRow:0 inComponent:0 animated:YES];
            }
            [UIView beginAnimations:@"AdResize" context:nil];
            [UIView setAnimationDuration:0.7];
            
            CGRect newFrame = CGRectMake(selectView.frame.origin.x, self.view.frame.size.height - selectView.frame.size.height, selectView.frame.size.width, selectView.frame.size.height);
            
            selectView.frame = newFrame;
            [UIView commitAnimations];
        }
            break;
        case 4:
        {
            selectType = 3;
            UIAlertView *customAlertView = [[UIAlertView alloc]initWithTitle:@"Please enter price from:"
                                                                     message:@""
                                                                    delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:@"Cancel",nil];
            customAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            if (![priceFrom isEqualToString:@"-1"]){
                UITextField *txtField = [customAlertView textFieldAtIndex:0];
                txtField.text = priceFrom;
            }
            [customAlertView show];

        }
            break;
        case 5:
        {
            selectType = 4;
            UIAlertView *customAlertView = [[UIAlertView alloc]initWithTitle:@"Please enter price to:"
                                                                     message:@""
                                                                    delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:@"Cancel",nil];
            customAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            if (![priceTo isEqualToString:@"-1"]){
                UITextField *txtField = [customAlertView textFieldAtIndex:0];
                txtField.text = priceTo;
            }
            [customAlertView show];
        }
            break;
        case 6:
        {
            selectType = 5;
            lb_pickerTitle.text = @"Select City";
            [dataList removeAllObjects];
            for (int i = 0; i < [Setting sharedInstance].Cities.count; i++) {
                State *obj = [[Setting sharedInstance].Cities objectAtIndex:i];
                if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                    [dataList addObject:obj.stateNameEn];
                else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
                    [dataList addObject:obj.stateNameAr];
                if ([obj.stateID isEqualToString:cityID] && ![cityID isEqualToString:@"0"])
                    index = i;
            }
            [selectPicker reloadAllComponents];
            
            if (index != -1) {
                [selectPicker selectRow:index inComponent:0 animated:YES];
                lb_pickerTitle.text = [dataList objectAtIndex:index];
            }
            else
            {
                [selectPicker selectRow:0 inComponent:0 animated:YES];

            }
            [UIView beginAnimations:@"AdResize" context:nil];
            [UIView setAnimationDuration:0.7];
            
            CGRect newFrame = CGRectMake(selectView.frame.origin.x, self.view.frame.size.height - selectView.frame.size.height, selectView.frame.size.width, selectView.frame.size.height);
            
            selectView.frame = newFrame;
            [UIView commitAnimations];
        }
            break;
            
        default:
            break;
    }
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	if( [elementName isEqualToString:@"SearchResult"])
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
    
    if ([elementName isEqualToString:@"SearchProductsResult"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        searchResultArray = Nil;
        searchResultArray = [[NSMutableArray alloc]init];
        
    }
    
    if ([elementName isEqualToString:@"CategoryID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"CompanyID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"CategoryName"])
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
    if ([elementName isEqualToString:@"ProductID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"ProductPhoto"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"ProductTitle"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"ProductDescription"])
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
    if ([elementName isEqualToString:@"CurrentPrice"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"OldPrice"])
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
    if ([elementName isEqualToString:@"MeasureUnit"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"IsPurchsedByCustomer"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"IsAddedToFavorite"])
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
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"SearchProductsResponse"])
	{
		recordResults = FALSE;
        soapResults = nil;
        [self sortArrayProduct:searchResultArray];
        UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchResultViewController *vc = [mainstoryboard instantiateViewControllerWithIdentifier:@"SearchResultView"];
        vc.arrayProductsWithCategory = productArray;
        [self saveProductsInfo];
        [self.navigationController pushViewController:vc animated:YES];
	}
    if( [elementName isEqualToString:@"SearchResult"])
	{
		recordResults = FALSE;
        [searchResultArray addObject:productObj];
        soapResults = nil;
        productObj = nil;
	}
    
    if ([elementName isEqualToString:@"CategoryID"])
    {
        recordResults = FALSE;
        productObj.prodMainCatID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"CategoryName"])
    {
        recordResults = FALSE;
        soapResults = nil;
    }
    
    if ([elementName isEqualToString:@"CompanyID"])
    {
        recordResults = FALSE;
        productObj.prodCompanyID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"OfferID"])
    {
        recordResults = FALSE;
        productObj.OfferID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"ProductID"])
    {
        recordResults = FALSE;
        productObj.prodID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"ProductPhoto"])
    {
        recordResults = FALSE;
        productObj.prodPhotoURL = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"ProductTitle"])
    {
        recordResults = FALSE;
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
            productObj.prodTitleAr = soapResults;
        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            productObj.prodTitleEn = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"ProductDescription"])
    {
        recordResults = FALSE;
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
            productObj.prodDescAr = soapResults;
        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
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
    if ([elementName isEqualToString:@"CurrentPrice"])
    {
        recordResults = FALSE;
        productObj.prodCurPrice = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"OldPrice"])
    {
        recordResults = FALSE;
        productObj.prodOrgPrice = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Quantity"])
    {
        recordResults = FALSE;
        productObj.prodQuantity = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"MeasureUnit"])
    {
        recordResults = FALSE;
        productObj.prodMeasureID = [[Setting sharedInstance] getMeasureID:soapResults];
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"IsPurchsedByCustomer"])
    {
        recordResults = FALSE;
        if ([soapResults isEqualToString:@"true"])
            productObj.prodPurchasedProducts = soapResults;
        else
            productObj.prodPurchasedProducts = @"";
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"IsAddedToFavorite"])
    {
        recordResults = FALSE;
        if ([soapResults isEqualToString:@"true"])
            productObj.prodFavoriteProducts = soapResults;
        else
            productObj.prodFavoriteProducts = @"";
        soapResults = nil;
    }
}
-(void)saveProductsInfo{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Q8SuperMarketDB.db"]];

    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
    {
        for (int i = 0; i < searchResultArray.count; i++) {
            ProductObject *obj = [searchResultArray objectAtIndex:i];
            BOOL flag = TRUE;
            
            NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM Products WHERE ID = \"%@\"", obj.prodID];
            
            const char *query_stmt1 = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(projectDB, query_stmt1, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) != SQLITE_ROW)
                {
                    flag = FALSE;
                    
                }
                sqlite3_finalize(statement);
            }
            if (flag == FALSE) {
                querySQL = [NSString stringWithFormat: @"INSERT INTO Products (ID, OfferID, Quantity, MainCatID, MeasureID, SubCatID, OrgPrice, Price, Photo, DescAr, DescEn, StartDate, EndDate, BranchList, VisitsCount, TitleAr, TitleEn, IsActive, lastUpdateTime) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", obj.prodID, obj.OfferID, obj.prodQuantity, obj.prodMainCatID, obj.prodMeasureID, obj.prodSubCatID, obj.prodOrgPrice, obj.prodCurPrice, obj.prodPhotoURL, obj.prodDescAr, obj.prodDescEn, obj.prodStartDate, obj.prodEndDate, obj.prodBranchList, obj.prodVisitsCount, obj.prodTitleAr, obj.prodTitleEn, obj.prodIsActive, obj.prodlastUpdateTime];
            
                query_stmt1 = [querySQL UTF8String];
            
                if (sqlite3_prepare_v2(projectDB, query_stmt1, -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_DONE)
                    {
                        NSLog(@"Products success");
                    
                    }
                    sqlite3_finalize(statement);
                }
            }
            flag = TRUE;
        }
        sqlite3_close(projectDB);
    }
}
-(void)sortArrayProduct:(NSMutableArray*)_arrayProduct{
    if (searchResultArray.count > 1){
        for (int i = 0; i < searchResultArray.count - 1; i++){
            ProductObject *tmpObj = [searchResultArray objectAtIndex:i];
            ProductObject *firstObj = [searchResultArray objectAtIndex:i];
            int index = i;
            for (int j = i + 1; j < searchResultArray.count; j++){
                ProductObject *secondObj = [searchResultArray objectAtIndex:j];
                NSString *sortNum1 = [[Setting sharedInstance] getSortNum:tmpObj.prodMainCatID withType:@"main"];
                NSString *sortNum2 = [[Setting sharedInstance] getSortNum:secondObj.prodMainCatID withType:@"main"];
                if ([sortNum1 intValue] > [sortNum2 intValue]) {
                        tmpObj = secondObj;
                        index = j;

                }
            }
            
            [searchResultArray replaceObjectAtIndex:i withObject:tmpObj];
            [searchResultArray replaceObjectAtIndex:index withObject:firstObj];
            
        }
    }
    int mainCategory = -1;
    productArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < searchResultArray.count; i++){
        ProductObject *obj = [searchResultArray objectAtIndex:i];
        ProductsWithCategory *catObj = [[ProductsWithCategory alloc]init];
        if ([[Setting sharedInstance] isFavoriteExist:obj.prodID] == FALSE)
        {
            obj.prodFavoriteProducts = @"";
        }
        else{
            obj.prodFavoriteProducts = @"true";
        }
        if ([[Setting sharedInstance] isPurchaseExist:obj.prodID] == FALSE)
        {
            obj.prodPurchasedProducts = @"";
        }
        else{
            obj.prodPurchasedProducts = @"true";
        }
        
        if (mainCategory != [obj.prodMainCatID intValue])
        {
            catObj.isCategory = TRUE;
            catObj.obj = Nil;
            catObj.mainID = obj.prodMainCatID;
            catObj.subID = obj.prodSubCatID;
            [productArray addObject:catObj];
            ProductsWithCategory *conObj = [[ProductsWithCategory alloc]init];
            conObj.isCategory = FALSE;
            conObj.obj = obj;
            [productArray addObject:conObj];
        }
        else
        {
            catObj.isCategory = FALSE;
            catObj.obj = obj;
            [productArray addObject:catObj];
        }
        mainCategory = [obj.prodMainCatID intValue];
    }
 
}

@end
