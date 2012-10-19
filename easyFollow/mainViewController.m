//
//  mainViewController.m
//  easyFollow
//
//  Created by Qiu Han on 10/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "mainViewController.h"
#import "registViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "Renren.h"



BOOL isOpen = NO;

@implementation mainViewController

@synthesize starView = _starView;
@synthesize soundID = _soundID;
@synthesize locationManager = _locationManager;
@synthesize personViewController = _personViewController;





//================function--state: waiting ==begin====================//
- (void)wobbleLeft {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    CGFloat rotation = (5.0 * M_PI) / 180.0;
    CGAffineTransform wobbleLeft = CGAffineTransformMakeRotation(rotation);
    _starView.transform = wobbleLeft;
    [UIView commitAnimations];
}

- (void)wobbleRight {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    CGFloat rotation = (-5.0 * M_PI) / 180.0;
    CGAffineTransform wobbleRight = CGAffineTransformMakeRotation(rotation);
    _starView.transform = wobbleRight;
    [UIView commitAnimations];
}

- (void)wobbleMiddle {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    CGFloat rotation = 0.0;
    CGAffineTransform wobbleMiddle = CGAffineTransformMakeRotation(rotation);
    _starView.transform = wobbleMiddle;
    [UIView commitAnimations];
}

- (void) starWobble{
    [self performSelector:@selector(wobbleLeft) withObject:nil afterDelay:0.0];
    [self performSelector:@selector(wobbleRight) withObject:nil afterDelay:0.1];
    [self performSelector:@selector(wobbleMiddle) withObject:nil afterDelay:0.2];
}

//================function--state: waiting ==end====================//


//================function--state: shake ==begin====================//

- (void) moveImageCover{
    
}

- (void) shakePhone{
    //play sound
    AudioServicesPlaySystemSound (_soundID);
    
    //close image cover
    isOpen = NO;
    [self performSelector:@selector(moveImageCover)];
    
    //get current location
    [_locationManager startUpdatingLocation];
    
}

//================function--state: shake ==end====================//





//================function--state: loading ==begin====================//
- (void) loadPersonViewWith:(NSDictionary *)data{
    _personViewController = [[foundPersonViewController alloc] initWithNibName:@"foundPersonViewController" bundle:nil friendData:data];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)] autorelease];
    [self.navigationItem.rightBarButtonItem setTitle:@"关注"];
    [self.navigationItem.rightBarButtonItem setAction:@selector(follow)];
}

- (void) lookForNearbyWithLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude{
    NSLog(@"Our current Longitude is %f",longitude);
    NSLog(@"Our current Latitude is %f",latitude);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //push location to server
    //**** prepair for user data
    //******** get renren data
    NSString *token = [defaults objectForKey:@"gsf_token"];
    NSString *longitude_str = [NSString stringWithFormat:@"%f", longitude];
    NSString *latitude_str = [NSString stringWithFormat:@"%f", latitude];
    
    //***** make url request
    NSString *server_ip = [defaults objectForKey:@"server_ip"];
    NSString *url_str = [NSString stringWithFormat:@"http://%@", server_ip];
    NSURL *url = [NSURL URLWithString:url_str];
    AFHTTPClient *httpClient = [[[AFHTTPClient alloc] initWithBaseURL:url]autorelease];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            token, @"token",
                            longitude_str, @"longitude",
                            latitude_str, @"latitude", 
                            nil];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"/users/lookfor.json" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //get friend json from server
        NSDictionary *feedback = [[NSDictionary alloc] initWithDictionary:JSON];
        NSString *result = [feedback objectForKey:@"result"];
        if ([result isEqualToString:@"sucess"]){
            //show person view with feedback data
            [self performSelector:@selector(loadPersonViewWith:) withObject:[feedback objectForKey:@"nearby"] afterDelay:0.5];
            //[self loadPersonViewWith:feedback];
        }
        else if ([result isEqualToString:@"nearby_not_found"]){
            NSLog(@"nearby not found!!");
        }
        else if ([result isEqualToString:@"not_regist"]){
            NSLog(@"you have not regist!!");
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    [operation start];
    
    //open image cover
    isOpen = YES;
    [self performSelector:@selector(moveImageCover) withObject:nil afterDelay:0.6];
}

- (void) stopFinding{
    
}
//================function--state: loading ==end====================//


//================function--state: show friend ==begin====================//
//nav bar button function
- (void)cancel {
    NSLog(@"cancel clicked!");
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    
    [_personViewController.view removeFromSuperview];
    [_personViewController release];
    
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationItem.rightBarButtonItem setTitle:@"摇一摇"];
    [self.navigationItem.rightBarButtonItem setAction:@selector(shakePhone)];
}

- (void)follow {
    NSLog(@"follow clicked!");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *server_ip = [defaults objectForKey:@"server_ip"];
    NSString *url_str = [NSString stringWithFormat:@"http://%@", server_ip];
    NSURL *url = [NSURL URLWithString:url_str];
    AFHTTPClient *httpClient = [[[AFHTTPClient alloc] initWithBaseURL:url]autorelease];
    
    NSString *token = [defaults objectForKey:@"gsf_token"];
    NSString *followed_id = [_personViewController.friendData objectForKey:@"id"];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            token, @"token", 
                            followed_id, @"followed_id",
                            nil];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"/users/follow.json" parameters:params];
    
    //put request
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //get respond json from server
        NSDictionary *feedback = [[NSDictionary alloc] initWithDictionary:JSON];
        NSString *result = [feedback objectForKey:@"result"];
        
        if ([result isEqualToString:@"sucess"]){
            NSLog(@"follow sucess!!");
            [self cancel];
            
        }
        else {
            NSLog(@"follow failed");
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    [operation start];
}
//================function--state: show friend ==begin====================//







- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSString *path = [[NSBundle mainBundle] pathForResource:@"glass" ofType:@"wav"];
        AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &_soundID);
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        //make Current location permission dialog appears
        [_locationManager startUpdatingLocation];
        [_locationManager stopUpdatingLocation];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(shakePhone)] autorelease];
    
    UIView *view = [self.navigationItem.rightBarButtonItem valueForKey:@"view"];
    CGRect frame = view.frame;
    NSLog(@"========%f   %f", frame.size.height, frame.size.width);
    
    //[self.navigationItem.rightBarButtonItem setBackgroundImage:[UIImage imageNamed:@"barbuttonItem_bg"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(starWobble) userInfo:nil repeats:YES];
    
    // The "shake" nofification is posted by the PaintingWindow object when user shakes the device
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shakePhone) name:@"shake" object:nil];
    
    //login when need
//    if (![[Renren sharedRenren] isSessionValid]){
//        registViewController *regist = [[[registViewController alloc] initWithNibName:@"registViewController" bundle:nil] autorelease];
//        [self.navigationController presentModalViewController:regist animated:YES];
//    }
}

- (void)viewDidUnload
{
    [self setStarView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_starView release];
    [super dealloc];
}


#pragma mark - CLLocation delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //get current location
	CLLocation *location = newLocation;
    
    //call lookfor function to make server find friend nearby
    [self lookForNearbyWithLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude];
    
    //stop location
	[_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
	NSLog(@"There is an error updating the location");
    
}
@end
