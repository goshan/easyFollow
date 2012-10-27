//
//  foundPersonViewController.m
//  easyFollow
//
//  Created by Qiu Han on 10/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "foundPersonViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"



@implementation foundPersonViewController


@synthesize avatar = _avatar;
@synthesize name = _name;
@synthesize infoTable = _infoTable;
@synthesize user_id = _user_id;
@synthesize user_name = _user_name;
@synthesize avatar_url = _avatar_url;
@synthesize friendData = _friendData;






//nav bar button function
- (void)cancel {
    NSLog(@"cancel clicked!");
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    
    [self.view removeFromSuperview];
    [self release];
    
}

- (void)follow {
    NSLog(@"follow clicked!");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *server_ip = [defaults objectForKey:@"server_ip"];
    NSString *url_str = [NSString stringWithFormat:@"http://%@", server_ip];
    NSURL *url = [NSURL URLWithString:url_str];
    AFHTTPClient *httpClient = [[[AFHTTPClient alloc] initWithBaseURL:url]autorelease];
    
    NSString *token = [defaults objectForKey:@"gsf_token"];
    NSString *followed_id = _user_id;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            token, @"token", 
                            followed_id, @"followed_id",
                            nil];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"/follow.json" parameters:params];
    
    //put request
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //get respond json from server
        NSDictionary *feedback = [[NSDictionary alloc] initWithDictionary:JSON];
        NSString *result = [feedback objectForKey:@"result"];
        
        if ([result isEqualToString:@"sucess"]){
            NSLog(@"follow sucess!!");
            [self cancel];
            
        }
        else {
            NSLog(@"follow failed");
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    [operation start];
}






- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(NSDictionary *)data
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSMutableArray *dict = [[NSMutableArray alloc] init];
        for (id key in data){
            if ([key isEqualToString:@"id"]){
                _user_id = [data objectForKey:key];
            }
            else if ([key isEqualToString:@"name"]){
                _user_name = [data objectForKey:key];
            }
            else if ([key isEqualToString:@"avatar"]){
                _avatar_url = [data objectForKey:key];
            }
            else {
                NSDictionary *sns = [NSDictionary dictionaryWithObjectsAndKeys:key, @"sns_name", [data objectForKey:key], @"sns_user_name", nil];
                [dict addObject:sns];
            }
        }
        _friendData = dict;
        [dict release];
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
//    NSURL *url = [NSURL URLWithString:[_friendData objectForKey:@"avatar"]];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    UIImage *image = [UIImage imageWithData:data];
//    _avatar.image = image;
//    _name.text = [_friendData objectForKey:@"name"];
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
    return _friendData.count;
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
//    UIImageView *snsAvatar = (UIImageView *)[cell viewWithTag:1];
//    UILabel *snsName = (UILabel *)[cell viewWithTag:2];
//    
//    if (indexPath.section == 0){
//        NSURL *url = [NSURL URLWithString:[_friendData objectForKey:@"avatar"]];
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        UIImage *image = [UIImage imageWithData:data];
//        snsAvatar.image = image;
//        snsName.text = [_friendData objectForKey:@"renren_name"];
//    }
//    else {
//        snsAvatar.image = [UIImage imageNamed:[_friendData objectForKey:@"sina_avatar"]];
//        snsName.text = [_friendData objectForKey:@"sina_name"];
//    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}



@end
