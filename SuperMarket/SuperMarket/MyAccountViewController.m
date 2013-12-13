//
//  MyAccountViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/4/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "MyAccountViewController.h"
#import "PPRevealSideViewController.h"
#import "FriendViewController.h"
#import "Setting.h"
@interface MyAccountViewController ()

@end

@implementation MyAccountViewController
@synthesize txtPassword;
@synthesize txtUserName;
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
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Q8SuperMarketDB.db"]];
    
}
- (void)viewWillAppear:(BOOL)animated{
    txtUserName.text = @"";
    txtPassword.text = @"";
    soapResults = Nil;
    recordResults = FALSE;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtnList:(id)sender {
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // Session is open
    FriendViewController *c = [mainstoryboard instantiateViewControllerWithIdentifier:@"FriendManageView"];
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:c];
    c.navigationController.navigationBarHidden = YES;
    [self.revealSideViewController pushViewController:n onDirection:PPRevealSideDirectionRight withOffset:158 animated:TRUE];
    PP_RELEASE(c);
    PP_RELEASE(n);
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)onForgot:(id)sender {
}

- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onBtnGmail:(id)sender {
}

- (IBAction)onBtnFacebook:(id)sender {
}

- (IBAction)onBtnTwitter:(id)sender {
}

- (IBAction)onBtnRegister:(id)sender {
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyAccountViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"RegisterView"];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)onBtnLogin:(id)sender {
    if ([txtUserName.text isEqualToString:@""])
    {
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Please enter your username." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        return;
    }
    else if ([txtPassword.text isEqualToString:@""]){
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Please enter your password." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        return;
    }
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
                             "<CustomerLogin xmlns=\"http://tempuri.org/\">\n"
                             "<Username>%@</Username>\n"
                             "<Password>%@</Password>\n"
                             "<Language>%d</Language>\n"
                             "</CustomerLogin>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n", txtUserName.text, txtPassword.text, myLang];
	NSLog(@"soapMessage = %@\n", soapMessage);
    
	NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=CustomerLogin"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://tempuri.org/CustomerLogin" forHTTPHeaderField:@"SOAPAction"];
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
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	if( [elementName isEqualToString:@"CustomerID"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if( [elementName isEqualToString:@"Name"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if( [elementName isEqualToString:@"Email"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if( [elementName isEqualToString:@"MobileNumber"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if( [elementName isEqualToString:@"MobileID"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if( [elementName isEqualToString:@"CityID"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if( [elementName isEqualToString:@"AreaID"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if( [elementName isEqualToString:@"Address"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if( [elementName isEqualToString:@"Username"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if( [elementName isEqualToString:@"Password"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if( [elementName isEqualToString:@"MobileType"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if( [elementName isEqualToString:@"UserType"])
	{
        if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
        recordResults = TRUE;
    }
    if( [elementName isEqualToString:@"AccessToken"])
	{
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
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Login failure." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [mes show];
        }
        soapResults = nil;
    }
    
    if( [elementName isEqualToString:@"CustomerID"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            [Setting sharedInstance].customer.customerID = soapResults;
        }
        soapResults = nil;
        
	}
    if( [elementName isEqualToString:@"Name"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            [Setting sharedInstance].customer.fullName = soapResults;
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"CustomerLoginResult"])
	{
		recordResults = FALSE;
        if (![[Setting sharedInstance].customer.customerID isEqualToString:@"0"]) {
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
                                     "<CustomerGetProfile xmlns=\"http://tempuri.org/\">\n"
                                     "<CustomerID>%@</CustomerID>\n"
                                     "<Language>%d</Language>\n"
                                     "</CustomerGetProfile>\n"
                                     "</soap:Body>\n"
                                     "</soap:Envelope>\n", [Setting sharedInstance].customer.customerID, myLang];
            NSLog(@"soapMessage = %@\n", soapMessage);
            
            NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=CustomerGetProfile"];
            NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
            NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
            
            [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            [theRequest addValue: @"http://tempuri.org/CustomerGetProfile" forHTTPHeaderField:@"SOAPAction"];
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

            //[self.navigationController popViewControllerAnimated:YES];
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"Email"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            [Setting sharedInstance].customer.Email = soapResults;
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"MobileNumber"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            [Setting sharedInstance].customer.Mobile = soapResults;
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"MobileID"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            [Setting sharedInstance].customer.MobileID = soapResults;
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"CityID"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            [Setting sharedInstance].customer.StateID = soapResults;
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"AreaID"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            [Setting sharedInstance].customer.AreaID = soapResults;
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"Address"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            [Setting sharedInstance].customer.Address = soapResults;
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"Username"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            [Setting sharedInstance].customer.Username = soapResults;
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"Password"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            [Setting sharedInstance].customer.Password = soapResults;
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"MobileType"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            [Setting sharedInstance].customer.MobileType = soapResults;
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"UserType"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            [Setting sharedInstance].customer.UserType = soapResults;
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"AccessToken"])
	{
		recordResults = FALSE;
        if (![soapResults isEqualToString:@""]) {
            [Setting sharedInstance].customer.AccessToken = soapResults;
        }
        soapResults = nil;
	}
    if( [elementName isEqualToString:@"CustomerGetProfileResult"])
	{
		recordResults = FALSE;
        soapResults = nil;
        [self.navigationController popViewControllerAnimated:YES];
	}

}

@end
