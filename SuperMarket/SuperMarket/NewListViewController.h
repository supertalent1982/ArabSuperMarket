//
//  NewListViewController.h
//  SuperMarket
//
//  Created by phoenix on 11/4/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "ViewController.h"

@interface NewListViewController : ViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
- (IBAction)onBtnBack:(id)sender;
- (IBAction)onBtnDone:(id)sender;
- (IBAction)onBtnAdd:(id)sender;
- (IBAction)onBtnList:(id)sender;
- (IBAction)onCancelMeasure:(id)sender;
- (IBAction)onBtnPlus:(id)sender;
- (IBAction)onAddMeasure:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *tListName;
@property (weak, nonatomic) IBOutlet UIButton *btn_done;
@property (weak, nonatomic) IBOutlet UIView *toFriendView;
@property (weak, nonatomic) IBOutlet UIView *selectionView;
- (IBAction)onBtnSend:(id)sender;
- (IBAction)onBtnCancel:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *addlistTable;
@property (weak, nonatomic) IBOutlet UITableView *friendTable;
@property (nonatomic, strong) NSMutableArray *arrayMyList;
@property (nonatomic, strong) NSMutableArray *arraySubCategories;
@property (nonatomic, strong) NSMutableArray *arrayMeasure;
@property (nonatomic, strong) NSMutableArray *arrayQuantity;
@property (weak, nonatomic) IBOutlet UIPickerView *measurePicker;
@property (nonatomic, assign) int selQuantyIndex;
@property (nonatomic, assign) int selMeasureIndex;
@property (nonatomic, assign) int selItem;
@property (nonatomic, assign) int mainNum;
@end
