//
//  NewListViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/4/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "NewListViewController.h"
#import "PPRevealSideViewController.h"
#import "FriendViewController.h"
#import "Setting.h"
#import "MyListItem.h"
@interface NewListViewController ()

@end

@implementation NewListViewController
@synthesize toFriendView;
@synthesize friendTable;
@synthesize addlistTable;
@synthesize arrayMyList;
@synthesize arraySubCategories;
@synthesize measurePicker;
@synthesize selectionView;
@synthesize arrayMeasure;
@synthesize arrayQuantity;
@synthesize selMeasureIndex;
@synthesize selQuantyIndex;
@synthesize selItem;
@synthesize btn_done;
@synthesize mainNum;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated{
    mainNum = 0;
    self.tListName.text = @"";
	// Do any additional setup after loading the view.
    CGRect tmpRect = selectionView.frame;
    tmpRect.origin.y = self.view.frame.size.height;
    [selectionView setFrame:tmpRect];
    arrayMyList = [[NSMutableArray alloc]init];
    toFriendView.hidden = YES;
    arraySubCategories = [[NSMutableArray alloc]init];
    for (int i = 0; i < [Setting sharedInstance].SubCategories.count; i++) {
        MyListItem *item = [[MyListItem alloc]init];
        SubCategory *obj = [[Setting sharedInstance].SubCategories objectAtIndex:i];
        item.isMainCategory = FALSE;
        item.isSelected = FALSE;
        item.isOpened =FALSE;
        item.itemID = obj.mainCatID;
        item.itemSubID = obj.subCatID;
        item.measureQuantity = @"";
        item.measureUnit = @"";
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
            item.itemName = obj.subCatEn;
        }
        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
            item.itemName = obj.subCatAr;
        [arraySubCategories addObject:item];
    }
    for (int i = 0; i < [Setting sharedInstance].MainCategories.count; i++) {
        MainCategory *obj = [[Setting sharedInstance].MainCategories objectAtIndex:i];
        MyListItem *item = [[MyListItem alloc]init];
        item.isMainCategory = TRUE;
        item.isSelected = FALSE;
        item.isOpened = FALSE;
        item.itemID = obj.mainCatID;
        item.itemSubID = @"";
        item.measureQuantity = @"";
        item.measureUnit = @"";
        if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"]) {
            item.itemName = obj.mainCatNameEn;
        }
        else if ([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
            item.itemName = obj.mainCatNameAr;
        [arrayMyList addObject:item];
        
    }
    arrayQuantity = [[NSMutableArray alloc]init];
    for (int i = 1; i < 101; i++)
        [arrayQuantity addObject:[NSString stringWithFormat:@"%d", i]];
    arrayMeasure = [[NSMutableArray alloc]init];
    btn_done.alpha = 0.5;
    btn_done.userInteractionEnabled = NO;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        selQuantyIndex = row;
    }
    else if (component == 1)
        selMeasureIndex = row;

    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
        return [arrayQuantity count];
    else if (component == 1)
        return [arrayMeasure count];
    return -1;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0)
        return [arrayQuantity objectAtIndex:row];
    else
        return [arrayMeasure objectAtIndex:row];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnDone:(id)sender {
    if ([[Setting sharedInstance].customer.customerID isEqualToString:@"0"]) {
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"You must login to save your list." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
    }
    else{
        if ([self.tListName.text isEqualToString:@""]) {
            UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"Please enter your list name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [mes show];
            return;
        }
    [self.view bringSubviewToFront:toFriendView];
    toFriendView.hidden = NO;
    }
}

- (IBAction)onBtnAdd:(id)sender {
}

- (IBAction)onBtnList:(id)sender {
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // Session is open
    FriendViewController *c = [mainstoryboard instantiateViewControllerWithIdentifier:@"FriendManageView"];
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:c];
    c.navigationController.navigationBarHidden = YES;
    [self.revealSideViewController pushViewController:n onDirection:PPRevealSideDirectionRight withOffset:158 animated:TRUE];
    PP_RELEASE(c);
    PP_RELEASE(n);
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)onAddMeasure:(id)sender {
    if ([[Setting sharedInstance].customer.customerID isEqualToString:@"0"]){
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"You must login to add your list." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [mes show];
    }else{
        MyListItem *item = [arrayMyList objectAtIndex:selItem];
        item.isSelected = TRUE;
        item.measureQuantity = [arrayQuantity objectAtIndex:selQuantyIndex];
        item.measureUnit = [[Setting sharedInstance] getMeasureID:[arrayMeasure objectAtIndex:selMeasureIndex]];
    
        [UIView beginAnimations:@"AdResize" context:nil];
        [UIView setAnimationDuration:0.7];
    
        CGRect newFrame = CGRectMake(selectionView.frame.origin.x, self.view.frame.size.height, selectionView.frame.size.width, selectionView.frame.size.height);
    
        selectionView.frame = newFrame;
        [UIView commitAnimations];
    btn_done.alpha = 1.0;
    btn_done.userInteractionEnabled = YES;
    [addlistTable reloadData];
    }
}
- (IBAction)onCancelMeasure:(id)sender {
    
    [UIView beginAnimations:@"AdResize" context:nil];
    [UIView setAnimationDuration:0.7];
    
    CGRect newFrame = CGRectMake(selectionView.frame.origin.x, self.view.frame.size.height, selectionView.frame.size.width, selectionView.frame.size.height);
    
    selectionView.frame = newFrame;
    [UIView commitAnimations];
}

