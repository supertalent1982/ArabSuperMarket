//
//  AppDelegate.m
//  SuperMarket
//
//  Created by phoenix on 10/30/13.
//  Copyright (c) 2013 phoenix. All rights reserved.
//

#import "AppDelegate.h"
#import "Setting.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = PP_AUTORELEASE([[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]);
    
    /*
    
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    
    if (ver_float >= 7.0){
        if (IS_IPHONE_5)
            [self.window setFrame:CGRectMake(0, 20, 320, 548)];
        else if (IS_IPHONE_4)
            [self.window setFrame:CGRectMake(0, 20, 320, 460)];
    }*/
    //MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *rootview = [mainstoryboard instantiateViewControllerWithIdentifier:@"FirstView"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootview];
    _revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:nav];
    
    _revealSideViewController.delegate = self;
    
    self.window.rootViewController = _revealSideViewController;
    
    PP_RELEASE(rootview);
    PP_RELEASE(nav);
    
    self.window.backgroundColor = [UIColor whiteColor];

     [self.window makeKeyAndVisible];
    
    // Let the device know we want to receive push notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        
    
    return YES;
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString* deviceTokenStr = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString: @"<>"]] stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"My token is: %@", deviceTokenStr);
    [Setting sharedInstance].deviceTokenString = deviceTokenStr;

}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
