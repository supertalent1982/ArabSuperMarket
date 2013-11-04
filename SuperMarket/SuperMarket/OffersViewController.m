//
//  OffersViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/1/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "OffersViewController.h"
#import "Setting.h"
#import "CompanyViewController.h"
@interface OffersViewController ()

@end

@implementation OffersViewController
@synthesize logoArray;
@synthesize scrollCompanies;
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
    [Setting sharedInstance].arrayCompany = [[NSMutableArray alloc]init];
    logoArray = [[NSMutableArray alloc] init];
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Q8SuperMarketDB.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == YES)
    {
        sqlite3_stmt    *statement;
        
        
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &projectDB) == SQLITE_OK)
        {
            
            NSString *querySQL;
            if ([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
                querySQL= [NSString stringWithFormat: @"SELECT NameEn FROM Companies"];
            else
                querySQL= [NSString stringWithFormat: @"SELECT NameAr FROM Companies"];
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(projectDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) != SQLITE_ROW) {
                    NSLog(@"not matched");
                    UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@"Warning"
                                                                message:@"Please create new project." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    
                    [mes show];
                }
                else{
                    NSString *companyName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    
                    [[Setting sharedInstance].arrayCompany addObject:companyName];
                    
                    while (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        
                        NSString *companyName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                        
                        [[Setting sharedInstance].arrayCompany addObject:companyName];
                    }
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(projectDB);
        }

    }
    for (int i = 0; i< [Setting sharedInstance].arrayCompany.count; i++){
    UIView *companyLogoView = [[UIView alloc]initWithFrame:CGRectMake(23 + i * 277, 8, 262, 245)];
    UIImageView *imgLogo = [[UIImageView alloc]initWithFrame:CGRectMake(7, 0, 260, 245)];
        if (i == 0)
            imgLogo.image = [UIImage imageNamed:@"city_sample.png"];
        else
            imgLogo.image = [UIImage imageNamed:@"gulfmart_sample.png"];
        
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(select_offers:)];
    tapGesture.delegate = self;
    imgLogo.userInteractionEnabled = YES;
        imgLogo.tag = i + 1;
    [imgLogo addGestureRecognizer:tapGesture];
    [companyLogoView addSubview:imgLogo];
    [logoArray addObject:imgLogo];
    UIImageView *imgPin = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 121, 39)];
    imgPin.image = [UIImage imageNamed:@"company_pin.png"];
    [companyLogoView addSubview:imgPin];
    
    UILabel *lb_pin = [[UILabel alloc]initWithFrame:CGRectMake(17, 20, 91, 21)];
    lb_pin.text = [NSString stringWithFormat:@"%@ offers", [[Setting sharedInstance].arrayCompany objectAtIndex:i]];
    [lb_pin setFont:[UIFont fontWithName:@"Helvetica Neue" size:10.0]];
    [lb_pin setTextColor:[UIColor whiteColor]];
    [lb_pin setBackgroundColor:[UIColor clearColor]];
    [companyLogoView addSubview:lb_pin];
    
    NSString *bottomStr = [NSString stringWithFormat:@"Lastest Offers in %@", [[Setting sharedInstance].arrayCompany objectAtIndex:i]];
    UILabel *lb_bottom1 = [[UILabel alloc]initWithFrame:CGRectMake(31, 191, 211, 21)];
    lb_bottom1.text = bottomStr;
    [lb_bottom1 setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0]];
    [lb_bottom1 setTextColor:[UIColor whiteColor]];
    [lb_bottom1 setBackgroundColor:[UIColor clearColor]];
    [companyLogoView addSubview:lb_bottom1];
    
    
    UILabel *lb_bottom2 = [[UILabel alloc] initWithFrame:CGRectMake(31, 207, 211, 21)];
    lb_bottom2.text = @"Browse latest offers in supermarket";
    [lb_bottom2 setFont:[UIFont fontWithName:@"Helvetica Neue" size:10.0]];
    [lb_bottom2 setTextColor:[UIColor orangeColor]];
    [lb_bottom2 setBackgroundColor:[UIColor clearColor]];
    [companyLogoView addSubview:lb_bottom2];
    
    [scrollCompanies addSubview:companyLogoView];
    }
    [scrollCompanies setContentSize:CGSizeMake(320 + 276 * (logoArray.count - 1), 245)];
    scrollCompanies.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)select_offers:(id)sender {
    NSLog(@"offset = %f", scrollCompanies.contentOffset.x);
    CGFloat offsetScroll = scrollCompanies.contentOffset.x;

    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer*)sender;
    
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CompanyViewController *VC = [mainstoryboard instantiateViewControllerWithIdentifier:@"CompanyView"];
    VC.companyName = [[Setting sharedInstance].arrayCompany objectAtIndex:tapGesture.view.tag - 1];
    [self.navigationController pushViewController:VC animated:YES];
}
@end
