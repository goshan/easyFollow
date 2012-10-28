//
//  foundPersonViewController.m
//  easyFollow
//
//  Created by Qiu Han on 10/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "foundPersonViewController.h"
#import "gAnimation.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"



@implementation foundPersonViewController


@synthesize renrenLabel = _renrenLabel;
@synthesize sinaLabel = _sinaLabel;
@synthesize tencentLabel = _tencentLabel;
@synthesize doubanLabel = _doubanLabel;
@synthesize avatarView = _avatarView;
@synthesize user_id = _user_id;
@synthesize user_name = _user_name;
@synthesize avatar_url = _avatar_url;
@synthesize friendData = _friendData;





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
        _user_id = [data objectForKey:@"id"];
        _user_name = [data objectForKey:@"name"];
        _avatar_url = [data objectForKey:@"avatar"];
        _friendData = data;
        
        CGFloat rotation = (45.0 * M_PI) / 180.0;
        CGAffineTransform transform = CGAffineTransformMakeRotation(rotation);
        _avatarView.transform = transform;
        _avatarView.alpha = 1.0;
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
    self.title = _user_name;
    NSLog(@"======%@", _avatar_url);
    NSURL *url = [NSURL URLWithString:_avatar_url];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    _avatarView.image = image;
    
    
    if ([_friendData objectForKey:@"renren"]){
        _renrenLabel.text = [_friendData objectForKey:@"renren"];
    }
    else {
        _renrenLabel.text = @"";
    }
    if ([_friendData objectForKey:@"sina"]){
        _sinaLabel.text = [_friendData objectForKey:@"sina"];
    }
    else {
        _sinaLabel.text = @"";
    }
    if ([_friendData objectForKey:@"tencent"]){
        _tencentLabel.text = [_friendData objectForKey:@"tencent"];
    }
    else {
        _tencentLabel.text = @"";
    }
    if ([_friendData objectForKey:@"douban"]){
        _doubanLabel.text = [_friendData objectForKey:@"douban"];
    }
    else {
        _doubanLabel.text = @"";
    }
    _renrenLabel.textColor = [UIColor colorWithRed:248.0/255.0 green:255.0/255.0 blue:175.0/255.0 alpha:1.0];
    _sinaLabel.textColor = [UIColor colorWithRed:248.0/255.0 green:255.0/255.0 blue:175.0/255.0 alpha:1.0];
    _tencentLabel.textColor = [UIColor colorWithRed:248.0/255.0 green:255.0/255.0 blue:175.0/255.0 alpha:1.0];
    _doubanLabel.textColor = [UIColor colorWithRed:248.0/255.0 green:255.0/255.0 blue:175.0/255.0 alpha:1.0];
    
}

- (void)viewDidUnload
{
    [self setRenrenLabel:nil];
    [self setSinaLabel:nil];
    [self setTencentLabel:nil];
    [self setDoubanLabel:nil];
    [self setAvatarView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [_friendData release];
    [_renrenLabel release];
    [_sinaLabel release];
    [_tencentLabel release];
    [_doubanLabel release];
    [_avatarView release];
    [super dealloc];
}


@end
