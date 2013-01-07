//
//  registViewController.m
//  easyFollow
//
//  Created by Qiu Han on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "registViewController.h"
#import "Util.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "UIDevice+IdentifierAddition.h"



BOOL waiting = YES;

@implementation registViewController

@synthesize navigationBar = _navigationBar;
@synthesize navigationTitle = _navigationTitle;
@synthesize registButton = _registButton;
@synthesize cancelButton = _cancelButton;
@synthesize renrenSwitch = _renrenSwitch;
@synthesize sinaSwitch = _sinaSwitch;
@synthesize tencentSwitch = _tencentSwitch;
@synthesize doubanSwitch = _doubanSwitch;
@synthesize update = _update;
@synthesize tips = _tips;
@synthesize sina = _sina;
@synthesize tencent = _tencent;
@synthesize douban = _douban;




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

- (void) stopRegist{
    if (!waiting){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [_tips hiddenRegistLoading];
        [_tips netErrorAlert];
    }
}

- (IBAction)regist:(id)sender {
    waiting = NO;
    [_tips showRegistLoadingWith:self.view];
    
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(stopRegist) userInfo:nil repeats:NO];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //push user regist data to server
    //make url request
    NSURL *url = [NSURL URLWithString:SERVER_URL];
    AFHTTPClient *httpClient = [[[AFHTTPClient alloc] initWithBaseURL:url]autorelease];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSString *default_info = @"0";
    NSString *signup_from = SIGNUP_FROM;
    NSArray *switchArray = [NSArray arrayWithObjects:_renrenSwitch, _sinaSwitch, _tencentSwitch, _doubanSwitch, nil];
    for (int i=0; i<switchArray.count; i++){
        UISwitch *s = [switchArray objectAtIndex:i];
        if (s.on){
            default_info = [NSString stringWithFormat:@"%d", i];
        }
    }
    NSString *using_sns = [NSString stringWithFormat:@"%d,%d,%d,%d", _renrenSwitch.on, _sinaSwitch.on, _tencentSwitch.on, _doubanSwitch.on];
    [defaults setObject:using_sns forKey:USING_SNS_KEY];
    NSString* imei = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    
    [params setObject:signup_from forKey:@"signup_from"];
    [params setObject:default_info forKey:@"default_info"];
    [params setObject:using_sns forKey:@"using_sns"];
    [params setObject:imei forKey:@"iphone_imei"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *renren_token = [defaults objectForKey:RENREN_TOKEN_KEY];
    NSString *renren_expire = [dateFormatter stringFromDate:[defaults objectForKey:RENREN_EXPIRE_KEY]];
    NSString *renren_permissions = [[defaults objectForKey:RENREN_PERMISSION_KEY] componentsJoinedByString:@","];
    if (_renrenSwitch.on && renren_token && renren_expire && renren_permissions){
        [params setObject:renren_token forKey:@"renren_token"];
        [params setObject:renren_expire forKey:@"renren_expire"];
        [params setObject:renren_permissions forKey:@"renren_permissions"];
    }
    
    NSString *sina_token = [defaults objectForKey:SINA_TOKEN_KEY];
    NSString *sina_expire = [defaults objectForKey:SINA_EXPIRE_KEY];
    NSString *sina_id = [defaults objectForKey:SINA_ID_KEY];
    if (_sinaSwitch.on && sina_id && sina_token && sina_expire){
        [params setObject:sina_id forKey:@"sina_id"];
        [params setObject:sina_token forKey:@"sina_token"];
        [params setObject:sina_expire forKey:@"sina_expire"];
    }
    //******** get tencent data
    NSString *tencent_token = [defaults objectForKey:TENCENT_TOKEN_KEY];
    NSString *tencent_expire = [defaults objectForKey:TENCENT_EXPIRE_KEY];
    NSString *tencent_openid = [defaults objectForKey:TENCENT_OPENID_KEY];
    if (_tencentSwitch.on && tencent_token && tencent_expire && tencent_openid){
        [params setObject:tencent_token forKey:@"tencent_token"];
        [params setObject:tencent_expire forKey:@"tencent_expire"];
        [params setObject:tencent_openid forKey:@"tencent_openid"];
    }
    //******** get douban data
    NSString *douban_token = [defaults objectForKey:DOUBAN_TOKEN_KEY];
    NSString *douban_expire = [defaults objectForKey:DOUBAN_EXPIRE_KEY];
    NSString *douban_id = [defaults objectForKey:DOUBAN_ID_KEY];
    if (_doubanSwitch.on && douban_id && douban_token && douban_expire){
        [params setObject:douban_id forKey:@"douban_id"];
        [params setObject:douban_token forKey:@"douban_token"];
        [params setObject:douban_expire forKey:@"douban_expire"];
    }
    //params for update
    if ([_update intValue]){
        [params setObject:[defaults objectForKey:TOKEN_KEY] forKey:@"token"];
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
        [defaults setObject:[feedback objectForKey:@"user_id"] forKey:USERID_KEY];
        [defaults setObject:[feedback objectForKey:@"token"] forKey:TOKEN_KEY];
        
        //dismiss regist view
        [self performSelector:@selector(hiddenRegistView) withObject:nil afterDelay:3.0];
        [_tips hiddenRegistLoading];
        waiting = YES;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [_tips hiddenRegistLoading];
        [_tips netErrorAlert];
        waiting = YES;
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    [operation start];
    
}

- (IBAction)cancel:(id)sender {
    if (waiting){
        [self hiddenRegistView];
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isUpdate:(BOOL)update
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _sina = [[WBEngine alloc] initWithAppKey:SINA_APPKEY appSecret:SINA_SECRETKEY];
        [_sina setRootViewController:self];
        [_sina setDelegate:self];
        [_sina setRedirectURI:REDIRECTURL];
        [_sina setIsUserExclusive:NO];
        
        _tencent = [[gTencentApi alloc] initWithAppKey:TENCENT_APPKEY andAppSecret:TENCENT_SECRETKEY andRedirectURL:REDIRECTURL];
        _tencent.delegate = self;
        
        _douban = [[gDoubanApi alloc] initWithAppKey:DOUBAN_APPKEY andAppSecret:DOUBAN_SECRETKEY andRedirectURL:REDIRECTURL];
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
    [_navigationBar release];
    [_registButton release];
    [_navigationTitle release];
    [_renrenSwitch release];
    [_sinaSwitch release];
    [_tencentSwitch release];
    [_doubanSwitch release];
    [_cancelButton release];
    [super dealloc];
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bg1"] forBarMetrics:UIBarMetricsDefault];
    _navigationTitle.title = @"绑定信息";
    _registButton.title = @"完成";
    [_registButton setBackgroundImage:[UIImage imageNamed:@"navigation_item_bg"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    _cancelButton.title = @"取消";
    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"navigation_item_bg"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *using_sns = [defaults objectForKey:USING_SNS_KEY];
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
}

- (void)viewDidUnload
{
    [self setNavigationBar:nil];
    [self setRegistButton:nil];
    [self setNavigationTitle:nil];
    [self setRenrenSwitch:nil];
    [self setSinaSwitch:nil];
    [self setTencentSwitch:nil];
    [self setDoubanSwitch:nil];
    [self setCancelButton:nil];
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
    [defaults setObject:renren.accessToken forKey:RENREN_TOKEN_KEY];
    [defaults setObject:renren.expirationDate forKey:RENREN_EXPIRE_KEY];
    [defaults setObject:renren.permissions forKey:RENREN_PERMISSION_KEY];
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

- (void)renrenCloseWeb{
    NSLog(@"========renren login closed=======");
    _renrenSwitch.on = NO;
}




#pragma mark - WBEngineDelegate Methods

- (void)engineDidLogIn:(WBEngine *)engine
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:engine.accessToken forKey:SINA_TOKEN_KEY];
    NSString *expireeIn = [NSString stringWithFormat:@"%f", engine.expireTime];
    [defaults setObject:expireeIn forKey:SINA_EXPIRE_KEY];
    [defaults setObject:engine.userID forKey:SINA_ID_KEY];
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

- (void)engineCloseWeb{
    NSLog(@"========sina login closed=======");
    _sinaSwitch.on = NO;
}




#pragma mark gTencent delegate

- (void) loginSucess:(gTencentApi *)tencentApi{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:tencentApi.tencent.accessToken forKey:TENCENT_TOKEN_KEY];
    [defaults setObject:tencentApi.tencent.expireIn forKey:TENCENT_EXPIRE_KEY];
    [defaults setObject:tencentApi.tencent.openid forKey:TENCENT_OPENID_KEY];
}

- (void) responseDidFinishLoad:(UIWebView *)webView{
    NSLog(@"========tencent load view finished=======");
}

- (void) responseWebView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"========tencent load view failed=======");
}

- (void)tencentCloseWeb{
    NSLog(@"========tencent login closed=======");
    _tencentSwitch.on = NO;
}



#pragma mark gDouban delegate

- (void)gDoubanDidLoginSuccess:(gDoubanApi *)douban{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:douban.accessToken forKey:DOUBAN_TOKEN_KEY];
    [defaults setObject:douban.expiresIn forKey:DOUBAN_EXPIRE_KEY];
    [defaults setObject:douban.userId forKey:DOUBAN_ID_KEY];
}

- (void)gDouban:(gDoubanApi *)douban didLoginFailWithError:(NSError *)error{
    NSLog(@"========douban login failed=======");
}

- (void)gDoubanCloseWeb{
    NSLog(@"========douban login closed=======");
    _doubanSwitch.on = NO;
}




@end
