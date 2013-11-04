//
//  Setting.h
//  VideoUploading
//
//  Created by phoenix on 10/13/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Setting : NSObject
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *myLanguage;
@property (nonatomic, strong) NSMutableArray *arrayCompany;
+ (Setting *)sharedInstance;
@property (strong, nonatomic) UITabBarController *tabBarController;
- (void)customizeTabBar;

@end
