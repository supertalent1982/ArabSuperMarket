//
//  SearchResultViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/24/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *arrayProductsWithCategory;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UITableView *table_Products;


- (IBAction)onBtnFavorite:(id)sender;

- (IBAction)onBtnPurchase:(id)sender;




- (IBAction)onFriend:(id)sender;
- (IBAction)onBack:(id)sender;


@end
