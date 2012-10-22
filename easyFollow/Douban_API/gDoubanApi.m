//
//  gDoubanApi.m
//  easyFollow
//
//  Created by Qiu Han on 10/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "gDoubanApi.h"
#import "NSString+ParseCategory.h"

@implementation gDoubanApi

@synthesize appKey = _appKey;
@synthesize secretKey = _secretKey;
@synthesize redirectURL = _redirectURL;
@synthesize accessToken = _accessToken;
@synthesize expiresIn = _expiresIn;
@synthesize userId = _userId;
@synthesize refreshToken  =_refreshToken;
@synthesize doubanLoginView = _doubanLoginView;
@synthesize delegate = _delegate;



- (gDoubanApi *)initWithAppKey:(NSString *)appKey andAppSecret:(NSString *)appSecret andRedirectURL:(NSString *)url{
    self = [super init];
    if(self){
        _appKey = appKey;
        _secretKey = appSecret;
        _redirectURL = url;
    }
    return self;
}



- (void)LoginWith:(UIView *)view{
    _doubanLoginView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 436)];
    _doubanLoginView.scalesPageToFit = YES;
    _doubanLoginView.userInteractionEnabled = YES;
    _doubanLoginView.delegate = self;
    _doubanLoginView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    NSString *str = [NSString stringWithFormat:@"https://www.douban.com/service/auth2/auth?client_id=%@&redirect_uri=%@&response_type=code", _appKey, _redirectURL];
    
    NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_doubanLoginView loadRequest:request];
    [view addSubview:_doubanLoginView];
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
    [_doubanLoginView removeFromSuperview];
    
    [self.delegate gDoubanDidLoginSuccess:self];
}

- (void)OAuthClient:(DOUOAuthService *)client didFailWithError:(NSError *)error {
    NSLog(@"douban login error: %@", error);
    [self.delegate gDouban:self didLoginFailWithError:error];
}


@end
