//
//  CompanyViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/1/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "CompanyViewController.h"
#import "AboutViewController.h"
#import "PPRevealSideViewController.h"
#import "FriendViewController.h"
#import "Setting.h"
@interface CompanyViewController ()

@end

@implementation CompanyViewController
@synthesize selCompany;
@synthesize BigLogo;
@synthesize xmlParser;
@synthesize webData;
@synthesize recordResults;
@synthesize soapResults;
@synthesize errEncounter;
@synthesize currentofferArray;
@synthesize expiredofferArray;
@synthesize offerObj;
@synthesize currentTable;
@synthesize expireTable;
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
    errEncounter  = FALSE;
	// Do any additional setup after loading the view.
    self.btnCancel.hidden = YES;
    self.searchBar.hidden = YES;
    self.searchBar.placeholder=@"search in offers";
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
    currentofferArray = [[NSMutableArray alloc]init];
    expiredofferArray = [[NSMutableArray alloc]init];

    currentTable.backgroundColor = [UIColor clearColor];
    currentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    expireTable.backgroundColor = [UIColor clearColor];
    expireTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        self.lb_title.text = selCompany.companyNameEn;
    if([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        self.lb_title.text = selCompany.companyNameAr;
    if (selCompany.companyBigLogo){
        NSRange pngRange = [selCompany.companyBigLogo rangeOfString:@".png"];
        NSRange jpgRange = [selCompany.companyBigLogo rangeOfString:@".jpg"];
        NSRange jpegRange = [selCompany.companyBigLogo rangeOfString:@".jpeg"];
        if (pngRange.location != NSNotFound || jpegRange.location
            != NSNotFound || jpgRange.location != NSNotFound){
            [BigLogo setImageURL:[NSURL URLWithString:selCompany.companyBigLogo]];
        }
    }
    NSDate *date = [[NSDate alloc]init];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
  /*  NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [df setLocale:locale];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [df setTimeZone:timeZone];*/
    NSString *dateStr = [df stringFromDate:date];
    NSLog(@"date = %@", dateStr);
    [df setDateFormat:@"hh:mm:ss"];
    NSString *timeStr = [df stringFromDate:date];
    NSString *reqUpdateTimeStr = [NSString stringWithFormat:@"%@T%@", dateStr, timeStr];
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<GetCompanyOffers xmlns=\"http://tempuri.org/\">\n"
                             "<CompanyID>%@</CompanyID>\n"
                             "<LastUpdateTime>%@</LastUpdateTime>\n"
                             "<CustomerID>0</CustomerID>\n"
                             "</GetCompanyOffers>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", selCompany.companyID, @"2013-07-15T00:00:00"];
	NSLog(@"soapMessage = %@\n", soapMessage);
    
	NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=GetCompanyOffers"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://tempuri.org/GetCompanyOffers" forHTTPHeaderField:@"SOAPAction"];
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
-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    if (_tableView == currentTable) {
        cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"CurrentCell"];
        if (cell == Nil)
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CurrentCell"];
        
        UILabel *lb_title = (UILabel*)[cell viewWithTag:101];
        OfferObject *obj = [currentofferArray objectAtIndex:indexPath.row];
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            lb_title.text = obj.offerTitleEn;
        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
            lb_title.text = obj.offerTitleAr;
        
        UILabel *lb_products = (UILabel*)[cell viewWithTag:102];
        if ([obj.offerProducts isEqualToString:@""])
            lb_products.text = @"0";
        else
            lb_products.text = obj.offerProducts;
        
    }
    else if (_tableView == expireTable){
        cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"ExpireCell"];
        if (cell == Nil)
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExpireCell"];
        
        UILabel *lb_title = (UILabel*)[cell viewWithTag:103];
        OfferObject *obj = [expiredofferArray objectAtIndex:indexPath.row];
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            lb_title.text = obj.offerTitleEn;
        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
            lb_title.text = obj.offerTitleAr;
        
        UILabel *lb_products = (UILabel*)[cell viewWithTag:104];
        if ([obj.offerProducts isEqualToString:@""])
            lb_products.text = @"0";
        else
            lb_products.text = obj.offerProducts;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"cell-big-bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 1001){
        NSLog(@"-------------%d", currentofferArray.count);
        return currentofferArray.count;
    }
    else if (tableView.tag == 1002)
        return expiredofferArray.count;
    return 0;
    
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

