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
#import "gAnimation.h"



// TODO: add into Utils
#define starWobbleAngle 5.0
#define starWobbleTime 0.3
#define starWobbleFrequency 1.5
#define starBlinkTime 0.5
#define starBlinkFrequency 1.5
#define starRotateCycle 0.6


@implementation mainViewController

@synthesize starViewNormal = _starViewNormal;
@synthesize starViewShining = _starViewShining;
@synthesize starViewStatic = _starViewStatic;
@synthesize starViewDynamic = _starViewDynamic;
@synthesize shakeButton = _shakeButton;
@synthesize showButton = _showButton;
@synthesize soundID = _soundID;
@synthesize locationManager = _locationManager;
@synthesize personViewController = _personViewController;
@synthesize starWobbleTimer = _starWobbleTimer;
@synthesize starBlinkTimer = _starBlinkTimer;
@synthesize starRotateTimer = _starRotateTimer;







//================button: all bottom button ==begin====================//

- (void) makeShakeButtonShow:(NSString *)msg{
    BOOL show = YES;
    if ([msg isEqualToString:@"hidden"]){
        show = NO;
    }
    [gAnimation makeView:_shakeButton toShow:show withDuration:0.5];
}

- (void) makeShowButtonShow:(NSString *)msg{
    BOOL show = YES;
    if ([msg isEqualToString:@"hidden"]){
        show = NO;
    }
    [gAnimation makeView:_showButton toShow:show withDuration:0.5];
}

//================button: all bottom button ==end====================//


//================image view: wobble star ==begin====================//

- (void) starWobble{
    [gAnimation makeView:_starViewNormal wobbleWithAngle:starWobbleAngle andDuration:starWobbleTime];
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

- (void) starBlink{
    [gAnimation makeView:_starViewShining blinkWithDuration:starBlinkTime];
}

- (void) makeStarBlink:(BOOL)blink{
    if (blink){
        [self starBlink];
        _starBlinkTimer = [NSTimer scheduledTimerWithTimeInterval:starBlinkFrequency target:self selector:@selector(starBlink) userInfo:nil repeats:YES];
    }
    else {
        [_starBlinkTimer invalidate];
    }
}

//================image view: shining star ==end====================//


//================image view: double star ==end====================//

- (void)starRotate {
    [gAnimation makeView:_starViewDynamic rotateAroundWithCycle:starRotateCycle];
}

- (void)makeStarRotate:(BOOL)rotate{
    if (rotate){
        [self starRotate];
        _starRotateTimer = [NSTimer scheduledTimerWithTimeInterval:starRotateCycle target:self selector:@selector(starRotate) userInfo:nil repeats:YES];
    }
    else {
        [_starRotateTimer invalidate];
    }
}

- (void)makeStaticStarShow{
    [gAnimation makeView:_starViewStatic toShow:YES withDuration:0.3];
}

- (void)makeDoubleStarAppear{
    [self makeStarBlink:NO];
    CGRect frame = _starViewNormal.frame;
    frame.origin.x = 16;
    [gAnimation moveView:_starViewNormal toFinalFrame:frame withDuration:2*starRotateCycle];
    
    _starViewDynamic.alpha = 1.0;
    [self makeStarRotate:YES];
    [gAnimation moveView:_starViewDynamic toFinalFrame:CGRectMake(103, 63, 221, 216) withDuration:3*starRotateCycle];
    [self performSelector:@selector(makeStarRotate:) withObject:NO afterDelay:2*starRotateCycle];
    
    [self performSelector:@selector(makeStaticStarShow) withObject:nil afterDelay:3*starRotateCycle];
    //[self makeShowButtonShow:YES];
    [self performSelector:@selector(makeShowButtonShow:) withObject:@"show" afterDelay:3*starRotateCycle];
}

//================image view: double star ==end====================//


//================function--state: shake ==begin====================//

- (void) shakePhone{
    //play sound
    AudioServicesPlaySystemSound (_soundID);
    
    //stop star wobble
    [self makeStarWobble:NO];
    
    //star blink
    [self makeStarBlink:YES];
    
    //bottom button
    [self makeShakeButtonShow:@"hidden"];
    
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
            //[self performSelector:@selector(loadPersonViewWith:) withObject:[feedback objectForKey:@"nearby"] afterDelay:0.5];
            //[self loadPersonViewWith:feedback];
            [self makeDoubleStarAppear];
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
        [self makeShakeButtonShow:@"show"];
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
    // TODO: add frame size into Utils
    //init image view
    CGRect starNormalFrame = CGRectMake(70, 81, 180, 180);
    [_starViewNormal setFrame:starNormalFrame];
    _starViewNormal.alpha = 1.0;
    CGRect starShiningFrame = CGRectMake(70, 81, 180, 180);
    [_starViewShining setFrame:starShiningFrame];
    _starViewShining.alpha = 0.0;
    CGRect starStaticFrame = CGRectMake(0, 63, 221, 216);
    [_starViewStatic setFrame:starStaticFrame];
    _starViewStatic.alpha = 0.0;
    CGRect starDynamicFrame = CGRectMake(0, 0, 0, 0);
    [_starViewDynamic setFrame:starDynamicFrame];
    _starViewDynamic.alpha = 0.0;
    
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
    [self setStarViewStatic:nil];
    [self setStarViewDynamic:nil];
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
    [_starViewStatic release];
    [_starViewDynamic release];
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
