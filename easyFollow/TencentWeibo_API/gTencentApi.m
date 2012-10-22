//
//  gTencentApi.m
//  easyFollow
//
//  Created by goshan on 10/19/12.
//  Copyright (c) 2012 easyFollow. All rights reserved.
//
//  ****  make tencent api used easier  ****
//



#import "gTencentApi.h"

@implementation gTencentApi

@synthesize tencentLoginView = _tencentLoginView;
@synthesize tencent = _tencent;
@synthesize delegate = _delegate;





- (gTencentApi *)initWithAppKey:(NSString *)appKey andAppSecret:(NSString *)appSecret{
    self = [super init];
    if (self){
        _tencent = [[OpenSdkOauth alloc] initAppKey:appKey appSecret:appSecret];
        _tencent.oauthType = InWebView;
    }
    return self;
}


- (void)LoginWith:(UIView *)view {
    _tencentLoginView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 436)];
    _tencentLoginView.scalesPageToFit = YES;
    _tencentLoginView.userInteractionEnabled = YES;
    _tencentLoginView.delegate = self;
    _tencentLoginView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [view addSubview:_tencentLoginView];
    [_tencent doWebViewAuthorize:_tencentLoginView];
}




#pragma mark tencent login webview delegate

/*
 * 当前网页视图被指示载入内容时得到通知，返回yes开始进行加载
 */
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL* url = request.URL;
	NSRange start = [[url absoluteString] rangeOfString:@"access_token="];
    NSLog(@"response url is %@", url);
    
    //如果找到tokenkey,就获取其他key的value值
	if (start.location != NSNotFound){
        NSString *accessToken = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:@"access_token="];
        NSString *openid = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:@"openid="];
        NSString *openkey = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:@"openkey="];
		NSString *expireIn = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:@"expires_in="];
        
        if ((accessToken == (NSString *) [NSNull null]) || (accessToken.length == 0) 
            || (openid == (NSString *) [NSNull null]) || (openkey.length == 0) 
            || (openkey == (NSString *) [NSNull null]) || (openid.length == 0)) {
            [_tencent oauthDidFail:InWebView success:YES netNotWork:NO];
        }
        else {
            [_tencent oauthDidSuccess:accessToken accessSecret:nil openid:openid openkey:openkey expireIn:expireIn];
        }
        _tencentLoginView.delegate = nil;
        [_tencentLoginView setHidden:YES];
        
        [self.delegate loginSucess:self];
        
		return NO;
	}
	else{
        start = [[url absoluteString] rangeOfString:@"code="];
        if (start.location != NSNotFound) {
            [_tencent refuseOauth:url];
        }
	}
	
    return YES;
}

/*
 * 当网页视图结束加载一个请求后得到通知
 */
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    NSString *url = webView.request.URL.absoluteString;
    NSLog(@"web view finish load URL %@", url);
    
    [self.delegate responseDidFinishLoad:webView];
}

/*
 * 页面加载失败时得到通知，可根据不同的错误类型反馈给用户不同的信息
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"no network:errcode is %d, domain is %@", error.code, error.domain);
    
    [self.delegate responseWebView:webView didFailLoadWithError:error];
}




@end
