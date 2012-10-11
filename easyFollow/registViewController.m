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




@implementation registViewController



- (IBAction)renrenLogin:(id)sender {
    NSArray *permission = [NSArray arrayWithObjects:@"send_message", @"send_notification", @"publish_feed", nil];
    [[Renren sharedRenren] authorizationWithPermisson:permission andDelegate:self];
}

- (IBAction)regist:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
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
    //******** get iphone imei
    NSString* imei = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    
    //make url request
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000"];
    AFHTTPClient *httpClient = [[[AFHTTPClient alloc] initWithBaseURL:url]autorelease];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"goshan", @"name", 
                            renren_token, @"renren_token",
                            renren_expir, @"renren_expir",
                            renren_permissions, @"renren_permissions", 
                            imei, @"iphone_imei", 
                            nil];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"/users/create_user.json" parameters:params];
    
    //put request
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //get respond json from server
        NSDictionary *feedback = [[NSDictionary alloc] initWithDictionary:JSON];
        BOOL result = [[feedback objectForKey:@"sucess"] isEqual:@"1"] ? YES : NO;
        if (result){
            NSLog(@"regist sucess!!");
            
        }
        else {
            NSLog(@"this iphone has registed!!");
        }
        [defaults setObject:[feedback objectForKey:@"user_id"] forKey:@"gsf_user_id"];
        [defaults setObject:[feedback objectForKey:@"token"] forKey:@"gsf_token"];
        
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    [operation start];
    
    //dismiss regist view
    [self dismissModalViewControllerAnimated:YES];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    NSLog(@"========%@", renren);
}

/**
 * 授权登录失败时被调用，第三方开发者实现这个方法
 * @param renren 传回代理授权登录接口请求的Renren类型对象。
 */
- (void)renren:(Renren *)renren loginFailWithError:(ROError*)error
{
    NSLog(@"========%@", renren);
    NSLog(@"========%@", error);
}

@end
