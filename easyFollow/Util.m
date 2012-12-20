//
//  Util.m
//  Kecheng
//
//  Created by tian li on 2/21/12.
//  Copyright (c) 2012 CreatingEV. All rights reserved.
//

#import "Util.h"

#if TARGET_IPHONE_SIMULATOR
NSString* const SERVER_URL = @"http://localhost:3000";
#else
NSString* const SERVER_URL = @"http://easy-follow.com";
#endif

NSString *const RENREN_APPID = @"214568";
NSString *const RENREN_APIKEY = @"a68774405e5d43fca919fe2436f07fcf";
NSString *const SINA_APPKEY = @"1799175553";
NSString *const SINA_SECRETKEY = @"4c2180d2a60b0fa917960e5b7f824a04";
NSString *const SINA_REDIRECTURI = @"http://easy-follow.com";
NSString *const TENCENT_APPKEY = @"801255147";
NSString *const TENCENT_SECRETKEY = @"875d58fb566cb9e9183830dde6515fbc";
NSString *const DOUBAN_APPKEY = @"0c342ae9640503b8249c80bc2c0f0b28";
NSString *const DOUBAN_SECRETKEY = @"f3e0862f5378b28c";
NSString *const DOUBAN_REDIRECTURL = @"http://easy-follow.com";

NSString *const SIGNUP_FROM = @"1";
NSString *const USERID_KEY = @"gsf_user_id";
NSString *const TOKEN_KEY = @"gsf_token";
NSString *const USING_SNS_KEY = @"gsf_using_sns";
NSString *const RENREN_TOKEN_KEY = @"gsf_renren_token";
NSString *const RENREN_EXPIRE_KEY = @"gsf_renren_expire";
NSString *const RENREN_PERMISSION_KEY = @"gsf_renren_permission";
NSString *const SINA_TOKEN_KEY = @"gsf_sina_token";
NSString *const SINA_EXPIRE_KEY = @"gsf_sina_expire";
NSString *const SINA_ID_KEY = @"gsf_sina_id";
NSString *const TENCENT_TOKEN_KEY = @"gsf_tencent_token";
NSString *const TENCENT_EXPIRE_KEY = @"gsf_tencent_expire";
NSString *const TENCENT_OPENID_KEY = @"gsf_tencent_openid";
NSString *const DOUBAN_TOKEN_KEY = @"gsf_douban_token";
NSString *const DOUBAN_ID_KEY = @"gsf_douban_id";
NSString *const DOUBAN_EXPIRE_KEY = @"gsf_douban_expire";

NSString *const LOCATION_TIMESTAMP = @"gsf_location_timestamp";


@implementation Util

@end
