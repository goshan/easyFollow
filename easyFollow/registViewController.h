//
//  registViewController.h
//  easyFollow
//
//  Created by Qiu Han on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface registViewController : UIViewController <RenrenDelegate>

@property (retain, nonatomic) IBOutlet UITextField *nameText;

@property (retain, nonatomic) IBOutlet UITextField *IPText;


- (IBAction)renrenLogin:(id)sender;

- (IBAction)regist:(id)sender;

@end