- (IBAction)onBtnAbout:(id)sender {
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AboutViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"AboutView"];
    VC.selCompany = selCompany;
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)onBtnCancel:(id)sender {
    self.btnCancel.hidden = YES;
    [self.searchBar resignFirstResponder];
    self.searchBar.hidden = YES;
    self.btnback.hidden = NO;
    self.btnShare.hidden = NO;
    self.btnSearch.hidden = NO;
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
	if( [elementName isEqualToString:@"OfferResult"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        if (!offerObj)
            offerObj = [[OfferObject alloc]init];
        
    }
    if ([elementName isEqualToString:@"ErrMessage"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    
    if ([elementName isEqualToString:@"GetCompanyOffersResult"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        currentofferArray = Nil;
        expiredofferArray = Nil;
        currentofferArray = [[NSMutableArray alloc]init];
        expiredofferArray = [[NSMutableArray alloc]init];
    }
    
    if ([elementName isEqualToString:@"ID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"CompanyID"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"TitleAr"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"TitleEn"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"DescAr"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"DescEn"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Photo"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"StartDate"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"EndDate"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"IsActive"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"BranchList"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"lastUpdateTime"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Products"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"AnalyticDatas"]){
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
bool errEncounter = FALSE;
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"ErrMessage"]){
        recordResults = FALSE;
        if (![soapResults isEqualToString:@""])
            errEncounter = TRUE;
        soapResults = nil;
    }
    if( [elementName isEqualToString:@"GetCompanyOffersResult"])
	{
		recordResults = FALSE;
        soapResults = nil;
        if (errEncounter == TRUE)
        {
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"The company data can't be fetched from server." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [mes show];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        [currentTable reloadData];
        [expireTable reloadData];
      //  [self showCompanyLogo];
	}
    if( [elementName isEqualToString:@"OfferResult"])
	{
		recordResults = FALSE;
        if ([offerObj.offerIsActive isEqualToString:@"true"])
            [currentofferArray addObject:offerObj];
        else
            [expiredofferArray addObject:offerObj];
        soapResults = nil;
        offerObj = nil;
	}
    if ([elementName isEqualToString:@"ID"]){
        recordResults = FALSE;
        offerObj.offerID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"CompanyID"]){
        recordResults = FALSE;
        offerObj.offerCompanyID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"TitleAr"]){
        recordResults = FALSE;
        offerObj.offerTitleAr = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"TitleEn"]){
        recordResults = FALSE;
        offerObj.offerTitleEn = soapResults;
        soapResults = nil;
   }
    if ([elementName isEqualToString:@"DescAr"]){
        recordResults = FALSE;
        offerObj.offerDescAr = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"DescEn"]){
        recordResults = FALSE;
        offerObj.offerDescEn = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Photo"]){
        recordResults = FALSE;
        offerObj.offerPhotoURL = soapResults;
        soapResults = nil;
   }
    if ([elementName isEqualToString:@"StartDate"]){
        recordResults = FALSE;
        offerObj.offerStartDate = soapResults;
        soapResults = nil;
   }
    if ([elementName isEqualToString:@"EndDate"]){
        recordResults = FALSE;
        offerObj.offerEndDate = soapResults;
        soapResults = nil;
   }
    if ([elementName isEqualToString:@"IsActive"]){
        recordResults = FALSE;
        offerObj.offerIsActive = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"BranchList"]){
        recordResults = FALSE;
        offerObj.offerBranchList = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"lastUpdateTime"]){
        recordResults = FALSE;
        offerObj.offerlastUpdateTime = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Products"]){
        recordResults = FALSE;
        offerObj.offerProducts = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"AnalyticDatas"]){
        recordResults = FALSE;
        offerObj.offerAnalyticDatas = soapResults;
        soapResults = nil;
   }
}
@end
