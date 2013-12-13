//
//  MoreViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/1/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "MoreViewController.h"
#import "MyAccountViewController.h"
#import "PPRevealSideViewController.h"
#import "FriendViewController.h"
#import "Setting.h"
#import "RegisterViewController.h"
#import "LangViewController.h"
#import "PurchaseViewController.h"
@interface MoreViewController ()

@end

@implementation MoreViewController
@synthesize myTableView;
@synthesize itemList;
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
	// Do any additional setup after loading the view.
    itemList = [[NSMutableArray alloc]init];
    [itemList addObject:@"My Account"];
    [itemList addObject:@"My Purchases"];
    [itemList addObject:@"Change Language"];
    [itemList addObject:@"About Us"];
    [itemList addObject:@"Rate this App"];
}
- (void)viewWillAppear:(BOOL)animated{
    if ([[Setting sharedInstance].customer.customerID isEqualToString:@"0"]){
        self.btnLogout.userInteractionEnabled = NO;
        self.btnLogout.alpha = 0.5;
    }
    else{
        self.btnLogout.userInteractionEnabled = YES;
        self.btnLogout.alpha = 1.0;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"MoreItemCell"];
    if (cell == Nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MoreItemCell"];
    
    UILabel *lb_item = (UILabel*)[cell viewWithTag:101];
    NSString *strItem = [itemList objectAtIndex:indexPath.row];
    
    lb_item.text = strItem;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return itemList.count;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 0:
        {
            UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            if ([[Setting sharedInstance].customer.customerID isEqualToString:@"0"]){
                MyAccountViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"AccountView"];
                [self.navigationController pushViewController:VC animated:YES];
            }
            else{
                RegisterViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"RegisterView"];
                [self.navigationController pushViewController:VC animated:YES];
            }
        }
            break;
        case 1:
        {
            UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            PurchaseViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"PurchaseView"];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 2:
        {
            UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
                LangViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"LanguageView"];
                [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)onBtnLogout:(id)sender {
    [Setting sharedInstance].customer = Nil;
    [Setting sharedInstance].customer = [[CustomerObject alloc] init];
    self.btnLogout.userInteractionEnabled = NO;
    self.btnLogout.alpha = 0.5;
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


@end
