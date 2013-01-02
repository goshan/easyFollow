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
@synthesize avatarFrameShining = _avatarFrameShining;
@synthesize user_id = _user_id;
@synthesize friendData = _friendData;
@synthesize tips = _tips;





- (void) avatarFrameBlink{
    [gAnimation makeView:_avatarFrameShining blinkWithDuration:0.5];
}

- (void)cancel{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)follow {
    [_tips showFollowLoadingWith:self.view];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url = [NSURL URLWithString:SERVER_URL];
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
            NSArray *list = [feedback objectForKey:@"list"];
            [_tips showFollowFinishedWith:self.view andList:list];
            [self performSelector:@selector(cancel) withObject:nil afterDelay:3.0];
        }
        else {
            [_tips alreadyFriendAlert];
        }
        [_tips hiddenFollowLoading];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [_tips netErrorAlert];
        
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
        _friendData = data;
        _tips = [[tipsAlert alloc] initWith:self.view];
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
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bg2"] forBarMetrics:UIBarMetricsDefault];
    self.title = [_friendData objectForKey:@"name"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    [self.navigationItem.leftBarButtonItem setBackgroundImage:[UIImage imageNamed:@"navigation_item_bg"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(237, 242, 56, 56)];
    NSURL *url = [NSURL URLWithString:[_friendData objectForKey:@"avatar"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    avatar.image = image;
    CGFloat rotation = (-45.0 * M_PI) / 180.0;
    CGAffineTransform transform = CGAffineTransformMakeRotation(rotation);
    avatar.transform = transform;
    CALayer *layer = avatar.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 13.0;
    [self.view addSubview:avatar];
    [avatar release];
    
    UIImageView *chain = [[UIImageView alloc] initWithFrame:CGRectMake(261, 74, 9, 167)];
    chain.image = [UIImage imageNamed:@"chain"];
    [self.view addSubview:chain];
    [chain release];
    
    UIImageView *avatarFrame = [[UIImageView alloc] initWithFrame:CGRectMake(194, 202, 126, 140)];
    avatarFrame.image = [UIImage imageNamed:@"avatar_frame"];
    [self.view addSubview:avatarFrame];
    [avatarFrame release];
    
    _avatarFrameShining = [[UIImageView alloc] initWithFrame:CGRectMake(194, 202, 126, 140)];
    _avatarFrameShining.image = [UIImage imageNamed:@"avatar_frame_shining"];
    _avatarFrameShining.alpha = 0.0;
    [self.view addSubview:_avatarFrameShining];
    [_avatarFrameShining release];
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(avatarFrameBlink) userInfo:nil repeats:YES];
    
    
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
    
    UIButton *followButton = [[UIButton alloc] initWithFrame:CGRectMake(228, 223, 72, 128)];
    [followButton addTarget:self action:@selector(follow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:followButton];
    
}

- (void)viewDidUnload
{
    [self setRenrenLabel:nil];
    [self setSinaLabel:nil];
    [self setTencentLabel:nil];
    [self setDoubanLabel:nil];
    [self setAvatarFrameShining:nil];
    [self setUser_id:nil];
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
    [_avatarFrameShining release];
    [_user_id release];
    [super dealloc];
}


@end
