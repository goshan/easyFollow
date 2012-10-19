//
//  MSFTestAppDelegate.m
//  MSFTest
//
//  Created by chen qi on 11-5-24.
//  Copyright 2011 tencent. All rights reserved.
//

#import "OpenSdkTestAppDelegate.h"
#import "OpenSdkTestViewController.h"
#import "FeatureListViewController.h"

@implementation OpenSdkTestAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize navigationController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
   
	/*
	NSString *sdkDir = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/.SDKDataDir"];
	 NSString *svr_config_path = [sdkDir stringByAppendingPathComponent:@"sso_config.txt"];
	 NSString *valueUrl = @"ip=119.147.14.245port=62000"; // 测试环境
	NSString *valueUrl = @"ip=119.147.14.227port=14000";
	if (![[NSFileManager defaultManager] fileExistsAtPath:svr_config_path]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:sdkDir withIntermediateDirectories:YES attributes:nil error:nil];
	}
	BOOL connect = [valueUrl writeToFile:svr_config_path atomically:NO encoding:NSUTF8StringEncoding error:nil];
	*/
	
    // Override point for customization after application launch.
	featureListViewController = [[FeatureListViewController alloc] initWithStyle:UITableViewStyleGrouped];
	
	self.navigationController = [[UINavigationController alloc] initWithRootViewController:featureListViewController];
	self.window.rootViewController = self.navigationController;
	//[self.navigationController setNavigationBarHidden:TRUE];
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[featureListViewController release];
    [viewController release];
    [window release];
    [super dealloc];
}


@end
