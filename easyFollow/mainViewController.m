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
@synthesize nameLabel = _nameLabel;
@synthesize soundID = _soundID;
@synthesize locationManager = _locationManager;
@synthesize personViewController = _personViewController;
@synthesize starWobbleTimer = _starWobbleTimer;
@synthesize starBlinkTimer = _starBlinkTimer;
@synthesize starRotateTimer = _starRotateTimer;
@synthesize tips = _tips;










//================button: name label button ==begin====================//

- (void) makeLabelShow:(NSString *)msg{
    BOOL show = YES;
    if ([msg isEqualToString:@"hidden"]){
        show = NO;
    }
    [gAnimation makeView:_nameLabel toShow:show withDuration:0.5];
}

//================button: name label button ==end====================//


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
    else if ([_starBlinkTimer isValid]){
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
    else if ([_starRotateTimer isValid]){
        [_starRotateTimer invalidate];
    }
}

- (void)makeStaticStarShow{
    [gAnimation makeView:_starViewStatic toShow:YES withDuration:0.3];
}

- (void)makeDoubleStarAppearWithName:(NSString *)name{
    [self makeStarBlink:NO];
    CGRect frame = _starViewNormal.frame;
    frame.origin.x = 16;
    [gAnimation moveView:_starViewNormal toFinalFrame:frame withDuration:2*starRotateCycle];
    
    _starViewDynamic.alpha = 1.0;
    [self makeStarRotate:YES];
    [gAnimation moveView:_starViewDynamic toFinalFrame:CGRectMake(103, 63, 221, 216) withDuration:3*starRotateCycle];
    [self performSelector:@selector(makeStarRotate:) withObject:NO afterDelay:2*starRotateCycle];
    [self performSelector:@selector(makeStaticStarShow) withObject:nil afterDelay:3*starRotateCycle];
    [self performSelector:@selector(makeShowButtonShow:) withObject:@"show" afterDelay:3*starRotateCycle];
    _nameLabel.text = name;
    [self performSelector:@selector(makeLabelShow:) withObject:@"show" afterDelay:3*starRotateCycle];
    
}

//================image view: double star ==end====================//


//================image view: shining star ==begin====================//

- (void) closeScreen:(UILabel *)label{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    label.alpha = 1.0;
    [UIView commitAnimations];
}

- (void) openScreen:(UILabel *)label{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    label.alpha = 0.0;
    [UIView commitAnimations];
}

- (void) flashToInit{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    label.backgroundColor = [UIColor whiteColor];
    label.alpha = 0.0;
    [self.view addSubview:label];
    [self closeScreen:label];
    [self performSelector:@selector(initConfigView) withObject:nil afterDelay:0.5];
    //star wobble timer
    [self makeStarBlink:NO];
    [self makeStarWobble:YES];
    [self performSelector:@selector(openScreen:) withObject:label afterDelay:0.6];
}

//================image view: shining star ==end====================//


//================function--init config ==begin====================//
- (void) showRegistPage{
    registViewController *regist = [[[registViewController alloc] initWithNibName:@"registViewController" bundle:nil isUpdate:YES] autorelease];
    [self.navigationController presentModalViewController:regist animated:YES];
}


- (void) initConfigView{
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
    [_showButton addTarget:self action:@selector(loadPersonView) forControlEvents:UIControlEventTouchUpInside];
    
    //init label
    _nameLabel.alpha = 0.0;
    _nameLabel.font = [UIFont fontWithName:nil size:28];
    _nameLabel.textColor = [UIColor colorWithRed:242.0/255.0 green:255.0/255.0 blue:103.0/255.0 alpha:1.0];
    
    //init navigation button
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(showRegistPage)] autorelease];
    [self.navigationItem.rightBarButtonItem setBackgroundImage:[UIImage imageNamed:@"navigation_item_bg"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

//================function--init config ==end====================//


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


//================function--state: show friend ==begin====================//
//gen a person view
- (void) loadPersonView{
    [self.navigationController pushViewController:_personViewController animated:YES];
    [self initConfigView];
    [self makeStarWobble:YES];
}


//================function--state: show friend ==begin====================//


//================function--state: loading ==begin====================//

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
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"/lookfor.json" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //get friend json from server
        NSDictionary *feedback = [[NSDictionary alloc] initWithDictionary:JSON];
        NSString *result = [feedback objectForKey:@"result"];
        NSString *name = [[feedback objectForKey:@"nearby"] objectForKey:@"name"];
        if ([result isEqualToString:@"sucess"]){
            //show person view with feedback data
            _personViewController = [[foundPersonViewController alloc] initWithNibName:@"foundPersonViewController" bundle:nil withData:[feedback objectForKey:@"nearby"]];
            [self makeDoubleStarAppearWithName:name];
        }
        else if ([result isEqualToString:@"nearby_not_found"]){
            NSLog(@"nearby not found!!");
            [_tips nearByNotFoundAlert];
            [self flashToInit];
        }
        else if ([result isEqualToString:@"not_regist"]){
            NSLog(@"you have not regist!!");
            [_tips notRegistAlert];
            [self flashToInit];
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {        
        [_tips netErrorAlert];
        [self flashToInit];
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    [operation start];
    
}

//================function--state: loading ==end====================//







- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSString *path = [[NSBundle mainBundle] pathForResource:@"glass" ofType:@"wav"];
        AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &_soundID);
        
        //!!!Warning: here can not use [initWithView:] function, or can not present modal view for regist page.
        _tips = [[tipsAlert alloc] init];
        
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
    [self initConfigView];
    [self makeStarWobble:YES];
    
    // The "shake" nofification is posted by the PaintingWindow object when user shakes the device
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shakePhone) name:@"shake" object:nil];
    
    //login when need
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"gsf_using_sns"] || [[defaults objectForKey:@"gsf_using_sns"] isEqualToString:@"0,0,0,0"]){
        registViewController *regist = [[[registViewController alloc] initWithNibName:@"registViewController" bundle:nil isUpdate:NO] autorelease];
        [self.navigationController presentModalViewController:regist animated:YES];
    }
}

- (void)viewDidUnload
{
    [self setStarViewNormal:nil];
    [self setStarViewShining:nil];
    [self setShakeButton:nil];
    [self setShowButton:nil];
    [self setStarViewStatic:nil];
    [self setStarViewDynamic:nil];
    [self setNameLabel:nil];
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
    [_nameLabel release];
    [super dealloc];
}


#pragma mark - CLLocation delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //get current location
	CLLocation *location = newLocation;
    
    //call lookfor function to make server find friend nearby
    //!!!Warning:in ios6 sometimes may locate twice, this may cause crash, so you should check whether newlocation and oldlocation are occur recently
    NSArray *versionCompatibility = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ( 6 == [[versionCompatibility objectAtIndex:0] intValue] ) {
        // iOS6 is installed
        if (![oldLocation timestamp] || [[newLocation timestamp] timeIntervalSinceDate:[oldLocation timestamp]] > 1){
            NSLog(@"=========111");
            [self lookForNearbyWithLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude];
        }
        
    } else {
        // iOS5 is installed
        [self lookForNearbyWithLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude];
    }    
    //stop location
	[_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
	NSLog(@"There is an error updating the location");
    
}
@end
