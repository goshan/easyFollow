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
#import "Renren.h"
#import "UIDevice+IdentifierAddition.h"




#define SinaAPPKey @"1799175553"
#define SinaScretKey @"4c2180d2a60b0fa917960e5b7f824a04"

#define TencentAPPKey @"801255147"
#define TencentScretKey @"875d58fb566cb9e9183830dde6515fbc"


@implementation registViewController

@synthesize sina = _sina;
@synthesize tencent = _tencent;
@synthesize IPText = _IPText;





- (IBAction)renrenLogin:(id)sender {
    NSArray *permission = [NSArray arrayWithObjects:@"send_message", @"send_notification", @"publish_feed", @"read_user_status", @"publish_comment", @"status_update", nil];
    [[Renren sharedRenren] authorizationWithPermisson:permission andDelegate:self];
}

- (IBAction)sinaLogin:(id)sender {
    [_sina logIn];
}

- (IBAction)tencentLogin:(id)sender {
    [_tencent LoginWith:self.view];
}

- (IBAction)regist:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *server_ip = _IPText.text;
    [defaults setObject:server_ip forKey:@"server_ip"];
    
    //push user regist data to server
    //**** prepair for user data
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //******** get renren data
    NSString *renren_token = [defaults objectForKey:@"gsf_renren_token"];
    NSString *renren_expir = [dateFormatter stringFromDate:[defaults objectForKey:@"gsf_renren_expir"]];
    NSString *renren_permissions = [[[NSString alloc] init] autorelease];
    for (NSString *permission in [defaults objectForKey:@"gsf_renren_permissions"]){
        renren_permissions = [renren_permissions stringByAppendingFormat:@"%@,", permission];
    }
    renren_permissions = [renren_permissions substringToIndex:renren_permissions.length-1];
    //******** get sina data
    NSString *sina_token = [defaults objectForKey:@"gsf_sina_token"];
    NSString *sina_expir = [defaults objectForKey:@"gsf_sina_expir"];
    NSString *sina_id = [defaults objectForKey:@"gsf_sina_id"];
    //******** get iphone imei
    NSString* imei = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    
    //make url request
    NSString *url_str = [NSString stringWithFormat:@"http://%@", server_ip];
    NSURL *url = [NSURL URLWithString:url_str];
    AFHTTPClient *httpClient = [[[AFHTTPClient alloc] initWithBaseURL:url]autorelease];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            renren_token, @"renren_token",
                            renren_expir, @"renren_expir",
                            renren_permissions, @"renren_permissions", 
                            sina_id, @"sina_id", 
                            sina_token, @"sina_token", 
                            sina_expir, @"sina_expir", 
                            imei, @"iphone_imei", 
                            nil];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"/users/create_user.json" parameters:params];
    
    //put request
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //get respond json from server
        NSDictionary *feedback = [[NSDictionary alloc] initWithDictionary:JSON];
        NSString *result = [feedback objectForKey:@"result"];
        
        if ([result isEqualToString:@"sucess"]){
            NSLog(@"regist sucess!!");
            
        }
        else {
            NSLog(@"this iphone has registed!!");
        }
        [defaults setObject:[feedback objectForKey:@"user_id"] forKey:@"gsf_user_id"];
        [defaults setObject:[feedback objectForKey:@"token"] forKey:@"gsf_token"];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        //dismiss regist view
        [self dismissModalViewControllerAnimated:YES];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    [operation start];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _sina = [[WBEngine alloc] initWithAppKey:SinaAPPKey appSecret:SinaScretKey];
        [_sina setRootViewController:self];
        [_sina setDelegate:self];
        [_sina setRedirectURI:@"http://"];
        [_sina setIsUserExclusive:NO];
        
        _tencent = [[gTencentApi alloc] initWithAppKey:TencentAPPKey andAppScret:TencentScretKey];
        _tencent.delegate = self;
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
    [_IPText release];
    [super dealloc];
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setIPText:nil];
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
    [defaults setObject:renren.expirationDate forKey:@"gsf_renren_expir"];
    [defaults setObject:renren.permissions forKey:@"gsf_renren_permissions"];
    
    [[Renren sharedRenren] logout:self];
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
    NSString *expireIn = [NSString stringWithFormat:@"%f", engine.expireTime];
    [defaults setObject:expireIn forKey:@"gsf_sina_expir"];
    [defaults setObject:engine.userID forKey:@"gsf_sina_id"];
    
    [engine logOut];
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

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    NSLog(@"========sina Authorize Expired=======%@", engine);
    [engine logOut];
    [engine logIn];
}




#pragma mark gTencent delegate

- (void) loginSucess:(gTencentApi *)tencentApi{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:tencentApi.tencent.accessToken forKey:@"gsf_tencent_token"];
    [defaults setObject:tencentApi.tencent.expireIn forKey:@"gsf_tencent_expir"];
    [defaults setObject:tencentApi.tencent.openid forKey:@"gsf_tencent_openid"];
    [defaults setObject:tencentApi.tencent.openkey forKey:@"gsf_tencent_openkey"];
}

- (void) responseDidFinishLoad:(UIWebView *)webView{
    NSLog(@"========tencent load view finished=======");
}

- (void) responseWebView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"========tencent load view failed=======");
}



@end
