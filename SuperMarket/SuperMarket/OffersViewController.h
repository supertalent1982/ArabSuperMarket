//
//  OffersViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/1/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@interface OffersViewController : UIViewController<UIGestureRecognizerDelegate, UIScrollViewDelegate>{
    sqlite3 *projectDB;
    NSString *databasePath;
}
- (IBAction)select_offers:(id)sender;
@property (nonatomic, strong) NSMutableArray *logoArray;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollCompanies;
@end
