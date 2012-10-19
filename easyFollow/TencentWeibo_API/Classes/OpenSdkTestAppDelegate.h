//
//  MSFTestAppDelegate.h
//  MSFTest
//
//  Created by chen qi on 11-5-24.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OpenSdkTestViewController;
@class FeatureListViewController;

@interface OpenSdkTestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    OpenSdkTestViewController *viewController;
	UINavigationController* navigationController;
	FeatureListViewController* featureListViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet OpenSdkTestViewController *viewController;
@property(nonatomic,retain)UINavigationController* navigationController;
@end

