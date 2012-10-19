//
//  FeatureListViewController.h
//  MSFTest
//
//  Created by Ruifan Yuan on 6/14/11.
//  Copyright 2011 . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OpenSdk/MsfOpenSdkInterface.h"
#import "OpenSdk/WeiboInterface.h"

@interface FeatureListViewController : UITableViewController<MoLoginResultDelegate, WeiboResultDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
	NSArray* featureList;
    
    OpenMsfLoginViewController * _viewController;
	WeiboInterface* _WeiboInterface;
    
    NSString *_appKey;
    NSString *_appSecret;
    NSString *_accessKey;
    NSString *_accessSecret;
    NSString *_filePathName;
}
- (void)loginSucceeded:(NSString *)account tokens:(NSDictionary*)tokens;

@property (nonatomic,retain) NSString *appKey;
@property (nonatomic,retain) NSString *appSecret;
@property (nonatomic,retain) NSString *accessKey;
@property (nonatomic,retain) NSString *accessSecret;
@property (nonatomic,retain) NSString *filePathName;

@end
