//
//  CompanyViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/1/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyViewController : UIViewController<UISearchBarDelegate>
- (IBAction)onBtnBack:(id)sender;
- (IBAction)onBtnSearch:(id)sender;
- (IBAction)onBtnShare:(id)sender;
- (IBAction)onBtnAbout:(id)sender;
- (IBAction)onBtnCancel:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnback;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (nonatomic, strong) NSString *companyName;
@end
