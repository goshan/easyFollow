//
//  gDoubanApi.h
//  easyFollow
//
//  Created by Qiu Han on 10/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUAPIEngine.h"




@protocol gDoubanDelegate;

@interface gDoubanApi : NSObject <UIWebViewDelegate, DOUOAuthServiceDelegate>

@property(retain, nonatomic) NSString *appKey;
@property(retain, nonatomic) NSString *secretKey;
@property(retain, nonatomic) NSString *redirectURL;

@property(retain, nonatomic) NSString *accessToken;
@property(retain, nonatomic) NSString *expiresIn;
@property(retain, nonatomic) NSString *userId;
@property(retain, nonatomic) NSString *refreshToken;

@property(retain, nonatomic) UIWebView *doubanLoginView;

@property(retain, nonatomic) id <gDoubanDelegate> delegate;




- (gDoubanApi *)initWithAppKey:(NSString *)appKey andAppSecret:(NSString *)appSecret andRedirectURL:(NSString *)url;
- (void)LoginWith:(UIView *)view;

@end



@protocol gDoubanDelegate

- (void)gDoubanDidLoginSuccess:(gDoubanApi *)douban;
- (void)gDouban:(gDoubanApi *)douban didLoginFailWithError:(NSError *)error;

@end
