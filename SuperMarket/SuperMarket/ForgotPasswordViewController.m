//
//  ForgotPasswordViewController.m
//  SuperMarket
//
//  Created by phoenix on 1/21/14.
//  Copyright (c) 2014 phoenix. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "FriendViewController.h"
#import "PPRevealSideViewController.h"
#import "Setting.h"
#import "MBProgressHUD.h"
@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController
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
}
- (void)viewWillAppear:(BOOL)animated{
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
    {
        [self.btnSend setBackgroundImage:[UIImage imageNamed:@"btnSendForgot.png"] forState:UIControlStateNormal];
        [self.btnSend setBackgroundImage:[UIImage imageNamed:@"btnSendForgot.png"] forState:UIControlStateHighlighted];
        [self.btnSend setBackgroundImage:[UIImage imageNamed:@"btnSendForgot.png"] forState:UIControlStateSelected];
        self.lb_title.text = @"Forgot Password";
        self.tEmail.placeholder = @"Your E-Mail";
    }else{
        [self.btnSend setBackgroundImage:[UIImage imageNamed:@"arabSendForgot.png"] forState:UIControlStateNormal];
        [self.btnSend setBackgroundImage:[UIImage imageNamed:@"arabSendForgot.png"] forState:UIControlStateHighlighted];
        [self.btnSend setBackgroundImage:[UIImage imageNamed:@"arabSendForgot.png"] forState:UIControlStateSelected];
        self.lb_title.text = @"نسيت كلمة المرور";
        self.tEmail.placeholder = @"البريد الالكتروني";
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)onSend:(id)sender {
    [self.tEmail resignFirstResponder];
    int myLang = 0;
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
    {
        myLang = 1;
    }
    else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
        myLang = 2;
    }
        
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<CustomerGetPassword xmlns=\"http://tempuri.org/\">\n"
                             "<Email>%@</Email>\n"
                             "<Language>%d</Language>\n"
                             "</CustomerGetPassword>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", self.tEmail.text, myLang];
    NSLog(@"soapMessage = %@\n", soapMessage);
    
    NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=CustomerGetPassword"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/CustomerGetPassword" forHTTPHeaderField:@"SOAPAction"];
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
                                                            message:soapResults delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                
                [mes show];
                }
                else{
                    UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                                message:soapResults delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
                    
                    [mes show];
                }
            }
            else{
                int myLang = 0;
                if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                {
                    myLang = 1;
                }
                else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
                    myLang = 2;
                }
                
                if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
                    UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                                message:@"The user profile information is sent via email successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    
                    [mes show];
                }
                else{
                    UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                                message:@"تم ارسال معلومات ملف المستخدم من خلال الايميل بنجاح" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
                    
                    [mes show];
                }

//                [self.navigationController popViewControllerAnimated:YES];
            }
            soapResults = nil;
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
    c.viewName = @"none";
    [self.revealSideViewController pushViewController:n onDirection:PPRevealSideDirectionRight withOffset:158 animated:TRUE];
    PP_RELEASE(c);
    PP_RELEASE(n);
}
@end
