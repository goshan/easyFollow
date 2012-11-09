//
//  registViewController.h
//  easyFollow
//
//  Created by Qiu Han on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tipsAlert.h"
#import "Renren.h"
#import "WBEngine.h"
#import "gTencentApi.h"
#import "gDoubanApi.h"


@interface registViewController : UIViewController <RenrenDelegate, WBEngineDelegate, gTencentDelegate, gDoubanDelegate>

@property (retain, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (retain, nonatomic) IBOutlet UINavigationItem *navigationTitle;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *registButton;
@property (retain, nonatomic) IBOutlet UISwitch *renrenSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *sinaSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *tencentSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *doubanSwitch;

@property(retain, nonatomic) NSNumber *update;
@property(retain, nonatomic) tipsAlert *tips;
@property(retain, nonatomic) WBEngine *sina;
@property(retain, nonatomic) gTencentApi *tencent;
@property(retain, nonatomic) gDoubanApi *douban;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isUpdate:(BOOL)update;


- (IBAction)renrenLogin:(id)sender;

- (IBAction)sinaLogin:(id)sender;

- (IBAction)tencentLogin:(id)sender;

- (IBAction)doubanLogin:(id)sender;

- (IBAction)regist:(id)sender;

@end
