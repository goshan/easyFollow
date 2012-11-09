//
//  gDoubanApi.m
//  easyFollow
//
//  Created by Qiu Han on 10/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "gDoubanApi.h"
#import "NSString+ParseCategory.h"


#define doubanUserId @"douban_userid"
#define doubanAccessToken @"tencent_accessToken"
#define doubanRefreshToken @"tencent_refreshToken"
#define doubanExpireIn @"tencent_expireIn"
#define doubanExpireAt @"tencent_expireAt"


@implementation gDoubanApi

@synthesize appKey = _appKey;
@synthesize secretKey = _secretKey;
@synthesize redirectURL = _redirectURL;
@synthesize accessToken = _accessToken;
@synthesize expiresIn = _expiresIn;
@synthesize userId = _userId;
@synthesize refreshToken  =_refreshToken;
@synthesize doubanLoginView = _doubanLoginView;
@synthesize expireAt = _expireAt;
@synthesize delegate = _delegate;




- (void)closeWebView{
    [_doubanLoginView removeFromSuperview];
    [_delegate gDoubanCloseWeb];
}

- (void) readUserInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _userId = [defaults objectForKey:doubanUserId];
    _accessToken = [defaults objectForKey:doubanAccessToken];
    _expiresIn = [defaults objectForKey:doubanExpireIn];
    _refreshToken = [defaults objectForKey:doubanRefreshToken];
    _expireAt = [defaults objectForKey:doubanExpireAt];
}

- (void) writeUserInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_userId forKey:doubanUserId];
    [defaults setObject:_accessToken forKey:doubanAccessToken];
    [defaults setObject:_expiresIn forKey:doubanExpireIn];
    [defaults setObject:_refreshToken forKey:doubanRefreshToken];
    [defaults setObject:_expireAt forKey:doubanExpireAt];
}



- (gDoubanApi *)initWithAppKey:(NSString *)appKey andAppSecret:(NSString *)appSecret andRedirectURL:(NSString *)url{
    self = [super init];
    if(self){
        _appKey = appKey;
        _secretKey = appSecret;
        _redirectURL = url;
        [self readUserInfo];
    }
    return self;
}



- (void)LoginWithView:(UIView *)view andPermission:(NSString *)permission{
    _doubanLoginView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 436)];
    _doubanLoginView.scalesPageToFit = YES;
    _doubanLoginView.userInteractionEnabled = YES;
    _doubanLoginView.delegate = self;
    _doubanLoginView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    NSString *str = [NSString stringWithFormat:@"https://www.douban.com/service/auth2/auth?client_id=%@&redirect_uri=%@&response_type=code&scope=%@", _appKey, _redirectURL, permission];
    
    NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_doubanLoginView loadRequest:request];
    [view addSubview:_doubanLoginView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(300, 5, 15, 15)];
    [button setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeWebView) forControlEvents:UIControlEventTouchUpInside];
    [_doubanLoginView addSubview:button];
}

- (void)Logout{
    _accessToken = nil;
    _expiresIn = nil;
    _userId = nil;
    _refreshToken = nil;
    _expireAt = nil;
    [self writeUserInfo];
}

- (BOOL)isLogin{
    return _accessToken && _expiresIn && _userId && _refreshToken;
}

- (BOOL)isExpired{
    if ([_expireAt compare:[NSDate date]] == NSOrderedAscending){
        //force log out
        [self Logout];
        return YES;
    }
    return NO;
}

- (void)dealloc{
    [_appKey release];
    [_secretKey release];
    [_redirectURL release];
    [_accessToken release];
    [_expiresIn release];
    [_userId release];
    [_refreshToken release];
    [_doubanLoginView release];
    [_expireAt release];
    [super dealloc];
}




#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *urlObj =  [request URL];
    NSString *url = [urlObj absoluteString];
    NSLog(@"======response url: %@", url);
    
    
    if ([url hasPrefix:_redirectURL]) {
        
        NSString* query = [urlObj query];
        NSMutableDictionary *parsedQuery = [query explodeToDictionaryInnerGlue:@"=" 
                                                                    outterGlue:@"&"];
        
        NSString *code = [parsedQuery objectForKey:@"code"];
        DOUOAuthService *service = [DOUOAuthService sharedInstance];
        service.authorizationURL = kTokenUrl;
        service.delegate = self;
        service.clientId = _appKey;
        service.clientSecret = _secretKey;
        service.callbackURL = _redirectURL;
        service.authorizationCode = code;
        
        [service validateAuthorizationCode];
        
        return NO;
    }
    
    return YES;
}



#pragma mark - DoubanOAuthDelegate

- (void)OAuthClient:(DOUOAuthService *)client didAcquireSuccessDictionary:(NSDictionary *)dic {
    NSLog(@"douban login success!");
    _accessToken = [dic objectForKey:@"access_token"];
    _expiresIn = [dic objectForKey:@"expires_in"];
    _userId = [dic objectForKey:@"douban_user_id"];
    _refreshToken = [dic objectForKey:@"refresh_token"];
    _expireAt = [NSDate dateWithTimeIntervalSinceNow:[_expiresIn doubleValue]];
    [_doubanLoginView removeFromSuperview];
    
    [self writeUserInfo];
    [self.delegate gDoubanDidLoginSuccess:self];
}

- (void)OAuthClient:(DOUOAuthService *)client didFailWithError:(NSError *)error {
    NSLog(@"douban login error: %@", error);
    [self.delegate gDouban:self didLoginFailWithError:error];
}


@end
