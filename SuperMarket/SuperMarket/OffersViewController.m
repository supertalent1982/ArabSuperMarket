//
//  OffersViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/1/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "OffersViewController.h"
#import "Setting.h"
#import "CompanyViewController.h"
#import "CompanyObject.h"
#import "AsyncImageView.h"
@interface OffersViewController ()

@end

@implementation OffersViewController
@synthesize logoArray;
@synthesize scrollCompanies;
@synthesize xmlParser;
@synthesize webData;
@synthesize recordResults;
@synthesize soapResults;
@synthesize companyObj;
@synthesize errEncounter;
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
    errEncounter = FALSE;
	// Do any additional setup after loading the view.
    [Setting sharedInstance].arrayCompany = [[NSMutableArray alloc]init];
    logoArray = [[NSMutableArray alloc] init];
    /*
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
            
            NSString *querySQL;
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                querySQL= [NSString stringWithFormat: @"SELECT NameEn FROM Companies"];
            else
                querySQL= [NSString stringWithFormat: @"SELECT NameAr FROM Companies"];
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) != SQLITE_ROW) {
                    NSLog(@"not matched");
                    UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                                message:@"Please create new project." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    
                    [mes show];
                }
                else{
                    NSString *companyName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    
                    [[Setting sharedInstance].arrayCompany addObject:companyName];
                    
                    while (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        
                        NSString *companyName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                        
                        [[Setting sharedInstance].arrayCompany addObject:companyName];
                    }
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(projectDB);
        }

    }
    
    for (int i = 0; i< [Setting sharedInstance].arrayCompany.count; i++){
    UIView *companyLogoView = [[UIView alloc]initWithFrame:CGRectMake(23 + i * 277, 8, 262, 245)];
    UIImageView *imgLogo = [[UIImageView alloc]initWithFrame:CGRectMake(7, 0, 260, 245)];
        if (i == 0)
            imgLogo.image = [UIImage imageNamed:@"city_sample.png"];
        else
            imgLogo.image = [UIImage imageNamed:@"gulfmart_sample.png"];
        
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(select_offers:)];
    tapGesture.delegate = self;
    imgLogo.userInteractionEnabled = YES;
        imgLogo.tag = i + 1;
    [imgLogo addGestureRecognizer:tapGesture];
    [companyLogoView addSubview:imgLogo];
    [logoArray addObject:imgLogo];
    UIImageView *imgPin = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 121, 39)];
    imgPin.image = [UIImage imageNamed:@"company_pin.png"];
    [companyLogoView addSubview:imgPin];
    
    UILabel *lb_pin = [[UILabel alloc]initWithFrame:CGRectMake(17, 20, 91, 21)];
    lb_pin.text = [NSString stringWithFormat:@"%@ offers", [[Setting sharedInstance].arrayCompany objectAtIndex:i]];
    [lb_pin setFont:[UIFont fontWithName:@"Helvetica Neue" size:10.0]];
    [lb_pin setTextColor:[UIColor whiteColor]];
    [lb_pin setBackgroundColor:[UIColor clearColor]];
    [companyLogoView addSubview:lb_pin];
    
    NSString *bottomStr = [NSString stringWithFormat:@"Lastest Offers in %@", [[Setting sharedInstance].arrayCompany objectAtIndex:i]];
    UILabel *lb_bottom1 = [[UILabel alloc]initWithFrame:CGRectMake(31, 191, 211, 21)];
    lb_bottom1.text = bottomStr;
    [lb_bottom1 setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0]];
    [lb_bottom1 setTextColor:[UIColor whiteColor]];
    [lb_bottom1 setBackgroundColor:[UIColor clearColor]];
    [companyLogoView addSubview:lb_bottom1];
    
    
    UILabel *lb_bottom2 = [[UILabel alloc] initWithFrame:CGRectMake(31, 207, 211, 21)];
    lb_bottom2.text = @"Browse latest offers in supermarket";
    [lb_bottom2 setFont:[UIFont fontWithName:@"Helvetica Neue" size:10.0]];
    [lb_bottom2 setTextColor:[UIColor orangeColor]];
    [lb_bottom2 setBackgroundColor:[UIColor clearColor]];
    [companyLogoView addSubview:lb_bottom2];
    
    [scrollCompanies addSubview:companyLogoView];
    }
    [scrollCompanies setContentSize:CGSizeMake(320 + 276 * (logoArray.count - 1), 245)];
    scrollCompanies.delegate = self;
     */

    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<CompanyGetAll xmlns=\"http://tempuri.org/\" />\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n"
                             ];
	NSLog(@"soapMessage = %@\n", soapMessage);
    
	NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=CompanyGetAll"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://tempuri.org/CompanyGetAll" forHTTPHeaderField:@"SOAPAction"];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)select_offers:(id)sender {
    NSLog(@"offset = %f", scrollCompanies.contentOffset.x);
    CGFloat offsetScroll = scrollCompanies.contentOffset.x;

    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer*)sender;
    
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CompanyViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"CompanyView"];
    CompanyObject *comObj = [[Setting sharedInstance].arrayCompany objectAtIndex:tapGesture.view.tag - 1];
    VC.selCompany = comObj;
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)showCompanyLogo{
    for (int i = 0; i< [Setting sharedInstance].arrayCompany.count; i++){
        CGRect scrollFrame = scrollCompanies.frame;
        if (IS_IPHONE_5) {
            scrollFrame.origin.y = 190;
        }
        else if (IS_IPHONE_4)
        {
            scrollFrame.origin.y = 130;
        }
        [scrollCompanies setFrame:scrollFrame];
        
        UIView *companyLogoView = [[UIView alloc]initWithFrame:CGRectMake(10 + i * 300, 0, 300, 278)];
        AsyncImageView *imgBasicLogo = [[AsyncImageView alloc]initWithFrame:CGRectMake(12, 5, 285, 253)];
        CompanyObject *compObj = [[Setting sharedInstance].arrayCompany objectAtIndex:i];
        [imgBasicLogo setImageURL:[NSURL URLWithString:compObj.companyLogo]];
        [companyLogoView addSubview:imgBasicLogo];
        
        UIImageView *imgLogo = [[UIImageView alloc]initWithFrame:CGRectMake(7, 0, 295, 278)];
        imgLogo.image = [UIImage imageNamed:@"logoCase.png"];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(select_offers:)];
        tapGesture.delegate = self;
        imgLogo.userInteractionEnabled = YES;
        imgLogo.tag = i + 1;
        [imgLogo addGestureRecognizer:tapGesture];
        [companyLogoView addSubview:imgLogo];
        [logoArray addObject:imgLogo];
        UIImageView *imgPin = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 121, 39)];
        imgPin.image = [UIImage imageNamed:@"company_pin.png"];
        [companyLogoView addSubview:imgPin];
        
        UILabel *lb_pin = [[UILabel alloc]initWithFrame:CGRectMake(17, 22, 91, 21)];
        if([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            lb_pin.text = [NSString stringWithFormat:@"%@ offers", compObj.companyNameEn];
        if([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
            lb_pin.text = [NSString stringWithFormat:@"%@ offers", compObj.companyNameAr];
        [lb_pin setFont:[UIFont fontWithName:@"Helvetica Neue" size:10.0]];
        [lb_pin setTextColor:[UIColor whiteColor]];
        [lb_pin setBackgroundColor:[UIColor clearColor]];
        [companyLogoView addSubview:lb_pin];
        
        NSString *bottomStr;
        if([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            bottomStr = compObj.companySloganEn;
        if([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
            bottomStr = compObj.companySloganAr;
        
        UILabel *lb_bottom1 = [[UILabel alloc]initWithFrame:CGRectMake(21, 219, 260, 21)];
        lb_bottom1.text = bottomStr;
        [lb_bottom1 setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0]];
        [lb_bottom1 setTextColor:[UIColor whiteColor]];
        [lb_bottom1 setBackgroundColor:[UIColor clearColor]];
        [companyLogoView addSubview:lb_bottom1];
        
        
        UILabel *lb_bottom2 = [[UILabel alloc] initWithFrame:CGRectMake(21, 235, 260, 21)];
        lb_bottom2.text = @"Browse latest offers in supermarket";
        [lb_bottom2 setFont:[UIFont fontWithName:@"Helvetica Neue" size:10.0]];
        [lb_bottom2 setTextColor:[UIColor orangeColor]];
        [lb_bottom2 setBackgroundColor:[UIColor clearColor]];
        [companyLogoView addSubview:lb_bottom2];
        
        [scrollCompanies addSubview:companyLogoView];
    }
    [scrollCompanies setContentSize:CGSizeMake(320 + 300 * (logoArray.count - 1), 278)];
    scrollCompanies.delegate = self;
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
	if( [elementName isEqualToString:@"CompanyResult"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        if (!companyObj)
            companyObj = [[CompanyObject alloc]init];
        
    }
    if ([elementName isEqualToString:@"ID"])
    {
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"NameAr"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"NameEn"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Email"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;    }
    if ([elementName isEqualToString:@"Phone"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Fax"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"Logo"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"StateID"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"AreaID"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"AddressAr"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"AddressEn"]){
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
    if ([elementName isEqualToString:@"OverallSort"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"ProductSort"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"OrderSort"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"BigLogo"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"AboutUsLogo"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"SloganEn"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;    }
    if ([elementName isEqualToString:@"SloganAr"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"ErrMessage"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if ([elementName isEqualToString:@"CompanyGetAllResult"]){
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        [Setting sharedInstance].arrayCompany = Nil;
        [Setting sharedInstance].arrayCompany = [[NSMutableArray alloc]init];
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
    
    if( [elementName isEqualToString:@"CompanyGetAllResult"])
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
        [self showCompanyLogo];
	}
	if( [elementName isEqualToString:@"CompanyResult"])
	{
		recordResults = FALSE;
        [[Setting sharedInstance].arrayCompany addObject:companyObj];
        soapResults = nil;
        companyObj = nil;
	}
    if ([elementName isEqualToString:@"ID"]){
        recordResults = FALSE;
        companyObj.companyID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"NameAr"]){
        recordResults = FALSE;
        companyObj.companyNameAr = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"NameEn"]){
        recordResults = FALSE;
        companyObj.companyNameEn = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Email"]){
        recordResults = FALSE;
        companyObj.companyEmail = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Phone"]){
        recordResults = FALSE;
        companyObj.companyPhone = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Fax"]){
        recordResults = FALSE;
        companyObj.companyFax = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"Logo"]){
        recordResults = FALSE;
        companyObj.companyLogo = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"StateID"]){
        recordResults = FALSE;
        companyObj.companyStateID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"AreaID"]){
        recordResults = FALSE;
        companyObj.companyAreaID = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"AddressAr"]){
        recordResults = FALSE;
        companyObj.companyAddressAr = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"AddressEn"]){
        recordResults = FALSE;
        companyObj.companyAddressEn = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"DescAr"]){
        recordResults = FALSE;
        companyObj.companyDescAr = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"DescEn"]){
        recordResults = FALSE;
        companyObj.companyDescEn = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"OverallSort"]){
        recordResults = FALSE;
        companyObj.companyOverallSort = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"ProductSort"]){
        recordResults = FALSE;
        companyObj.companyProductSort = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"OrderSort"]){
        recordResults = FALSE;
        companyObj.companyOrderSort = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"BigLogo"]){
        recordResults = FALSE;
        companyObj.companyBigLogo = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"AboutUsLogo"]){
        recordResults = FALSE;
        companyObj.companyAboutUsLogo = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"SloganEn"]){
        recordResults = FALSE;
        companyObj.companySloganEn = soapResults;
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"SloganAr"]){
        recordResults = FALSE;
        companyObj.companySloganAr= soapResults;
        soapResults = nil;
    }
    
}
@end
