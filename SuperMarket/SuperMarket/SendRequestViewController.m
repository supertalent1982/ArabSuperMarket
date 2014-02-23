//
//  SendRequestViewController.m
//  SuperMarket
//
//  Created by phoenix on 1/22/14.
//  Copyright (c) 2014 phoenix. All rights reserved.
//

#import "SendRequestViewController.h"
#import "PPRevealSideViewController.h"
#import "FriendViewController.h"
#import "Setting.h"
#import "MBProgressHUD.h"
@interface SendRequestViewController ()

@end

@implementation SendRequestViewController
@synthesize xmlParser;
@synthesize webData;
@synthesize recordResults;
@synthesize soapResults;
@synthesize tEmail;
@synthesize tFriendName;
@synthesize tMobile;
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
    tEmail.text = @"";
    tMobile.text = @"";
    tFriendName.text = @"";
}
- (void)viewWillAppear:(BOOL)animated{
    self.errStatus = FALSE;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        [self.btnSendRequest setBackgroundImage:[UIImage imageNamed:@"btn_sendrequest.png"] forState:UIControlStateNormal];
        [self.btnSendRequest setBackgroundImage:[UIImage imageNamed:@"btn_sendrequest.png"] forState:UIControlStateHighlighted];
        [self.btnSendRequest setBackgroundImage:[UIImage imageNamed:@"btn_sendrequest.png"] forState:UIControlStateSelected];
        self.lb_title.text = @"Friend Request";
        tFriendName.placeholder = @"Friend Name";
        tEmail.placeholder = @"E-Mail";
        tMobile.placeholder = @"Mobile Number";
        self.lbOR.text = @"OR";
        self.lbOR1.text = @"OR";
    }
    else{
        [self.btnSendRequest setBackgroundImage:[UIImage imageNamed:@"arab_sendrequest.png"] forState:UIControlStateNormal];
        [self.btnSendRequest setBackgroundImage:[UIImage imageNamed:@"arab_sendrequest.png"] forState:UIControlStateHighlighted];
        [self.btnSendRequest setBackgroundImage:[UIImage imageNamed:@"arab_sendrequest.png"] forState:UIControlStateSelected];
        self.lb_title.text = @"طلب صديق";
        tFriendName.placeholder = @"اسم الصديق";
        tEmail.placeholder = @"البريد الالكتروني";
        tMobile.placeholder = @"النقال";
        self.lbOR.text = @"أو";
        self.lbOR1.text = @"أو";
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.tMobile)
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    return TRUE;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return TRUE;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSendRequest:(id)sender {
    if ([[Setting sharedInstance].customer.customerID isEqualToString:@"0"]){
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"You must login to add your friend." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        }else{
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                        message:@"يجب عليك تسجيل الدخول لإضافة صديقك" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
            
            [mes show];
        }
        return;
    }
    [self.tEmail resignFirstResponder];
    [self.tMobile resignFirstResponder];
    [self.tFriendName resignFirstResponder];
    NSLog(@"%@, %@, %@", tEmail.text, tMobile.text, tFriendName.text);
    NSString *myLang;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
    {
        myLang = @"1";
    }
    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
        myLang = @"2";
    }
    if (![tFriendName.text isEqualToString:@""]){
        NSString *soapMessage = [NSString stringWithFormat:
                                 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                 "<soap:Body>\n"
                                 "<FriendAddByUsername xmlns=\"http://tempuri.org/\">\n"
                                 "<CustomerID>%d</CustomerID>\n"
                                 "<Username>%@</Username>\n"
                                 "<Language>%@</Language>\n"
                                 "</FriendAddByUsername>\n"
                                 "</soap:Body>\n"
                                 "</soap:Envelope>\n", [[Setting sharedInstance].customer.customerID  intValue], self.tFriendName.text, myLang];
        NSLog(@"soapMessage = %@\n", soapMessage);
        
        NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=FriendAddByUsername"];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
        
        [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest addValue: @"http://tempuri.org/FriendAddByUsername" forHTTPHeaderField:@"SOAPAction"];
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
        return;
    }
    if (![tEmail.text isEqualToString:@""]){
        NSString *soapMessage = [NSString stringWithFormat:
                                 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                 "<soap:Body>\n"
                                 "<FriendAddByEmail xmlns=\"http://tempuri.org/\">\n"
                                 "<CustomerID>%d</CustomerID>\n"
                                 "<Email>%@</Email>\n"
                                 "<Language>%@</Language>\n"
                                 "</FriendAddByEmail>\n"
                                 "</soap:Body>\n"
                                 "</soap:Envelope>\n", [[Setting sharedInstance].customer.customerID  intValue], self.tEmail.text, myLang];
        NSLog(@"soapMessage = %@\n", soapMessage);
        
        NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=FriendAddByEmail"];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
        
        [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest addValue: @"http://tempuri.org/FriendAddByEmail" forHTTPHeaderField:@"SOAPAction"];
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
        return;
    }
    if (![tMobile.text isEqualToString:@""]){
        NSString *soapMessage = [NSString stringWithFormat:
                                 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                 "<soap:Body>\n"
                                 "<FriendAddByMobileNo xmlns=\"http://tempuri.org/\">\n"
                                 "<CustomerID>%d</CustomerID>\n"
                                 "<MobileNo>%@</MobileNo>\n"
                                 "<Language>%@</Language>\n"
                                 "</FriendAddByMobileNo>\n"
                                 "</soap:Body>\n"
                                 "</soap:Envelope>\n", [[Setting sharedInstance].customer.customerID  intValue], self.tMobile.text, myLang];
        NSLog(@"soapMessage = %@\n", soapMessage);
        
        NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=FriendAddByMobileNo"];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
        
        [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest addValue: @"http://tempuri.org/FriendAddByMobileNo" forHTTPHeaderField:@"SOAPAction"];
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
        return;
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
        self.errStatus = TRUE;
        if (![soapResults isEqualToString:@""]) {
            NSLog(@"error");
            [Setting sharedInstance].errString = soapResults;
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:[Setting sharedInstance].errString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [mes show];
        }
        
        soapResults = nil;
    }
    if ([elementName isEqualToString:@"FriendAddByUsernameResponse"]){
        if (self.errStatus == FALSE){
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Friend Request Sent Successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [mes show];
            }
            else{
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                            message:@"تم ارسال طلبك بنجاح" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
                [mes show];
            }
        }
        //[self.navigationController popViewControllerAnimated:YES];
    }
    if ([elementName isEqualToString:@"FriendAddByEmailResponse"]){
        if (self.errStatus == FALSE){
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"Friend Request Sent Successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [mes show];
            }
            else{
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                            message:@"تم ارسال طلبك بنجاح" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
                [mes show];
            }
        }

        //        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([elementName isEqualToString:@"FriendAddByMobileNoResponse"])
    {
        if (self.errStatus == FALSE){
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"Friend Request Sent Successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [mes show];
            }
            else{
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                            message:@"تم ارسال طلبك بنجاح" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
                [mes show];
            }
        }

        //      [self.navigationController popViewControllerAnimated:YES];
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
    c.viewName = @"sendrequest";
    [self.revealSideViewController pushViewController:n onDirection:PPRevealSideDirectionRight withOffset:158 animated:TRUE];
    PP_RELEASE(c);
    PP_RELEASE(n);
}
@end
