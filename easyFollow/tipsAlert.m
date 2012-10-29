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

- (void)alreadyFriendAlert{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"关注失败" message:@"都是好友了还关注，你们是有多恩爱！！" delegate:nil cancelButtonTitle:@"奥，这样啊" otherButtonTitles:nil] autorelease];
    [alert show];
}

- (void)locateFrequentAlert{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"查找失败" message:@"晃动太频繁容易扯着蛋哦~" delegate:nil cancelButtonTitle:@"不要啊，魂淡！" otherButtonTitles:nil] autorelease];
    [alert show];
}

- (void)showRegistLoadingWith:(UIView *)view{
    _loadingSpinner.labelText = NSLocalizedString(@"绑定中...", @"Loading Spinner");
    [view addSubview:_loadingSpinner];
    [_loadingSpinner show:YES];
}

- (void)showFollowLoadingWith:(UIView *)view{
    _loadingSpinner.labelText = NSLocalizedString(@"关注中...", @"Loading Spinner");
    [view addSubview:_loadingSpinner];
    [_loadingSpinner show:YES];
}

- (void)hiddenRegistLoading{
    [_loadingSpinner hide:YES];
}

- (void)hiddenFollowLoading{
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

- (void)showFollowFinishedWith:(UIView *)view andList:(NSArray *)list{
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
    [view makeToast:list_str duration:3.0 position:@"center" title:@"关注成功："];
}


- (tipsAlert *)initWith:(UIView *)view{
    self = [super init];
    if (self){
        _loadingSpinner = [[MBProgressHUD alloc] initWithView:view];
    }
    return self;
}


@end
