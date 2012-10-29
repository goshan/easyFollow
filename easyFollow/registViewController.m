//
//  registViewController.m
//  easyFollow
//
//  Created by Qiu Han on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "registViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "UIDevice+IdentifierAddition.h"




#define SinaAPPKey @"1799175553"
#define SinaSecretKey @"4c2180d2a60b0fa917960e5b7f824a04"

#define TencentAPPKey @"801255147"
#define TencentSecretKey @"875d58fb566cb9e9183830dde6515fbc"

#define DoubanAppKey @"0c342ae9640503b8249c80bc2c0f0b28"
#define DoubanSecretKey @"f3e0862f5378b28c"
#define DoubanRedirectURL @"http://www.easyfollow.com"





@implementation registViewController

@synthesize navigationBar = _navigationBar;
@synthesize navigationTitle = _navigationTitle;
@synthesize registButton = _registButton;
@synthesize renrenSwitch = _renrenSwitch;
@synthesize sinaSwitch = _sinaSwitch;
@synthesize tencentSwitch = _tencentSwitch;
@synthesize doubanSwitch = _doubanSwitch;
@synthesize update = _update;
@synthesize tips = _tips;
@synthesize sina = _sina;
@synthesize tencent = _tencent;
@synthesize douban = _douban;
@synthesize IPText = _IPText;




- (IBAction)renrenLogin:(id)sender {
    UISwitch *button = sender;
    if (button.on){
        NSArray *permission = [NSArray arrayWithObjects:@"send_message", @"send_notification", @"publish_feed", @"read_user_status", @"publish_comment", @"status_update", nil];
        [[Renren sharedRenren] authorizationWithPermisson:permission andDelegate:self];
    }
    else {
        [[Renren sharedRenren] logout:self];
    }
}

- (IBAction)sinaLogin:(id)sender {
    UISwitch *button = sender;
    if (button.on){
        [_sina logIn];
    }
    else {
        [_sina logOut];
    }
}

- (IBAction)tencentLogin:(id)sender {
    UISwitch *button = sender;
    if (button.on){
        [_tencent LoginWith:self.view];
    }
    else {
        [_tencent LogOut];
    }
}

- (IBAction)doubanLogin:(id)sender {
    UISwitch *button = sender;
    if (button.on){
        NSString *permission = @"shuo_basic_r,shuo_basic_w,community_advanced_doumail_r,community_advanced_doumail_w,douban_basic_common";
        [_douban LoginWithView:self.view andPermission:permission];
    }
    else {
        [_douban Logout];
    }
}

