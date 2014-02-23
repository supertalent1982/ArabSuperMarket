//
//  AcceptRequestViewController.m
//  SuperMarket
//
//  Created by phoenix on 1/22/14.
//  Copyright (c) 2014 phoenix. All rights reserved.
//

#import "AcceptRequestViewController.h"

#import "PPRevealSideViewController.h"
#import "FriendViewController.h"
#import "MBProgressHUD.h"
@interface AcceptRequestViewController ()

@end

@implementation AcceptRequestViewController
@synthesize xmlParser;
@synthesize webData;
@synthesize recordResults;
@synthesize soapResults;
@synthesize errEncounter;
@synthesize obj;
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(PopThatView)
                                                 name:@"PopThat"
                                               object:nil];
}
- (void)PopThatView{
    self.lb_name.text = obj.friendName;
    self.lb_mobile.text = obj.friendMobile;
    self.lb_city.text = obj.friendCity;
    self.lb_email.text = obj.friendEmail;

}
- (void)viewWillAppear:(BOOL)animated{
    self.lb_name.text = obj.friendName;
    self.lb_mobile.text = obj.friendMobile;
    self.lb_city.text = obj.friendCity;
    self.lb_email.text = obj.friendEmail;
    CGRect tmpRect;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        [self.btnRefuse setBackgroundImage:[UIImage imageNamed:@"btn_refusefriend.png"] forState:UIControlStateNormal];
        [self.btnRefuse setBackgroundImage:[UIImage imageNamed:@"btn_refusefriend.png"] forState:UIControlStateHighlighted];
        [self.btnRefuse setBackgroundImage:[UIImage imageNamed:@"btn_refusefriend.png"] forState:UIControlStateSelected];
        
        [self.btnAccept setBackgroundImage:[UIImage imageNamed:@"btn_acceptfriend.png"] forState:UIControlStateNormal];
        [self.btnAccept setBackgroundImage:[UIImage imageNamed:@"btn_acceptfriend.png"] forState:UIControlStateHighlighted];
        [self.btnAccept setBackgroundImage:[UIImage imageNamed:@"btn_acceptfriend.png"] forState:UIControlStateSelected];
        self.lbCity.text = @"Select City";
        self.lbEmail.text = @"E-Mail";
        self.lbMobile.text = @"Mobile No.";
        self.lbName.text = @"Name";
        self.lb_title = @"Friend Request";
        
        tmpRect = self.lb_name.frame;
        tmpRect.origin.x = 147;
        self.lb_name.frame = tmpRect;
        self.lbName.textAlignment = NSTextAlignmentLeft;
        
        tmpRect = self.lb_mobile.frame;
        tmpRect.origin.x = 147;
        self.lb_mobile.frame = tmpRect;
        self.lbMobile.textAlignment = NSTextAlignmentLeft;
        
        tmpRect = self.lb_email.frame;
        tmpRect.origin.x = 147;
        self.lb_email.frame = tmpRect;
        self.lbCity.textAlignment = NSTextAlignmentLeft;
        
        tmpRect = self.lb_city.frame;
        tmpRect.origin.x = 147;
        self.lb_city.frame = tmpRect;
        self.lbEmail.textAlignment = NSTextAlignmentLeft;
        
        self.lb_name.textAlignment = NSTextAlignmentLeft;
        self.lb_mobile.textAlignment = NSTextAlignmentLeft;
        self.lb_email.textAlignment = NSTextAlignmentLeft;
        self.lb_city.textAlignment = NSTextAlignmentLeft;
    }
    else{
        [self.btnRefuse setBackgroundImage:[UIImage imageNamed:@"arab_refusefriend.png"] forState:UIControlStateNormal];
        [self.btnRefuse setBackgroundImage:[UIImage imageNamed:@"arab_refusefriend.png"] forState:UIControlStateHighlighted];
        [self.btnRefuse setBackgroundImage:[UIImage imageNamed:@"arab_refusefriend.png"] forState:UIControlStateSelected];
        
        [self.btnAccept setBackgroundImage:[UIImage imageNamed:@"arab_acceptfriend.png"] forState:UIControlStateNormal];
        [self.btnAccept setBackgroundImage:[UIImage imageNamed:@"arab_acceptfriend.png"] forState:UIControlStateHighlighted];
        [self.btnAccept setBackgroundImage:[UIImage imageNamed:@"arab_acceptfriend.png"] forState:UIControlStateSelected];
        
        self.lbCity.text = @"اختر المدينة";
        self.lbEmail.text = @"البريد الالكتروني";
        self.lbMobile.text = @"النقال";
        self.lbName.text = @"الاسم";

        self.lb_title.text = @"طلب صديق";
        tmpRect = self.lb_name.frame;
        tmpRect.origin.x = 31;
        self.lb_name.frame = tmpRect;
        self.lbName.textAlignment = NSTextAlignmentRight;
        
        tmpRect = self.lb_mobile.frame;
        tmpRect.origin.x = 31;
        self.lb_mobile.frame = tmpRect;
        self.lbMobile.textAlignment = NSTextAlignmentRight;
        
        tmpRect = self.lb_email.frame;
        tmpRect.origin.x = 31;
        self.lb_email.frame = tmpRect;
        self.lbCity.textAlignment = NSTextAlignmentRight;
        
        tmpRect = self.lb_city.frame;
        tmpRect.origin.x = 31;
        self.lb_city.frame = tmpRect;
        self.lbEmail.textAlignment = NSTextAlignmentRight;
        
        self.lb_name.textAlignment = NSTextAlignmentRight;
        self.lb_mobile.textAlignment = NSTextAlignmentRight;
        self.lb_email.textAlignment = NSTextAlignmentRight;
        self.lb_city.textAlignment = NSTextAlignmentRight;

    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRefuse:(id)sender {
    NSString *myLang;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
    {
        myLang = @"1";
    }
    else {
        myLang = @"2";
    }
    BOOL isAccepted = FALSE;
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<FriendReplyRequest xmlns=\"http://tempuri.org/\">\n"
                             "<CustomerID>%d</CustomerID>\n"
                             "<FriendID>%d</FriendID>\n"
                             "<IsRequestAccepted>%d</IsRequestAccepted>\n"
                             "<Language>%d</Language>\n"
                             "</FriendReplyRequest>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", [[Setting sharedInstance].customer.customerID  intValue], [obj.friendID intValue], isAccepted, [myLang intValue]];
    NSLog(@"soapMessage = %@\n", soapMessage);
    
    NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=FriendReplyRequest"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/FriendReplyRequest" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"Waiting..."];
    else
        [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"الرجاي الانتظار..."];
    
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

