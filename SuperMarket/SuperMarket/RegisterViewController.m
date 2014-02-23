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
#import "MBProgressHUD.h"
#import "SecureUDID.h"
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
@synthesize tNameView;
@synthesize tCityView;
@synthesize tConfirmView;
@synthesize tMobileNoView;
@synthesize tPasswordView;
@synthesize tUserView;
@synthesize tEmailView;
@synthesize btn_city;
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
    if (IS_IPHONE_4)
    {
        [tNameView setFrame:CGRectMake(tNameView.frame.origin.x, 61, tNameView.frame.size.width, tNameView.frame.size.height)];
        [tMobileNoView setFrame:CGRectMake(tMobileNoView.frame.origin.x, 105, tMobileNoView.frame.size.width, tMobileNoView.frame.size.height)];
        [tCityView setFrame:CGRectMake(tCityView.frame.origin.x, 149, tCityView.frame.size.width, tCityView.frame.size.height)];
        [tEmailView setFrame:CGRectMake(tEmailView.frame.origin.x, 193, tEmailView.frame.size.width, tEmailView.frame.size.height)];
        [tUserView setFrame:CGRectMake(tUserView.frame.origin.x, 237, tUserView.frame.size.width, tUserView.frame.size.height)];
        [tPasswordView setFrame:CGRectMake(tPasswordView.frame.origin.x, 281, tPasswordView.frame.size.width, tPasswordView.frame.size.height)];
        [tConfirmView setFrame:CGRectMake(tConfirmView.frame.origin.x, 325, tConfirmView.frame.size.width, tConfirmView.frame.size.height)];
        [btn_Register setFrame:CGRectMake(btn_Register.frame.origin.x, 369, btn_Register.frame.size.width, btn_Register.frame.size.height)];
        
    }
    else if (IS_IPHONE_5){
        [tNameView setFrame:CGRectMake(tNameView.frame.origin.x, 70, tNameView.frame.size.width, tNameView.frame.size.height)];
        [tMobileNoView setFrame:CGRectMake(tMobileNoView.frame.origin.x, 120, tMobileNoView.frame.size.width, tMobileNoView.frame.size.height)];
        [tCityView setFrame:CGRectMake(tCityView.frame.origin.x, 170, tCityView.frame.size.width, tCityView.frame.size.height)];
        [tEmailView setFrame:CGRectMake(tEmailView.frame.origin.x, 220, tEmailView.frame.size.width, tEmailView.frame.size.height)];
        [tUserView setFrame:CGRectMake(tUserView.frame.origin.x, 270, tUserView.frame.size.width, tUserView.frame.size.height)];
        [tPasswordView setFrame:CGRectMake(tPasswordView.frame.origin.x, 320, tPasswordView.frame.size.width, tPasswordView.frame.size.height)];
        [tConfirmView setFrame:CGRectMake(tConfirmView.frame.origin.x, 370, tConfirmView.frame.size.width, tConfirmView.frame.size.height)];
        [btn_Register setFrame:CGRectMake(btn_Register.frame.origin.x, 435, btn_Register.frame.size.width, btn_Register.frame.size.height)];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    selIndex = -1;
    cityArray = [[NSMutableArray alloc]init];
    [dataPicker setBackgroundColor:[UIColor whiteColor]];
    
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
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        {
            lb_title.text = @"Register";
            tPassword.placeholder = @"Password";
            tConfirm.placeholder = @"Confirm Password";
            lb_pickerTitle.text = @"Select City";
            [self.btnDone setBackgroundImage:[UIImage imageNamed:@"btn_done_mylist.png"] forState:UIControlStateNormal];
            [self.btnDone setBackgroundImage:[UIImage imageNamed:@"btn_done_mylist.png"] forState:UIControlStateHighlighted];
            [self.btnDone setBackgroundImage:[UIImage imageNamed:@"btn_done_mylist.png"] forState:UIControlStateSelected];
            tName.placeholder = @"Name";
            tMobileNo.placeholder = @"Mobile No.";
            tSelectCity.placeholder = @"Select City";
            tEmail.placeholder = @"E-Mail";
            tUsername.placeholder = @"Username";
            
            
        }else{
            lb_title.text = @"تسجيل";
            tPassword.placeholder = @"كلمة المرور";
            tConfirm.placeholder = @"تأكيد كلمة المرور";
            lb_pickerTitle.text = @"اختر المدينة";
            [self.btnDone setBackgroundImage:[UIImage imageNamed:@"arab_done_mylist.png"] forState:UIControlStateNormal];
            [self.btnDone setBackgroundImage:[UIImage imageNamed:@"arab_done_mylist.png"] forState:UIControlStateHighlighted];
            [self.btnDone setBackgroundImage:[UIImage imageNamed:@"arab_done_mylist.png"] forState:UIControlStateSelected];
            
            tName.placeholder = @"الاسم";
            tMobileNo.placeholder = @"النقال";
            tSelectCity.placeholder = @"اختر المدينة";
            tEmail.placeholder = @"البريد الالكتروني";
            tUsername.placeholder = @"اسم المستخدم";
            

        }
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
            [btn_Register setBackgroundImage:[UIImage imageNamed:@"btn_register.png"] forState:UIControlStateNormal];
        else
            [btn_Register setBackgroundImage:[UIImage imageNamed:@"arab_register.png"] forState:UIControlStateNormal];
        
        btn_Register.hidden = NO;
        
        tName.userInteractionEnabled = YES;
        tMobileNo.userInteractionEnabled = YES;
        tSelectCity.userInteractionEnabled = YES;
        tEmail.userInteractionEnabled = YES;
        tUsername.userInteractionEnabled = YES;
        btn_city.hidden = NO;
        tPassword.hidden = NO;
        tConfirm.hidden = NO;
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
        if ([[Setting sharedInstance].customer.UserType isEqualToString:@"2"]){
            tEmail.text = @"";
            tName.text = @"";
        }
        tUsername.text = [Setting sharedInstance].customer.Username;
        tPassword.text = @"";
        tConfirm.text = @"";
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            lb_title.text = @"Customer Profile";
            lb_pickerTitle.text = @"Select City";
            [self.btnDone setBackgroundImage:[UIImage imageNamed:@"btn_done_mylist.png"] forState:UIControlStateNormal];
            [self.btnDone setBackgroundImage:[UIImage imageNamed:@"btn_done_mylist.png"] forState:UIControlStateHighlighted];
            [self.btnDone setBackgroundImage:[UIImage imageNamed:@"btn_done_mylist.png"] forState:UIControlStateSelected];
        }
        else{
            lb_title.text = @"بيانات العميل";
            lb_pickerTitle.text = @"اختر المدينة";
            [self.btnDone setBackgroundImage:[UIImage imageNamed:@"arab_done_mylist.png"] forState:UIControlStateNormal];
            [self.btnDone setBackgroundImage:[UIImage imageNamed:@"arab_done_mylist.png"] forState:UIControlStateHighlighted];
            [self.btnDone setBackgroundImage:[UIImage imageNamed:@"arab_done_mylist.png"] forState:UIControlStateSelected];
        }
        
        if ([[Setting sharedInstance].customer.UserType isEqualToString:@"0"]){
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                [btn_Register setBackgroundImage:[UIImage imageNamed:@"btn_update.png"] forState:UIControlStateNormal];
            else
                [btn_Register setBackgroundImage:[UIImage imageNamed:@"arab_update.png"] forState:UIControlStateNormal];
            
            btn_Register.hidden = NO;
            tName.userInteractionEnabled = YES;
            tMobileNo.userInteractionEnabled = YES;
            tSelectCity.userInteractionEnabled = YES;
            tEmail.userInteractionEnabled = YES;
            tUsername.userInteractionEnabled = YES;
            tPassword.userInteractionEnabled = YES;
            tConfirm.userInteractionEnabled = YES;
            btn_city.hidden = NO;
        }
        else
        {
            btn_Register.hidden = YES;
            
            tName.userInteractionEnabled = NO;
            tMobileNo.userInteractionEnabled = NO;
            tSelectCity.userInteractionEnabled = NO;
            btn_city.hidden = YES;
            tEmail.userInteractionEnabled = NO;
            tUsername.userInteractionEnabled = NO;
            tPassword.userInteractionEnabled = NO;
            tConfirm.userInteractionEnabled = NO;
        }
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.bgImageView setFrame:CGRectMake(self.bgImageView.frame.origin.x, 54, self.bgImageView.frame.size.width, self.bgImageView.frame.size.height)];
    if (IS_IPHONE_4)
    {
        [tNameView setFrame:CGRectMake(tNameView.frame.origin.x, 61, tNameView.frame.size.width, tNameView.frame.size.height)];
        [tMobileNoView setFrame:CGRectMake(tMobileNoView.frame.origin.x, 105, tMobileNoView.frame.size.width, tMobileNoView.frame.size.height)];
        [tCityView setFrame:CGRectMake(tCityView.frame.origin.x, 149, tCityView.frame.size.width, tCityView.frame.size.height)];
        [tEmailView setFrame:CGRectMake(tEmailView.frame.origin.x, 193, tEmailView.frame.size.width, tEmailView.frame.size.height)];
        [tUserView setFrame:CGRectMake(tUserView.frame.origin.x, 237, tUserView.frame.size.width, tUserView.frame.size.height)];
        [tPasswordView setFrame:CGRectMake(tPasswordView.frame.origin.x, 281, tPasswordView.frame.size.width, tPasswordView.frame.size.height)];
        [tConfirmView setFrame:CGRectMake(tConfirmView.frame.origin.x, 325, tConfirmView.frame.size.width, tConfirmView.frame.size.height)];
        [btn_Register setFrame:CGRectMake(btn_Register.frame.origin.x, 369, btn_Register.frame.size.width, btn_Register.frame.size.height)];
        
    }
    else if (IS_IPHONE_5){
        [tNameView setFrame:CGRectMake(tNameView.frame.origin.x, 70, tNameView.frame.size.width, tNameView.frame.size.height)];
        [tMobileNoView setFrame:CGRectMake(tMobileNoView.frame.origin.x, 120, tMobileNoView.frame.size.width, tMobileNoView.frame.size.height)];
        [tCityView setFrame:CGRectMake(tCityView.frame.origin.x, 170, tCityView.frame.size.width, tCityView.frame.size.height)];
        [tEmailView setFrame:CGRectMake(tEmailView.frame.origin.x, 220, tEmailView.frame.size.width, tEmailView.frame.size.height)];
        [tUserView setFrame:CGRectMake(tUserView.frame.origin.x, 270, tUserView.frame.size.width, tUserView.frame.size.height)];
        [tPasswordView setFrame:CGRectMake(tPasswordView.frame.origin.x, 320, tPasswordView.frame.size.width, tPasswordView.frame.size.height)];
        [tConfirmView setFrame:CGRectMake(tConfirmView.frame.origin.x, 370, tConfirmView.frame.size.width, tConfirmView.frame.size.height)];
        [btn_Register setFrame:CGRectMake(btn_Register.frame.origin.x, 435, btn_Register.frame.size.width, btn_Register.frame.size.height)];
    }
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [UIView beginAnimations:@"AdResize" context:nil];
    [UIView setAnimationDuration:0.7];
    
    CGRect newFrame = CGRectMake(selectView.frame.origin.x, self.view.frame.size.height, selectView.frame.size.width, selectView.frame.size.height);
    
    selectView.frame = newFrame;
    [UIView commitAnimations];
    if (textField == tMobileNo)
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    else if (textField == tPassword || textField == tConfirm || textField == tUsername)
    {
        [self.bgImageView setFrame:CGRectMake(self.bgImageView.frame.origin.x, -46, self.bgImageView.frame.size.width, self.bgImageView.frame.size.height)];
        if (IS_IPHONE_4)
        {
            [tNameView setFrame:CGRectMake(tNameView.frame.origin.x, -59, tNameView.frame.size.width, tNameView.frame.size.height)];
            [tMobileNoView setFrame:CGRectMake(tMobileNoView.frame.origin.x, -15, tMobileNoView.frame.size.width, tMobileNoView.frame.size.height)];
            [tCityView setFrame:CGRectMake(tCityView.frame.origin.x, 29, tCityView.frame.size.width, tCityView.frame.size.height)];
            [tEmailView setFrame:CGRectMake(tEmailView.frame.origin.x, 73, tEmailView.frame.size.width, tEmailView.frame.size.height)];
            [tUserView setFrame:CGRectMake(tUserView.frame.origin.x, 117, tUserView.frame.size.width, tUserView.frame.size.height)];
            [tPasswordView setFrame:CGRectMake(tPasswordView.frame.origin.x, 161, tPasswordView.frame.size.width, tPasswordView.frame.size.height)];
            [tConfirmView setFrame:CGRectMake(tConfirmView.frame.origin.x, 205, tConfirmView.frame.size.width, tConfirmView.frame.size.height)];

            
        }
        else if (IS_IPHONE_5){
            [tNameView setFrame:CGRectMake(tNameView.frame.origin.x, -30, tNameView.frame.size.width, tNameView.frame.size.height)];
            [tMobileNoView setFrame:CGRectMake(tMobileNoView.frame.origin.x, 20, tMobileNoView.frame.size.width, tMobileNoView.frame.size.height)];
            [tCityView setFrame:CGRectMake(tCityView.frame.origin.x, 70, tCityView.frame.size.width, tCityView.frame.size.height)];
            [tEmailView setFrame:CGRectMake(tEmailView.frame.origin.x, 120, tEmailView.frame.size.width, tEmailView.frame.size.height)];
            [tUserView setFrame:CGRectMake(tUserView.frame.origin.x, 170, tUserView.frame.size.width, tUserView.frame.size.height)];
            [tPasswordView setFrame:CGRectMake(tPasswordView.frame.origin.x, 220, tPasswordView.frame.size.width, tPasswordView.frame.size.height)];
            [tConfirmView setFrame:CGRectMake(tConfirmView.frame.origin.x, 270, tConfirmView.frame.size.width, tConfirmView.frame.size.height)];

        }
    }
    else{
        [self.bgImageView setFrame:CGRectMake(self.bgImageView.frame.origin.x, 54, self.bgImageView.frame.size.width, self.bgImageView.frame.size.height)];
        if (IS_IPHONE_4)
        {
            [tNameView setFrame:CGRectMake(tNameView.frame.origin.x, 61, tNameView.frame.size.width, tNameView.frame.size.height)];
            [tMobileNoView setFrame:CGRectMake(tMobileNoView.frame.origin.x, 105, tMobileNoView.frame.size.width, tMobileNoView.frame.size.height)];
            [tCityView setFrame:CGRectMake(tCityView.frame.origin.x, 149, tCityView.frame.size.width, tCityView.frame.size.height)];
            [tEmailView setFrame:CGRectMake(tEmailView.frame.origin.x, 193, tEmailView.frame.size.width, tEmailView.frame.size.height)];
            [tUserView setFrame:CGRectMake(tUserView.frame.origin.x, 237, tUserView.frame.size.width, tUserView.frame.size.height)];
            [tPasswordView setFrame:CGRectMake(tPasswordView.frame.origin.x, 281, tPasswordView.frame.size.width, tPasswordView.frame.size.height)];
            [tConfirmView setFrame:CGRectMake(tConfirmView.frame.origin.x, 325, tConfirmView.frame.size.width, tConfirmView.frame.size.height)];
            
            
        }
        else if (IS_IPHONE_5){
            [tNameView setFrame:CGRectMake(tNameView.frame.origin.x, 70, tNameView.frame.size.width, tNameView.frame.size.height)];
            [tMobileNoView setFrame:CGRectMake(tMobileNoView.frame.origin.x, 120, tMobileNoView.frame.size.width, tMobileNoView.frame.size.height)];
            [tCityView setFrame:CGRectMake(tCityView.frame.origin.x, 170, tCityView.frame.size.width, tCityView.frame.size.height)];
            [tEmailView setFrame:CGRectMake(tEmailView.frame.origin.x, 220, tEmailView.frame.size.width, tEmailView.frame.size.height)];
            [tUserView setFrame:CGRectMake(tUserView.frame.origin.x, 270, tUserView.frame.size.width, tUserView.frame.size.height)];
            [tPasswordView setFrame:CGRectMake(tPasswordView.frame.origin.x, 320, tPasswordView.frame.size.width, tPasswordView.frame.size.height)];
            [tConfirmView setFrame:CGRectMake(tConfirmView.frame.origin.x, 370, tConfirmView.frame.size.width, tConfirmView.frame.size.height)];

        }
    }
    return TRUE;
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
    c.prevView = self;
    c.viewName = @"none";
    [self.revealSideViewController pushViewController:n onDirection:PPRevealSideDirectionRight withOffset:158 animated:TRUE];
    PP_RELEASE(c);
    PP_RELEASE(n);
}

