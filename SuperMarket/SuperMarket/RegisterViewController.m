//
//  RegisterViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/4/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "RegisterViewController.h"
#import "PPRevealSideViewController.h"
#import "FriendViewController.h"
#import "Setting.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize tConfirm;
@synthesize tEmail;
@synthesize tMobileNo;
@synthesize tName;
@synthesize tPassword;
@synthesize tSelectCity;
@synthesize cityArray;
@synthesize tUsername;
@synthesize selIndex;
@synthesize dataPicker;
@synthesize taccessToken;
@synthesize taddress;
@synthesize tareaID;
@synthesize tmobileID;
@synthesize tmobileType;
@synthesize tuserType;
@synthesize tcityID;
@synthesize selectView;
@synthesize lb_pickerTitle;
@synthesize xmlParser;
@synthesize webData;
@synthesize recordResults;
@synthesize soapResults;
@synthesize btn_Register;
@synthesize lb_title;
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
    selIndex = -1;
    cityArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [Setting sharedInstance].Cities.count; i++) {
        State *obj = [[Setting sharedInstance].Cities objectAtIndex:i];
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            [cityArray addObject:obj.stateNameEn];
        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
            [cityArray addObject:obj.stateNameAr];
    }
    [dataPicker reloadAllComponents];
    soapResults = Nil;
    recordResults = FALSE;
    CGRect tmpRect = selectView.frame;
    tmpRect.origin.y = self.view.frame.size.height;
    [selectView setFrame:tmpRect];
    if ([[Setting sharedInstance].customer.customerID isEqualToString:@"0"]){
        tName.text = @"";
        tMobileNo.text = @"";
        tSelectCity.text = @"";
        tEmail.text = @"";
        tUsername.text = @"";
        tPassword.text = @"";
        tConfirm.text = @"";
        lb_title.text = @"Register";
        [btn_Register setBackgroundImage:[UIImage imageNamed:@"btn_register.png"] forState:UIControlStateNormal];
    }
    else{
        tName.text = [Setting sharedInstance].customer.fullName;
        tMobileNo.text = [Setting sharedInstance].customer.Mobile;
        for (int i = 0; i < [Setting sharedInstance].Cities.count; i++) {
            State *obj = [[Setting sharedInstance].Cities objectAtIndex:i];
            if ([obj.stateID isEqualToString:[Setting sharedInstance].customer.StateID])
            {
                if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                    tSelectCity.text = obj.stateNameEn;
                else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
                    tSelectCity.text = obj.stateNameAr;
                break;
            }
        }
        tcityID = [Setting sharedInstance].customer.StateID;
        tareaID = [Setting sharedInstance].customer.AreaID;
        tEmail.text = [Setting sharedInstance].customer.Email;
        tUsername.text = [Setting sharedInstance].customer.Username;
        tPassword.text = @"";
        tConfirm.text = @"";
        lb_title.text = @"Customer Profile";
        [btn_Register setBackgroundImage:[UIImage imageNamed:@"btn_update.png"] forState:UIControlStateNormal];
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
    return [[Setting sharedInstance].Cities count];
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [cityArray objectAtIndex:row];
}
- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)onBtnSelectCity:(id)sender {

    if (selIndex != -1) {
        [dataPicker selectRow:selIndex inComponent:0 animated:YES];
        lb_pickerTitle.text = [cityArray objectAtIndex:selIndex];
    }
    else
    {
        [dataPicker selectRow:0 inComponent:0 animated:YES];
        selIndex = 0;
    }
    [UIView beginAnimations:@"AdResize" context:nil];
    [UIView setAnimationDuration:0.7];
    
    CGRect newFrame = CGRectMake(selectView.frame.origin.x, self.view.frame.size.height - selectView.frame.size.height, selectView.frame.size.width, selectView.frame.size.height);
    
    selectView.frame = newFrame;
    [UIView commitAnimations];
}

