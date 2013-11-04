//
//  FavoriteViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/1/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
- (IBAction)onBtnCurrentOffer:(id)sender;
- (IBAction)onBtnExpiredOffer:(id)sender;
- (IBAction)onBtnList:(id)sender;
- (IBAction)onBtnRemove:(id)sender;
- (IBAction)onBtnPurchase:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lb_company;

@property (weak, nonatomic) IBOutlet UIImageView *img_back;
@property (weak, nonatomic) IBOutlet UITableView *favoriteTable;
@end
