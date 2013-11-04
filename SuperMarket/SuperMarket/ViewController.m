//
//  ViewController.m
//  SuperMarket
//
//  Created by phoenix on 10/30/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "ViewController.h"
#import "Setting.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [self getDBPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    self.navigationController.navigationBarHidden = YES;
    
    if(!success) {
        
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Q8SupermarketDB.db"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}
- (NSString *) getDBPath {
    
    
    
    //Search for standard documents using NSSearchPathForDirectoriesInDomains
    //First Param = Searching the documents directory
    //Second Param = Searching the Users directory and not the System
    //Expand any tildes and identify home directories.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"Q8SupermarketDB.db"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtnArab:(id)sender {
    [Setting sharedInstance].myLanguage = @"Arab";
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabVC = [mainstoryboard instantiateViewControllerWithIdentifier:@"TabBarView"];
    
    [Setting sharedInstance].tabBarController = tabVC;
    [[Setting sharedInstance] customizeTabBar];
    [self.navigationController pushViewController:tabVC animated:YES];
}

- (IBAction)onBtnEnglish:(id)sender {
    [Setting sharedInstance].myLanguage = @"En";
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabVC = [mainstoryboard instantiateViewControllerWithIdentifier:@"TabBarView"];
    
    [Setting sharedInstance].tabBarController = tabVC;
    [[Setting sharedInstance] customizeTabBar];
    [self.navigationController pushViewController:tabVC animated:YES];
}
@end
