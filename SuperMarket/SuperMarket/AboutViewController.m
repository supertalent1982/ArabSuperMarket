//
//  AboutViewController.m
//  SuperMarket
//
//  Created by phoenix on 11/2/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "AboutViewController.h"
#import "Setting.h"
@interface AboutViewController ()

@end

@implementation AboutViewController
@synthesize selCompany;
@synthesize img_companyLogo;
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
    if([[Setting sharedInstance].myLanguage isEqualToString:@"En"])
        self.lb_title.text = selCompany.companyNameEn;
    if([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"])
        self.lb_title.text = selCompany.companyNameAr;
/*
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
                querySQL = [NSString stringWithFormat: @"SELECT DescEn, AddressEn, Email, Phone, Fax FROM Companies WHERE NameEn=\"%@\"", self.companyName];
            else
                querySQL = [NSString stringWithFormat: @"SELECT DescAr, AddressAr, Email, Phone, Fax FROM Companies WHERE NameAr=\"%@\"", self.companyName];
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
                    self.lb_company_summary.text = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    self.lb_address.text = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    self.lb_email.text = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    self.lb_telephone.text = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                    self.lb_fax.text = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                   
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(projectDB);
        }
        
    }
 */
    if([[Setting sharedInstance].myLanguage isEqualToString:@"En"]){
        self.lb_company_summary.text = selCompany.companyDescEn;
        self.lb_address.text = selCompany.companyAddressEn;
        
    }
    if([[Setting sharedInstance].myLanguage isEqualToString:@"Arab"]){
        self.lb_company_summary.text = selCompany.companyDescAr;
        self.lb_address.text = selCompany.companyAddressAr;
        
    }
    self.lb_email.text = selCompany.companyEmail;
    self.lb_telephone.text = selCompany.companyPhone;
    self.lb_fax.text = selCompany.companyFax;
    [img_companyLogo setImageURL:[NSURL URLWithString:selCompany.companyAboutUsLogo]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnShare:(id)sender {
}
@end