- (IBAction)onAccept:(id)sender {
    NSString *myLang;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
    {
        myLang = @"1";
    }
    else {
        myLang = @"2";
    }
    BOOL isAccepted = TRUE;
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<FriendReplyRequest xmlns=\"http://tempuri.org/\">\n"
                             "<CustomerID>%d</CustomerID>\n"
                             "<FriendID>%d</FriendID>\n"
                             "<IsRequestAccepted>%d</IsRequestAccepted>\n"
                             "<Language>%d</Language>\n"
                             "</FriendReplyRequest>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", [[Setting sharedInstance].customer.customerID  intValue], [obj.friendID intValue], isAccepted, [myLang intValue]];
    NSLog(@"soapMessage = %@\n", soapMessage);
    
    NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=FriendReplyRequest"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/FriendReplyRequest" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"Waiting..."];
    else
        [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"الرجاي الانتظار..."];
    
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
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
	[MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
    
    if ([elementName isEqualToString:@"ErrMessage"]){
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
        if (![soapResults isEqualToString:@""]) {
            NSLog(@"error");
            [Setting sharedInstance].errString = soapResults;
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:[Setting sharedInstance].errString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [mes show];
        }
        
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"FriendReplyRequestResponse"]){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnList:(id)sender {
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // Session is open
    FriendViewController *c = [mainstoryboard instantiateViewControllerWithIdentifier:@"FriendManageView"];
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:c];
    c.navigationController.navigationBarHidden = YES;
    c.prevView = self;
    c.viewName = @"acceptrequest";
    [self.revealSideViewController pushViewController:n onDirection:PPRevealSideDirectionRight withOffset:158 animated:TRUE];
    PP_RELEASE(c);
    PP_RELEASE(n);
}
@end
