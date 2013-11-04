//
//  FriendViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/4/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "ViewController.h"

@interface FriendViewController : ViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *beFriendTable;
- (IBAction)onAddNewFriend:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *myFriendTable;
@end
