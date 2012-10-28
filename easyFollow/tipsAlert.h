//
//  tipsAlert.h
//  easyFollow
//
//  Created by Qiu Han on 10/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "Toast+UIView.h"

@interface tipsAlert : NSObject


@property(retain, nonatomic) MBProgressHUD *loadingSpinner;





- (tipsAlert *)initWith:(UIView *)view;
- (void)netErrorAlert;
- (void)notRegistAlert;
- (void)nearByNotFoundAlert;
- (void)showRegistLoadingWith:(UIView *)view;
- (void)hiddenRegistLoading;
- (void)showRegistFinishedWith:(UIView *)view andList:(NSArray *)list;

@end
