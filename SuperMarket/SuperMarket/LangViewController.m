//
//  LangViewController.m
//  SuperMarket
//
//  Created by phoenix on 12/8/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "LangViewController.h"
#import "Setting.h"
@interface LangViewController ()

@end

@implementation LangViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtnArab:(id)sender {
    [Setting sharedInstance].myLanguage = @"Arab";
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnEnglish:(id)sender {
    [Setting sharedInstance].myLanguage = @"En";
    [self.navigationController popViewControllerAnimated:YES];
}
@end
