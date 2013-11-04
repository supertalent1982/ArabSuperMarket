//
//  NewListViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/4/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "ViewController.h"

@interface NewListViewController : ViewController<UITableViewDataSource, UITableViewDelegate>
- (IBAction)onBtnBack:(id)sender;
- (IBAction)onBtnDone:(id)sender;
- (IBAction)onBtnAdd:(id)sender;
- (IBAction)onBtnList:(id)sender;
- (IBAction)onBtnPlus:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *toFriendView;
- (IBAction)onBtnSend:(id)sender;
- (IBAction)onBtnCancel:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *addlistTable;
@property (weak, nonatomic) IBOutlet UITableView *friendTable;

@end
