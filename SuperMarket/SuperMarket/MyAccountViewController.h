//
//  MyAccountViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/4/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@interface MyAccountViewController : UIViewController<UITextFieldDelegate>{
    sqlite3 *projectDB;
    NSString *databasePath;
}

- (IBAction)onBtnList:(id)sender;
- (IBAction)onForgot:(id)sender;
- (IBAction)onBtnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)onBtnGmail:(id)sender;
- (IBAction)onBtnFacebook:(id)sender;
- (IBAction)onBtnTwitter:(id)sender;
- (IBAction)onBtnRegister:(id)sender;
- (IBAction)onBtnLogin:(id)sender;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, assign) 	BOOL recordResults;
@end