- (IBAction)onBtnSelectCity:(id)sender {

    [tName resignFirstResponder];
    [tMobileNo resignFirstResponder];
    [tSelectCity resignFirstResponder];
    [tEmail resignFirstResponder];
    [tUsername resignFirstResponder];
    [tPassword resignFirstResponder];
    [tConfirm resignFirstResponder];
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
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Please enter your name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
            [mes show];
        }
        else{
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                        message:@"الرجاء ادخل اسمك" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
            
            [mes show];
        }
        return;
    }
    else if ([tMobileNo.text isEqualToString:@""]) {
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Please enter your mobile number." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        }else{
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                        message:@"الرجاي ادخل رقم جوالك" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
            
            [mes show];
        }
        return;
    }
    else if ([tSelectCity.text isEqualToString:@""]) {
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Please enter your city." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        }else{
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                        message:@"الرجاء اختيار المدينه" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
            
            [mes show];
        }
        return;
    }
    else if ([tEmail.text isEqualToString:@""]) {
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Please enter your email address." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        }else{
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                        message:@"الرجاء ادخل البريد الالكتروني" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
            
            [mes show];
        }

        return;
    }
    else if ([tUsername.text isEqualToString:@""]) {
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Please enter your username." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        }else{
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                        message:@"الرجاء ادخال اسم المستخدم" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
            
            [mes show];
        }

        return;
    }
    else if ([tPassword.text isEqualToString:@""]) {
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Please enter your password." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        }else{
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                        message:@"الرجاء ادخال كلمة مرور" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
            
            [mes show];
        }
        return;
    }
    else if ([tConfirm.text isEqualToString:@""]) {
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Please enter your password confirm." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        }else{
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                        message:@"الرجاء تأكيد كلمة المرور" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
            
            [mes show];
        }
        return;
    }
    
    else if (![tConfirm.text isEqualToString:tPassword.text]) {
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Please enter your password again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
        }else{
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"تحذير"
                                                        message:@"الرجاء اعادة ادخال كلمة المرور" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
            
            [mes show];
        }
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
    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"Loading..."];
    else
        [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"تحميل..."];
    
    tmobileID = [Setting sharedInstance].deviceTokenString;
    taddress = @"";
    tmobileType = @"2";
    tuserType = @"0";
    taccessToken = @"";
   /* [Setting sharedInstance].customer.MobileID = [SecureUDID UDIDForDomain:@"com.example.myapp" usingKey:@"superSecretCodeHere!@##%#$#%$^"];
    [Setting sharedInstance].customer.MobileID = [[Setting sharedInstance].customer.MobileID lowercaseString];*/
    if ([[Setting sharedInstance].customer.customerID isEqualToString:@"0"]){
        NSString *soapMessage = [NSString stringWithFormat:
                                 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                 "<soap:Body>\n"
                                 "<CustomerRegisterNew xmlns=\"http://tempuri.org/\">\n"
                                 "<Name>%@</Name>\n"
                                 "<Email>%@</Email>\n"
                                 "<MobileNumber>%@</MobileNumber>\n"
                                 "<MobileID>%@</MobileID>\n"
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
                                 "</soap:Envelope>\n", tName.text, tEmail.text, tMobileNo.text, tmobileID,  tcityID, tareaID, tUsername.text, tPassword.text, myLang];
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
                                 "<MobileID>%@</MobileID>\n"
                                 "<CityID>%@</CityID>\n"
                                 "<AreaID>%@</AreaID>\n"
                                 "<Address></Address>\n"
                                 "<Username>%@</Username>\n"
                                 "<Password>%@</Password>\n"
                                 "<Language>%d</Language>\n"
                                 "<MobileType>2</MobileType>\n"
                                 "</CustomerUpdateProfile>\n"
                                 "</soap:Body>\n"
                                 "</soap:Envelope>\n", [Setting sharedInstance].customer.customerID, tName.text, tEmail.text, tMobileNo.text, tmobileID, tcityID, tareaID, tUsername.text, tPassword.text, myLang];
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
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0)
        [self.navigationController popViewControllerAnimated:YES];
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([[Setting sharedInstance].customer.customerID isEqualToString:@"0"]) {
        
    
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

            if( [elementName isEqualToString:@"CustomerID"])
            {
            recordResults = FALSE;
            if (![soapResults isEqualToString:@""]) {
                    if ([soapResults isEqualToString:@"0"]) {
                    
                    soapResults = nil;
                }
                else{
                    if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
                        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Infomation"
                                                                    message:@"You are registered successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        
                        [mes show];
                        
                    }
                    else{
                        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"معلومات"
                                                                    message:@"تم تسجيلك بنجاح" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
                        
                        [mes show];

                    }
                    soapResults = nil;
                   // [self.navigationController popViewControllerAnimated:YES];
                }
            }
            soapResults = nil;
     
        }
    }
    else{
        if ([elementName isEqualToString:@"ErrMessage"]){
            recordResults = FALSE;
            if (![soapResults isEqualToString:@""]) {
                NSLog(@"error");
                [Setting sharedInstance].errString = soapResults;
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:[Setting sharedInstance].errString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
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
                if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
                UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Information"
                                                            message:@"Your profile is updated successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                
                [mes show];
                }else{
                    UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"معلومات"
                                                                message:@"تم تسجيل بيانات ملفك بنجاح" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles: nil];
                    
                    [mes show];
                }
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
