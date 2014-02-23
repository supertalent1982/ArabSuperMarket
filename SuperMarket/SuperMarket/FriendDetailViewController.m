//
//  FriendDetailViewController.m
//  SuperMarket
//
//  Created by phoenix on 1/22/14.
//  Copyright (c) 2014 phoenix. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "PPRevealSideViewController.h"
#import "FriendViewController.h"
#import "MBProgressHUD.h"
@interface FriendDetailViewController ()

@end

@implementation FriendDetailViewController
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
                                             selector:@selector(PopThisView)
                                                 name:@"PopThis"
                                               object:nil];
}
- (void)PopThisView{
    self.lb_Name.text = obj.friendName;
    self.lb_mobileno.text = obj.friendMobile;
    self.lb_city.text = obj.friendCity;
    self.lb_email.text = obj.friendEmail;
}
- (void)viewWillAppear:(BOOL)animated{
    self.lb_Name.text = obj.friendName;
    self.lb_mobileno.text = obj.friendMobile;
    self.lb_city.text = obj.friendCity;
    self.lb_email.text = obj.friendEmail;
    CGRect tmpRect;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        [self.btnRemove setBackgroundImage:[UIImage imageNamed:@"btn_removefriend.png"] forState:UIControlStateNormal];
        [self.btnRemove setBackgroundImage:[UIImage imageNamed:@"btn_removefriend.png"] forState:UIControlStateHighlighted];
        [self.btnRemove setBackgroundImage:[UIImage imageNamed:@"btn_removefriend.png"] forState:UIControlStateSelected];
        self.lbCity.text = @"Select City";
        self.lbemail.text = @"E-Mail";
        self.lbMobile.text = @"Mobile No.";
        self.lbName.text = @"Name";
        self.lbtitle.text = @"Friend Details";
        
        tmpRect = self.lb_Name.frame;
        tmpRect.origin.x = 147;
        self.lb_Name.frame = tmpRect;
        self.lbName.textAlignment = NSTextAlignmentLeft;

        tmpRect = self.lb_mobileno.frame;
        tmpRect.origin.x = 147;
        self.lb_mobileno.frame = tmpRect;
        self.lbMobile.textAlignment = NSTextAlignmentLeft;
        
        tmpRect = self.lb_email.frame;
        tmpRect.origin.x = 147;
        self.lb_email.frame = tmpRect;
        self.lbCity.textAlignment = NSTextAlignmentLeft;
        
        tmpRect = self.lb_city.frame;
        tmpRect.origin.x = 147;
        self.lb_city.frame = tmpRect;
        self.lbemail.textAlignment = NSTextAlignmentLeft;
        
        self.lb_Name.textAlignment = NSTextAlignmentLeft;
        self.lb_mobileno.textAlignment = NSTextAlignmentLeft;
        self.lb_email.textAlignment = NSTextAlignmentLeft;
        self.lb_city.textAlignment = NSTextAlignmentLeft;
        
        NSLog(@"%f, %f", self.lbName.frame.origin.x, self.lb_Name.frame.origin.x);
    }
    else{
        [self.btnRemove setBackgroundImage:[UIImage imageNamed:@"arab_removefriend.png"] forState:UIControlStateNormal];
        [self.btnRemove setBackgroundImage:[UIImage imageNamed:@"arab_removefriend.png"] forState:UIControlStateHighlighted];
        [self.btnRemove setBackgroundImage:[UIImage imageNamed:@"arab_removefriend.png"] forState:UIControlStateSelected];
        self.lbCity.text = @"اختر المدينة";
        self.lbemail.text = @"البريد الالكتروني";
        self.lbMobile.text = @"النقال";
        self.lbName.text = @"الاسم";
        self.lbtitle.text = @"بيانات الصديق";
        
        tmpRect = self.lb_Name.frame;
        tmpRect.origin.x = 31;
        self.lb_Name.frame = tmpRect;
        self.lbName.textAlignment = NSTextAlignmentRight;
        
        tmpRect = self.lb_mobileno.frame;
        tmpRect.origin.x = 31;
        self.lb_mobileno.frame = tmpRect;
        self.lbMobile.textAlignment = NSTextAlignmentRight;
        
        tmpRect = self.lb_email.frame;
        tmpRect.origin.x = 31;
        self.lb_email.frame = tmpRect;
        self.lbCity.textAlignment = NSTextAlignmentRight;
        
        tmpRect = self.lb_city.frame;
        tmpRect.origin.x = 31;
        self.lb_city.frame = tmpRect;
        self.lbemail.textAlignment = NSTextAlignmentRight;
        
        self.lb_Name.textAlignment = NSTextAlignmentRight;
        self.lb_mobileno.textAlignment = NSTextAlignmentRight;
        self.lb_email.textAlignment = NSTextAlignmentRight;
        self.lb_city.textAlignment = NSTextAlignmentRight;
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRemove:(id)sender {
    NSString *myLang;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
    {
        myLang = @"1";
    }
    else {
        myLang = @"2";
    }
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<FriendDelete xmlns=\"http://tempuri.org/\">\n"
                             "<CustomerID>%d</CustomerID>\n"
                             "<FriendID>%d</FriendID>\n"
                             "<Language>%d</Language>\n"
                             "</FriendDelete>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", [[Setting sharedInstance].customer.customerID  intValue], [obj.friendID intValue], [myLang intValue]];
    NSLog(@"soapMessage = %@\n", soapMessage);
    
    NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=FriendDelete"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/FriendDelete" forHTTPHeaderField:@"SOAPAction"];
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
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Delete Friend is failure." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [mes show];
            }
            else{
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                            message:@"فشل في حذف الصديق" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
                
                [mes show];
            }
        }
        
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"FriendDeleteResponse"]){
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
    c.viewName = @"detail";
    [self.revealSideViewController pushViewController:n onDirection:PPRevealSideDirectionRight withOffset:158 animated:TRUE];
    PP_RELEASE(c);
    PP_RELEASE(n);
}
@end
