//
//  AboutViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/2/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "CompanyObject.h"
#import "Setting.h"
#import "AsyncImageView.h"
@interface AboutViewController : UIViewController{
    sqlite3 *projectDB;
    NSString *databasePath;
}

- (IBAction)onBtnBack:(id)sender;

- (IBAction)onBtnShare:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lb_company_summary;

@property (weak, nonatomic) IBOutlet UILabel *lb_telephone;
@property (weak, nonatomic) IBOutlet UILabel *lb_fax;
@property (weak, nonatomic) IBOutlet UILabel *lb_email;
@property (weak, nonatomic) IBOutlet UILabel *lb_address;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIImageView *img_branches;
@property (weak, nonatomic) IBOutlet AsyncImageView *img_companyLogo;
@property (nonatomic, strong) CompanyObject *selCompany;
@end
