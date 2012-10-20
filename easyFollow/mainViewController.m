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




#define starWobbleAngle 5.0
#define starWobbleTime 0.1
#define starWobbleFrequency 1.0
#define starBlinkTime 0.5
#define starBlinkFrequency 1.5


@implementation mainViewController

@synthesize starViewNormal = _starViewNormal;
@synthesize starViewShining = _starViewShining;
@synthesize shakeButton = _shakeButton;
@synthesize showButton = _showButton;
@synthesize soundID = _soundID;
@synthesize locationManager = _locationManager;
@synthesize personViewController = _personViewController;
@synthesize starWobbleTimer = _starWobbleTimer;
@synthesize starBlinkTimer = _starBlinkTimer;






//================image view: wobble star ==begin====================//
- (void)wobbleLeft {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:starWobbleTime];
    CGFloat rotation = (starWobbleAngle * M_PI) / 180.0;
    CGAffineTransform wobbleLeft = CGAffineTransformMakeRotation(rotation);
    _starViewNormal.transform = wobbleLeft;
    [UIView commitAnimations];
}

- (void)wobbleRight {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:starWobbleTime];
    CGFloat rotation = (-starWobbleAngle * M_PI) / 180.0;
    CGAffineTransform wobbleRight = CGAffineTransformMakeRotation(rotation);
    _starViewNormal.transform = wobbleRight;
    [UIView commitAnimations];
}

- (void)wobbleMiddle {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:starWobbleTime];
    CGFloat rotation = 0.0;
    CGAffineTransform wobbleMiddle = CGAffineTransformMakeRotation(rotation);
    _starViewNormal.transform = wobbleMiddle;
    [UIView commitAnimations];
}

- (void) starWobble{
    [self performSelector:@selector(wobbleLeft) withObject:nil afterDelay:0.0];
    [self performSelector:@selector(wobbleRight) withObject:nil afterDelay:starWobbleTime];
    [self performSelector:@selector(wobbleMiddle) withObject:nil afterDelay:2*starWobbleTime];
}

- (void) makeStarWobble:(BOOL)wobble{
    if (wobble){
        _starWobbleTimer = [NSTimer scheduledTimerWithTimeInterval:starWobbleFrequency target:self selector:@selector(starWobble) userInfo:nil repeats:YES];
    }
    else {
        [_starWobbleTimer invalidate];
    }
}

//================image view: wobble star ==end====================//


//================image view: shining star ==begin====================//

- (void) brighten{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:starBlinkTime];
    _starViewShining.alpha = 1.0;
    [UIView commitAnimations];
}

- (void) darken{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:starBlinkTime];
    _starViewShining.alpha = 0.0;
    [UIView commitAnimations];
}

- (void) starBlink{
    [self performSelector:@selector(brighten) withObject:nil afterDelay:0.0];
    [self performSelector:@selector(darken) withObject:nil afterDelay:starBlinkTime];
}

- (void) makeStarBlink:(BOOL)blink{
    if (blink){
        _starBlinkTimer = [NSTimer scheduledTimerWithTimeInterval:starBlinkFrequency target:self selector:@selector(starBlink) userInfo:nil repeats:YES];
    }
    else {
        [_starBlinkTimer invalidate];
    }
}

//================image view: shining star ==end====================//


//================image view: double star ==end====================//

- (void)starRotate {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    CGFloat rotation = (180.0 * M_PI) / 180.0;
    CGAffineTransform rotate = CGAffineTransformMakeRotation(rotation);
    _starViewNormal.transform = rotate;
    [UIView commitAnimations];
}

- (void)makeStarRotate:(BOOL)rotate{
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(starRotate) userInfo:nil repeats:YES];
}




//================image view: double star ==end====================//


//================button: all bottom button ==begin====================//

- (void) makeShakeButtonShow:(BOOL)show{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    if (show){
        _shakeButton.alpha = 1.0;
    }
    else {
        _shakeButton.alpha = 0.0;
    }
    [UIView commitAnimations];
}

- (void) makeShowButtonShow:(BOOL)show{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    if (show){
        _showButton.alpha = 1.0;
    }
    else {
        _showButton.alpha = 0.0;
    }
    [UIView commitAnimations];
}

//================button: all bottom button ==end====================//


//================function--state: shake ==begin====================//

- (void) shakePhone{
    //play sound
    AudioServicesPlaySystemSound (_soundID);
    
    //stop star wobble
    [self makeStarWobble:NO];
    
    //star blink
    [self makeStarBlink:YES];
    
    //bottom button
    [self makeShakeButtonShow:NO];
    
    //get current location
    [_locationManager startUpdatingLocation];
    
}

//================function--state: shake ==end====================//


//================function--state: loading ==begin====================//

- (void) netErrorAlert{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"网络错误" message:@"少年，网络出错了！！" delegate:nil cancelButtonTitle:@"囧" otherButtonTitles:nil] autorelease];
    [alert show];
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
        //make star wobble
        [self makeStarBlink:NO];
        [self makeStarWobble:YES];
        //make shake button show
        [self makeShakeButtonShow:YES];
        //show error alert
        [self netErrorAlert];
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    [operation start];
    
}

- (void) stopFinding{
    
}
//================function--state: loading ==end====================//



//================function--state: show friend ==begin====================//
//gen a person view
- (void) loadPersonViewWith:(NSDictionary *)data{
    _personViewController = [[foundPersonViewController alloc] initWithNibName:@"foundPersonViewController" bundle:nil friendData:data];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)] autorelease];
    [self.navigationItem.rightBarButtonItem setTitle:@"关注"];
    [self.navigationItem.rightBarButtonItem setAction:@selector(follow)];
}

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


//================function--init config ==begin====================//
- (void) configView{
    //init image view
    _starViewNormal.alpha = 1.0;
    _starViewShining.alpha = 0.0;
    
    //init button
    _shakeButton.alpha = 1.0;
    [_shakeButton addTarget:self action:@selector(shakePhone) forControlEvents:UIControlEventTouchUpInside];
    _showButton.alpha = 0.0;
    
    //init navigation button
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(shakePhone)] autorelease];
    
    UIView *view = [self.navigationItem.rightBarButtonItem valueForKey:@"view"];
    CGRect frame = view.frame;
    NSLog(@"========%f   %f", frame.size.height, frame.size.width);
    
    //[self.navigationItem.rightBarButtonItem setBackgroundImage:[UIImage imageNamed:@"barbuttonItem_bg"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    //star wobble timer
    [self makeStarWobble:YES];
}

//================function--init config ==end====================//






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
    [self configView];
    
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
    [self setStarViewNormal:nil];
    [self setStarViewShining:nil];
    [self setShakeButton:nil];
    [self setShowButton:nil];
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
    [_starViewNormal release];
    [_starViewShining release];
    [_shakeButton release];
    [_showButton release];
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
