//
//  RegisterViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/4/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "ViewController.h"

@interface RegisterViewController : ViewController<UITextFieldDelegate>
- (IBAction)onBtnBack:(id)sender;
- (IBAction)onBtnList:(id)sender;
- (IBAction)onBtnSelectCity:(id)sender;
- (IBAction)onBtnRegister:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *tName;
@property (weak, nonatomic) IBOutlet UITextField *tMobileNo;
@property (weak, nonatomic) IBOutlet UITextField *tSelectCity;
@property (weak, nonatomic) IBOutlet UITextField *tEmail;
@property (weak, nonatomic) IBOutlet UITextField *tUsername;
@property (weak, nonatomic) IBOutlet UITextField *tPassword;
@property (weak, nonatomic) IBOutlet UITextField *tConfirm;

@end
