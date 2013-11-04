//
//  Setting.m
//  VideoUploading
//
//  Created by phoenix on 10/13/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "Setting.h"

static Setting *instance = nil;
@implementation Setting

@synthesize userEmail;
@synthesize myLanguage;
@synthesize arrayCompany;
+ (Setting *)sharedInstance
{
    if (instance == nil)
    {
     instance = [[Setting alloc] init];
    }
    
    return instance;
}

- (id)init
{
    self = [super init];
    arrayCompany = [[NSMutableArray alloc]init];
    return self;
}

- (void)customizeTabBar{
 //   UITabBar *tabBar = [Setting sharedInstance].tabBarController.tabBar;
  //  [tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg.png"]];
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabbar_bg.png"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
}

@end
