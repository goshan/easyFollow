//
//  mainViewController.h
//  easyFollow
//
//  Created by Qiu Han on 10/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tipsAlert.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CoreLocation/CoreLocation.h>
#import "foundPersonViewController.h"

@interface mainViewController : UIViewController <CLLocationManagerDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *starViewNormal;
@property (retain, nonatomic) IBOutlet UIImageView *starViewShining;
@property (retain, nonatomic) IBOutlet UIImageView *starViewStatic;
@property (retain, nonatomic) IBOutlet UIImageView *starViewDynamic;
@property (retain, nonatomic) IBOutlet UIButton *shakeButton;
@property (retain, nonatomic) IBOutlet UIButton *showButton;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property(retain, nonatomic) tipsAlert *tips;

@property (nonatomic) SystemSoundID lookingForSoundID;
@property (nonatomic) SystemSoundID foundSoundID;

@property(retain, nonatomic) CLLocationManager *locationManager;

@property(retain, nonatomic) foundPersonViewController *personViewController;

@property(retain, nonatomic) NSTimer *starWobbleTimer;

@property(retain, nonatomic) NSTimer *starBlinkTimer;

@property(retain, nonatomic) NSTimer *starRotateTimer;

@end
