//
//  MyAccountViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/4/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "ViewController.h"

@interface MyAccountViewController : ViewController<UITextFieldDelegate>
- (IBAction)onBtnList:(id)sender;
- (IBAction)onBtnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)onBtnGmail:(id)sender;
- (IBAction)onBtnFacebook:(id)sender;
- (IBAction)onBtnTwitter:(id)sender;
- (IBAction)onBtnRegister:(id)sender;
- (IBAction)onBtnLogin:(id)sender;

@end
