//
//  foundPersonViewController.m
//  easyFollow
//
//  Created by Qiu Han on 10/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "foundPersonViewController.h"

@implementation foundPersonViewController


@synthesize avatar = _avatar;
@synthesize name = _name;
@synthesize infoTable = _infoTable;
@synthesize friendData = _friendData;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil friendData:(NSDictionary *)data
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _friendData = data;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _infoTable.allowsSelection = NO;
    NSURL *url = [NSURL URLWithString:[_friendData objectForKey:@"avatar"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    _avatar.image = image;
    _name.text = [_friendData objectForKey:@"name"];
}

- (void)viewDidUnload
{
    [self setAvatar:nil];
    [self setName:nil];
    [self setInfoTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [_avatar release];
    [_name release];
    [_infoTable release];
    [_friendData release];
    [super dealloc];
}

#pragma mark - Table View data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"人人";
            break;
        case 1:
            return @"新浪";
            break;
        default:
            return @"";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"personCell_id";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* objects =  [[NSBundle  mainBundle] loadNibNamed:@"personCell" owner:nil options:nil];
        cell = [objects objectAtIndex:0];
    }
    
    // Set up the cell...
    UIImageView *snsAvatar = (UIImageView *)[cell viewWithTag:1];
    UILabel *snsName = (UILabel *)[cell viewWithTag:2];
    
    if (indexPath.section == 0){
        NSURL *url = [NSURL URLWithString:[_friendData objectForKey:@"avatar"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        snsAvatar.image = image;
        snsName.text = [_friendData objectForKey:@"renren_name"];
    }
    else {
        snsAvatar.image = [UIImage imageNamed:[_friendData objectForKey:@"sina_avatar"]];
        snsName.text = [_friendData objectForKey:@"sina_name"];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}



@end
