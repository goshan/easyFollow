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

@property(retain, nonatomic) id <gTencentDelegate> delegate;


- (gTencentApi *)initWithAppKey:(NSString *)appKey andAppSecret:(NSString *)appSecret;
- (void)LoginWith:(UIView *)view;


@end


@protocol gTencentDelegate

- (void)loginSucess:(gTencentApi *)tencentApi;
- (void)responseDidFinishLoad:(UIWebView *)webView;
- (void)responseWebView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

@end