- (IBAction)onBtnRegister:(id)sender {
    if ([tName.text isEqualToString:@""]) {
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Please enter your name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        return;
    }
    else if ([tMobileNo.text isEqualToString:@""]) {
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Please enter your mobile number." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        return;
    }
    else if ([tSelectCity.text isEqualToString:@""]) {
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Please enter your city." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        return;
    }
    else if ([tEmail.text isEqualToString:@""]) {
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Please enter your email address." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        return;
    }
    else if ([tUsername.text isEqualToString:@""]) {
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Please enter your username." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        return;
    }
    else if ([tPassword.text isEqualToString:@""]) {
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Please enter your password." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        return;
    }
    else if ([tConfirm.text isEqualToString:@""]) {
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Please enter your password confirm." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        return;
    }
    
    else if (![tConfirm.text isEqualToString:tPassword.text]) {
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Please enter your password again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
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
    tmobileID = @"e19871093ae0910";
    taddress = @"";
    tmobileType = @"2";
    tuserType = @"0";
    taccessToken = @"";
    if ([[Setting sharedInstance].customer.customerID isEqualToString:@"0"]){
        NSString *soapMessage = [NSString stringWithFormat:
                                 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                 "<soap:Body>\n"
                                 "<CustomerRegisterNew xmlns=\"http://tempuri.org/\">\n"
                                 "<Name>%@</Name>\n"
                                 "<Email>%@</Email>\n"
                                 "<MobileNumber>%@</MobileNumber>\n"
                                 "<MobileID>e19871093ae0910</MobileID>\n"
                                 "<CityID>%@</CityID>\n"
                                 "<AreaID>%@</AreaID>\n"
                                 "<Address></Address>\n"
                                 "<Username>%@</Username>\n"
                                 "<Password>%@</Password>\n"
                                 "<Language>%d</Language>\n"
                                 "<MobileType>2</MobileType>\n"
                                 "<UserType>0</UserType>\n"
                                 "<AccessToken></AccessToken>\n"
                                 "</CustomerRegisterNew>\n"
                                 "</soap:Body>\n"
                                 "</soap:Envelope>\n", tName.text, tEmail.text, tMobileNo.text, tcityID, tareaID, tUsername.text, tPassword.text, myLang];
        NSLog(@"soapMessage = %@\n", soapMessage);
        
        NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=CustomerRegisterNew"];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
        
        [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest addValue: @"http://tempuri.org/CustomerRegisterNew" forHTTPHeaderField:@"SOAPAction"];
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
    else{
        
        NSString *soapMessage = [NSString stringWithFormat:
                                 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                 "<soap:Body>\n"
                                 "<CustomerUpdateProfile xmlns=\"http://tempuri.org/\">\n"
                                 "<CustomerID>%@</CustomerID>\n"
                                 "<Name>%@</Name>\n"
                                 "<Email>%@</Email>\n"
                                 "<MobileNumber>%@</MobileNumber>\n"
                                 "<MobileID>e19871093ae0910</MobileID>\n"
                                 "<CityID>%@</CityID>\n"
                                 "<AreaID>%@</AreaID>\n"
                                 "<Address></Address>\n"
                                 "<Username>%@</Username>\n"
                                 "<Password>%@</Password>\n"
                                 "<Language>%d</Language>\n"
                                 "<MobileType>2</MobileType>\n"
                                 "</CustomerUpdateProfile>\n"
                                 "</soap:Body>\n"
                                 "</soap:Envelope>\n", [Setting sharedInstance].customer.customerID, tName.text, tEmail.text, tMobileNo.text, tcityID, tareaID, tUsername.text, tPassword.text, myLang];
        NSLog(@"soapMessage = %@\n", soapMessage);
        
        NSURL *url = [NSURL URLWithString:@"http://q8supermarket.com/Services/MobileService.asmx?op=CustomerUpdateProfile"];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
        
        [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest addValue: @"http://tempuri.org/CustomerUpdateProfile" forHTTPHeaderField:@"SOAPAction"];
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
    if ([[Setting sharedInstance].customer.customerID isEqualToString:@"0"]){
        if( [elementName isEqualToString:@"CustomerID"])
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
    else{
        if ([elementName isEqualToString:@"ErrMessage"]){
            if(!soapResults)
            {
                soapResults = [[NSMutableString alloc] init];
            }
            recordResults = TRUE;
        }
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
    if ([[Setting sharedInstance].customer.customerID isEqualToString:@"0"]) {
        
    
            if ([elementName isEqualToString:@"ErrMessage"]){
                recordResults = FALSE;
                if (![soapResults isEqualToString:@""]) {
                    NSLog(@"error");
                    UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                                message:@"Registration failure." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    
                    [mes show];
                }
                soapResults = nil;
            }

            if( [elementName isEqualToString:@"CustomerID"])
            {
            recordResults = FALSE;
            if (![soapResults isEqualToString:@""]) {
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Infomation"
                                                        message:@"You are registered successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
                [mes show];
                [self.navigationController popViewControllerAnimated:YES];
            }
            soapResults = nil;
     
        }
    }
    else{
        if ([elementName isEqualToString:@"ErrMessage"]){
            recordResults = FALSE;
            if (![soapResults isEqualToString:@""]) {
                NSLog(@"error");
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"Update failure." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                
                [mes show];
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
                [Setting sharedInstance].customer.fullName = tName.text;
                [Setting sharedInstance].customer.Email = tEmail.text;
                [Setting sharedInstance].customer.Mobile = tMobileNo.text;
                [Setting sharedInstance].customer.StateID = tcityID;
                [Setting sharedInstance].customer.AreaID = tareaID;
                [Setting sharedInstance].customer.Username = tUsername.text;
                [Setting sharedInstance].customer.Password = tPassword.text;
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Information"
                                                            message:@"Your profile is updated successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                
                [mes show];
            }
            soapResults = nil;
        }
    }
}

- (IBAction)onDone:(id)sender {
    State *obj = [[Setting sharedInstance].Cities objectAtIndex:selIndex];
    tcityID = obj.stateID;
    for (int i = 0; i < [Setting sharedInstance].Areas.count; i++) {
        Area *areaObj = [[Setting sharedInstance].Areas objectAtIndex:i];
        if ([areaObj.areaStateID isEqualToString:tcityID]){
            tareaID = areaObj.areaID;
            break;
        }
    }
    tSelectCity.text = [cityArray objectAtIndex:selIndex];
    [UIView beginAnimations:@"AdResize" context:nil];
    [UIView setAnimationDuration:0.7];

    CGRect newFrame = CGRectMake(selectView.frame.origin.x, self.view.frame.size.height, selectView.frame.size.width, selectView.frame.size.height);

    selectView.frame = newFrame;
    [UIView commitAnimations];
}
@end