- (void)hiddenRegistView{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)regist:(id)sender {
    [_tips showRegistLoadingWith:self.view];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *server_ip = _IPText.text;
    [defaults setObject:server_ip forKey:@"server_ip"];
    
    //push user regist data to server
    //make url request
    NSString *url_str = [NSString stringWithFormat:@"http://%@", @"localhost:3000"];
    NSURL *url = [NSURL URLWithString:url_str];
    AFHTTPClient *httpClient = [[[AFHTTPClient alloc] initWithBaseURL:url]autorelease];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSString *default_info = @"0";
    NSString *using_sns = [NSString stringWithFormat:@"%d,%d,%d,%d", _renrenSwitch.on, _sinaSwitch.on, _tencentSwitch.on, _doubanSwitch.on];
    [defaults setObject:using_sns forKey:@"gsf_using_sns"];
    NSString* imei = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    
    [params setObject:default_info forKey:@"default_info"];
    [params setObject:using_sns forKey:@"using_sns"];
    [params setObject:imei forKey:@"iphone_imei"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *renren_token = [defaults objectForKey:@"gsf_renren_token"];
    NSString *renren_expire = [dateFormatter stringFromDate:[defaults objectForKey:@"gsf_renren_expire"]];
    NSString *renren_permissions = [[defaults objectForKey:@"gsf_renren_permissions"] componentsJoinedByString:@","];
    if (_renrenSwitch.on && renren_token && renren_expire && renren_permissions){
        [params setObject:renren_token forKey:@"renren_token"];
        [params setObject:renren_expire forKey:@"renren_expire"];
        [params setObject:renren_permissions forKey:@"renren_permissions"];
    }
    
    NSString *sina_token = [defaults objectForKey:@"gsf_sina_token"];
    NSString *sina_expire = [defaults objectForKey:@"gsf_sina_expire"];
    NSString *sina_id = [defaults objectForKey:@"gsf_sina_id"];
    if (_sinaSwitch.on && sina_id && sina_token && sina_expire){
        [params setObject:sina_id forKey:@"sina_id"];
        [params setObject:sina_token forKey:@"sina_token"];
        [params setObject:sina_expire forKey:@"sina_expire"];
    }
    //******** get tencent data
    NSString *tencent_token = [defaults objectForKey:@"gsf_tencent_token"];
    NSString *tencent_expire = [defaults objectForKey:@"gsf_tencent_expire"];
    NSString *tencent_openid = [defaults objectForKey:@"gsf_tencent_openid"];
    if (_tencentSwitch.on && tencent_token && tencent_expire && tencent_openid){
        [params setObject:tencent_token forKey:@"tencent_token"];
        [params setObject:tencent_expire forKey:@"tencent_expire"];
        [params setObject:tencent_openid forKey:@"tencent_openid"];
    }
    //******** get douban data
    NSString *douban_token = [defaults objectForKey:@"gsf_douban_token"];
    NSString *douban_expire = [defaults objectForKey:@"gsf_douban_expire"];
    NSString *douban_id = [defaults objectForKey:@"gsf_douban_id"];
    if (_doubanSwitch.on && douban_id && douban_token && douban_expire){
        [params setObject:douban_id forKey:@"douban_id"];
        [params setObject:douban_token forKey:@"douban_token"];
        [params setObject:douban_expire forKey:@"douban_expire"];
    }
    //params for update
    if ([_update intValue]){
        [params setObject:[defaults objectForKey:@"gsf_token"] forKey:@"token"];
    }
    NSString *path = [_update intValue] ? @"/update_user.json" : @"/create_user.json";
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:params];
    
    //put request
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //get respond json from server
        NSDictionary *feedback = [[NSDictionary alloc] initWithDictionary:JSON];
        NSString *result = [feedback objectForKey:@"result"];
        
        if ([result isEqualToString:@"sucess"]){
            NSArray *list = [feedback objectForKey:@"list"];
            [_tips showRegistFinishedWith:self.view andList:list];
        }
        else {
            NSLog(@"user error!!");
        }
        [defaults setObject:[feedback objectForKey:@"user_id"] forKey:@"gsf_user_id"];
        [defaults setObject:[feedback objectForKey:@"token"] forKey:@"gsf_token"];
        
        //dismiss regist view
        [self performSelector:@selector(hiddenRegistView) withObject:nil afterDelay:3.0];
        [_tips hiddenRegistLoading];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [_tips hiddenRegistLoading];
        [_tips netErrorAlert];
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    [operation start];
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isUpdate:(BOOL)update
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _sina = [[WBEngine alloc] initWithAppKey:SinaAPPKey appSecret:SinaSecretKey];
        [_sina setRootViewController:self];
        [_sina setDelegate:self];
        [_sina setRedirectURI:@"http://"];
        [_sina setIsUserExclusive:NO];
        
        _tencent = [[gTencentApi alloc] initWithAppKey:TencentAPPKey andAppSecret:TencentSecretKey];
        _tencent.delegate = self;
        
        _douban = [[gDoubanApi alloc] initWithAppKey:DoubanAppKey andAppSecret:DoubanSecretKey andRedirectURL:DoubanRedirectURL];
        _douban.delegate = self;
        
        _update = [NSNumber numberWithInt:update];
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

- (void)dealloc {
    [_tencent release];
    [_sina release];
    [_douban release];
    [_IPText release];
    [_navigationBar release];
    [_registButton release];
    [_navigationTitle release];
    [_renrenSwitch release];
    [_sinaSwitch release];
    [_tencentSwitch release];
    [_doubanSwitch release];
    [super dealloc];
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bg"] forBarMetrics:UIBarMetricsDefault];
    _navigationTitle.title = @"绑定信息";
    _registButton.title = @"完成";
    [_registButton setBackgroundImage:[UIImage imageNamed:@"navigation_item_bg"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *using_sns = [defaults objectForKey:@"gsf_using_sns"];
    if (!using_sns){
        using_sns = @"0,0,0,0";
    }
    NSArray *status = [using_sns componentsSeparatedByString:@","];
    NSArray *expired = [NSArray arrayWithObjects:[NSNumber numberWithInt:[[Renren sharedRenren] isSessionValid]], [NSNumber numberWithInt:[_sina isLoggedIn] && ![_sina isAuthorizeExpired]], [NSNumber numberWithInt:[_tencent isLogin] && ![_tencent isExpired]], [NSNumber numberWithInt:[_douban isLogin] && ![_douban isExpired]], nil];
    NSArray *switchArray = [NSArray arrayWithObjects:_renrenSwitch, _sinaSwitch, _tencentSwitch, _doubanSwitch, nil];
    for (int i=0; i<status.count; i++){
        int num = [[status objectAtIndex:i] intValue]*[[expired objectAtIndex:i] intValue];
        UISwitch *temp_switch = [switchArray objectAtIndex:i];
        temp_switch.on = num;
    }
    
    _IPText.text = [defaults objectForKey:@"server_ip"];
}

- (void)viewDidUnload
{
    [self setIPText:nil];
    [self setNavigationBar:nil];
    [self setRegistButton:nil];
    [self setNavigationTitle:nil];
    [self setRenrenSwitch:nil];
    [self setSinaSwitch:nil];
    [self setTencentSwitch:nil];
    [self setDoubanSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - renren delegate

/**
 * 授权登录成功时被调用，第三方开发者实现这个方法
 * @param renren 传回代理授权登录接口请求的Renren类型对象。
 */
- (void)renrenDidLogin:(Renren *)renren
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:renren.accessToken forKey:@"gsf_renren_token"];
    [defaults setObject:renren.expirationDate forKey:@"gsf_renren_expire"];
    [defaults setObject:renren.permissions forKey:@"gsf_renren_permissions"];
}

/**
 * 用户登出成功后被调用 第三方开发者实现这个方法
 * @param renren 传回代理登出接口请求的Renren类型对象。
 */
- (void)renrenDidLogout:(Renren *)renren
{
    NSLog(@"======== renren log out======%@", renren);
}

/**
 * 授权登录失败时被调用，第三方开发者实现这个方法
 * @param renren 传回代理授权登录接口请求的Renren类型对象。
 */
- (void)renren:(Renren *)renren loginFailWithError:(ROError*)error
{
    NSLog(@"======== renren login failed======%@", renren);
    NSLog(@"========%@", error);
}




#pragma mark - WBEngineDelegate Methods

- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    if ([engine isUserExclusive])
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
                                                           message:@"请先登出！" 
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定" 
                                                 otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (void)engineDidLogIn:(WBEngine *)engine
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:engine.accessToken forKey:@"gsf_sina_token"];
    NSString *expireeIn = [NSString stringWithFormat:@"%f", engine.expireTime];
    [defaults setObject:expireeIn forKey:@"gsf_sina_expire"];
    [defaults setObject:engine.userID forKey:@"gsf_sina_id"];
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    NSLog(@"========sina login failed=====%@", error);
}

- (void)engineDidLogOut:(WBEngine *)engine
{
    NSLog(@"========sina log out ======%@", engine);
}

- (void)engineNotAuthorized:(WBEngine *)engine
{
    NSLog(@"========sina not Authorized=======%@", engine);
}

- (void)engineAuthorizeexpireed:(WBEngine *)engine
{
    NSLog(@"========sina Authorize expireed=======%@", engine);
    [engine logOut];
    [engine logIn];
}




#pragma mark gTencent delegate

- (void) loginSucess:(gTencentApi *)tencentApi{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:tencentApi.tencent.accessToken forKey:@"gsf_tencent_token"];
    [defaults setObject:tencentApi.tencent.expireIn forKey:@"gsf_tencent_expire"];
    [defaults setObject:tencentApi.tencent.openid forKey:@"gsf_tencent_openid"];
}

- (void) responseDidFinishLoad:(UIWebView *)webView{
    NSLog(@"========tencent load view finished=======");
}

- (void) responseWebView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"========tencent load view failed=======");
}



#pragma mark gDouban delegate

- (void)gDoubanDidLoginSuccess:(gDoubanApi *)douban{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:douban.accessToken forKey:@"gsf_douban_token"];
    [defaults setObject:douban.expiresIn forKey:@"gsf_douban_expire"];
    [defaults setObject:douban.userId forKey:@"gsf_douban_id"];
}

- (void)gDouban:(gDoubanApi *)douban didLoginFailWithError:(NSError *)error{
    NSLog(@"========douban login failed=======");
}






@end
