//
//  foundPersonViewController.h
//  easyFollow
//
//  Created by Qiu Han on 10/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface foundPersonViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UIImageView *avatar;

@property (retain, nonatomic) IBOutlet UILabel *name;

@property (retain, nonatomic) IBOutlet UITableView *infoTable;

@property(retain, nonatomic) NSString *user_id;

@property(retain, nonatomic) NSString *user_name;

@property(retain, nonatomic) NSString *avatar_url;

@property(retain, nonatomic) NSArray *friendData;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(NSDictionary *)data;

@end
