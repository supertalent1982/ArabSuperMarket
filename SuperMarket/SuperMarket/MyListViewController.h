//
//  MyListViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/1/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
- (IBAction)onBtnAdd:(id)sender;
- (IBAction)onBtnList:(id)sender;
- (IBAction)onBtnSent:(id)sender;
- (IBAction)onBtnInbox:(id)sender;
- (IBAction)onBtnRemove:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *myListTable;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;

@end
