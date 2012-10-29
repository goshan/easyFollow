//
//  foundPersonViewController.h
//  easyFollow
//
//  Created by Qiu Han on 10/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tipsAlert.h"

@interface foundPersonViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *renrenLabel;
@property (retain, nonatomic) IBOutlet UILabel *sinaLabel;
@property (retain, nonatomic) IBOutlet UILabel *tencentLabel;
@property (retain, nonatomic) IBOutlet UILabel *doubanLabel;

@property(retain, nonatomic) UIImageView *avatarFrameShining;

@property(retain, nonatomic) NSString *user_id;

@property(retain, nonatomic) NSDictionary *friendData;

@property(retain, nonatomic) tipsAlert *tips;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(NSDictionary *)data;

@end
