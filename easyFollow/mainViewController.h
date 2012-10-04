//
//  mainViewController.h
//  easyFollow
//
//  Created by Qiu Han on 10/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreLocation/CoreLocation.h>

@interface mainViewController : UIViewController <CLLocationManagerDelegate>


@property (nonatomic) SystemSoundID soundID;

@property (retain, nonatomic) IBOutlet UIImageView *imageUp;

@property (retain, nonatomic) IBOutlet UIImageView *imageDown;

@property(retain, nonatomic) CLLocationManager *locationManager;

@end