- (IBAction)onBtnPlus:(id)sender {
    NSIndexPath *indexPath = [addlistTable indexPathForCell:(UITableViewCell *)[[sender superview]superview]];
    MyListItem *item = [arrayMyList objectAtIndex:indexPath.row];
    if (item.isSelected == TRUE){
        item.isSelected = FALSE;
        int selItems = 0;
        for (int i = 0; i < arrayMyList.count; i++) {
            MyListItem *item = [arrayMyList objectAtIndex:i];
            if (item.isSelected == TRUE)
                selItems++;
        }
        if (selItems == 0) {
            btn_done.alpha = 0.5;
            btn_done.userInteractionEnabled = NO;
        }
        [addlistTable reloadData];
    }
    else{
        [arrayMeasure removeAllObjects];
        selMeasureIndex = 0;
        selQuantyIndex = 0;
        selItem = indexPath.row;
        for (int i = 0; i < arraySubCategories.count; i++) {
            SubCategory *obj = [[Setting sharedInstance].SubCategories objectAtIndex:i];
            if ([obj.subCatID isEqualToString:item.itemSubID]) {
                NSString *str = obj.subCatMeasures;
                NSArray *measures = [str componentsSeparatedByString:@","];
                for (int j = 0; j < measures.count; j++) {
                    NSString *unitStr = [measures objectAtIndex:j];
                    if (![[[Setting sharedInstance] getMeasure:unitStr] isEqualToString:@"Unknown"])
                        [arrayMeasure addObject:[[Setting sharedInstance] getMeasure:unitStr]];
                }
            }
        }
        [measurePicker reloadAllComponents];
        selectionView.hidden = NO;
        [self.view bringSubviewToFront:selectionView];
        [UIView beginAnimations:@"AdResize" context:nil];
        [UIView setAnimationDuration:0.7];
        
        CGRect newFrame = CGRectMake(selectionView.frame.origin.x, self.view.frame.size.height - selectionView.frame.size.height, selectionView.frame.size.width, selectionView.frame.size.height);
        
        selectionView.frame = newFrame;
        [UIView commitAnimations];
    }
   
}

- (IBAction)onBtnSend:(id)sender {
}

- (IBAction)onBtnCancel:(id)sender {
    toFriendView.hidden = YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyListItem *item = [arrayMyList objectAtIndex:indexPath.row];
    if (item.isMainCategory == TRUE) {
        if (item.isOpened == TRUE) {
            item.isOpened = FALSE;
            NSMutableArray *subArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < arraySubCategories.count; i++) {
                MyListItem *item1 = [arraySubCategories objectAtIndex:i];
                if ([item1.itemID isEqualToString:item.itemID])
                    [subArray addObject:item1];
            }
            [arrayMyList removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, subArray.count)]];
        }
        else{
            item.isOpened = TRUE;
            NSMutableArray *subArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < arraySubCategories.count; i++) {
                MyListItem *item1 = [arraySubCategories objectAtIndex:i];
                if ([item1.itemID isEqualToString:item.itemID])
                    [subArray addObject:item1];
            }
            [arrayMyList insertObjects:subArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, subArray.count)]];
        }
    }
    [tableView reloadData];
}
-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    if (_tableView == friendTable) {
        cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
        if (cell == Nil)
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendCell"];
    }
    else if (_tableView == addlistTable){
        
        MyListItem *item = [arrayMyList objectAtIndex:indexPath.row];
        UILabel *lb_itemName;
        if (item.isMainCategory == TRUE){
            mainNum++;
            
            cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"MainItem"];
            if (cell == Nil)
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainItem"];
            UIImageView *bgCell = (UIImageView*)[cell viewWithTag:121];
            if (mainNum % 2 == 1) {
                bgCell.image = [UIImage imageNamed:@"cell1.png"];
            }
            else{
                bgCell.image = [UIImage imageNamed:@"cell2.png"];
            }
            lb_itemName = (UILabel*)[cell viewWithTag:101];
            lb_itemName.text = item.itemName;
            UIImageView *imgArrow1 = (UIImageView*)[cell viewWithTag:103];
            UIImageView *imgArrow2 = (UIImageView*)[cell viewWithTag:105];
            if (item.isOpened == TRUE) {
                imgArrow1.hidden = YES;
                imgArrow2.hidden = NO;
            }
            else{
                imgArrow1.hidden = NO;
                imgArrow2.hidden = YES;
            }
        }
        else{
             cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"SubItem"];
             if (cell == Nil)
                 cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SubItem"];
            lb_itemName = (UILabel*)[cell viewWithTag:102];
            lb_itemName.text = item.itemName;
            UIButton *selButton = (UIButton*)[cell viewWithTag:104];
            if (item.isSelected == TRUE) {
                [selButton setBackgroundImage:[UIImage imageNamed:@"btn_close_mylist.png"] forState:UIControlStateNormal];
            }
            else
                [selButton setBackgroundImage:[UIImage imageNamed:@"btn_plus.png"] forState:UIControlStateNormal];
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arrayMyList.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 33;
}
@end
