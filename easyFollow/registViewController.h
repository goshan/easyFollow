//
//  registViewController.h
//  easyFollow
//
//  Created by Qiu Han on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface registViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property(retain, nonatomic) UITextField *activeField;

@property(retain, nonatomic) NSMutableArray *allTextField;



- (IBAction)regist:(id)sender;

@end
