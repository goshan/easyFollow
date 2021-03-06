//
//  gTencentApi.h
//  easyFollow
//
//  Created by goshan on 10/19/12.
//  Copyright (c) 2012 easyFollow. All rights reserved.
//
//
//  ****  make tencent api used easier  ****
//



#import <Foundation/Foundation.h>
#import "OpenSdkOauth.h"



@protocol gTencentDelegate;


@interface gTencentApi : NSObject <UIWebViewDelegate>

@property(retain, nonatomic) UIWebView *tencentLoginView;
@property(retain, nonatomic) OpenSdkOauth *tencent;
@property(retain, nonatomic) NSDate *expireAt;

@property(retain, nonatomic) id <gTencentDelegate> delegate;


- (gTencentApi *)initWithAppKey:(NSString *)appKey andAppSecret:(NSString *)appSecret andRedirectURL:(NSString *)redirect_url;
- (void)LoginWith:(UIView *)view;
- (void)LogOut;
- (BOOL)isLogin;
- (BOOL)isExpired;


@end


@protocol gTencentDelegate

- (void)loginSucess:(gTencentApi *)tencentApi;
- (void)responseDidFinishLoad:(UIWebView *)webView;
- (void)responseWebView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
- (void)tencentCloseWeb;

@end
