//
//  tipsAlert.m
//  easyFollow
//
//  Created by Qiu Han on 10/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "tipsAlert.h"

@implementation tipsAlert


@synthesize loadingSpinner = _loadingSpinner;



- (void)netErrorAlert{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"网络错误" message:@"少年，乃确定网络没问题！！" delegate:nil cancelButtonTitle:@"囧" otherButtonTitles:nil] autorelease];
    [alert show];
}

- (void)notRegistAlert{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"未登录" message:@"没登陆你搞毛啊！！" delegate:nil cancelButtonTitle:@"这。。。" otherButtonTitles:nil] autorelease];
    [alert show];
}

- (void)nearByNotFoundAlert{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"匹配失败" message:@"孩纸，这个不是用来约炮的！！" delegate:nil cancelButtonTitle:@"我错了" otherButtonTitles:nil] autorelease];
    [alert show];
}

- (void)showRegistLoadingWith:(UIView *)view{
    _loadingSpinner.labelText = NSLocalizedString(@"绑定中...", @"Loading Spinner");
    [view addSubview:_loadingSpinner];
    [_loadingSpinner show:YES];
}

- (void)hiddenRegistLoading{
    [_loadingSpinner hide:YES];
}

- (void)showRegistFinishedWith:(UIView *)view andList:(NSArray *)list{
    NSMutableArray *list_shown = [[NSMutableArray alloc] init];
    for (int i=0; i<list.count; i++){
        if ([[list objectAtIndex:i] isEqualToString:@"renren"]){
            [list_shown addObject:@"人人网"];
        }
        else if ([[list objectAtIndex:i] isEqualToString:@"sina"]){
            [list_shown addObject:@"新浪微博"];
        }
        else if ([[list objectAtIndex:i] isEqualToString:@"tencent"]){
            [list_shown addObject:@"腾讯微博"];
        }
        else if ([[list objectAtIndex:i] isEqualToString:@"douban"]){
            [list_shown addObject:@"豆瓣网"];
        }
    }
    NSString *list_str = [list_shown componentsJoinedByString:@"\n"];
    [view makeToast:list_str duration:3.0 position:@"center" title:@"绑定成功："];
}


- (tipsAlert *)initWith:(UIView *)view{
    self = [super init];
    if (self){
        _loadingSpinner = [[MBProgressHUD alloc] initWithView:view];
    }
    return self;
}


@end
