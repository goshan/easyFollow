//
//  registViewController.h
//  easyFollow
//
//  Created by Qiu Han on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"
#import "gTencentApi.h"

@interface registViewController : UIViewController <RenrenDelegate, WBEngineDelegate, gTencentDelegate>


@property(retain, nonatomic) WBEngine *sina;

@property(retain, nonatomic) gTencentApi *tencent;

@property (retain, nonatomic) IBOutlet UITextField *IPText;


- (IBAction)renrenLogin:(id)sender;

- (IBAction)sinaLogin:(id)sender;

- (IBAction)tencentLogin:(id)sender;

- (IBAction)regist:(id)sender;

@end
