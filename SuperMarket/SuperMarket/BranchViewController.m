//
//  BranchViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/23/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "BranchViewController.h"
#import "Annotation.h"
#import "Setting.h"
@interface BranchViewController ()

@end

@implementation BranchViewController
@synthesize branchObj;
@synthesize mapView;
@synthesize lb_title;
@synthesize selCompany;
@synthesize xmlParser;
@synthesize webData;
@synthesize recordResults;
@synthesize soapResults;
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
    int myLang = -1;
    if([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
    {
        lb_title.text = selCompany.companyNameEn;
        myLang = 1;
    }
    if([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
    {
        lb_title.text = selCompany.companyNameAr;
        myLang = 2;
    }
//    mapView.hidden = YES;
    branchObj = [[BranchObject alloc] init];
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<CompanyGetRow xmlns=\"http://tempuri.org/\">\n"
                             "<ID>%@</ID>\n"
                             "<Language>%d</Language>\n"
                             "</CompanyGetRow>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n"
                             , selCompany.companyID, myLang
                             ];
	NSLog(@"soapMessage = %@\n", soapMessage);
 

	NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=CompanyGetRow"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://tempuri.org/CompanyGetRow" forHTTPHeaderField:@"SOAPAction"];
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

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    /*
	if( [elementName isEqualToString:@"CompanyResult"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        if (!branchObj)
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
    */
    
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
  /*  if ([elementName isEqualToString:@"ErrMessage"]){
        recordResults = FALSE;
        if (![soapResults isEqualToString:@""])
        {
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"The company data can't be fetched from server." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [mes show];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        soapResults = nil;
    }
    
    if( [elementName isEqualToString:@"CompanyGetAllResult"])
	{
		recordResults = FALSE;
        soapResults = nil;
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
    }*/
}
@end
