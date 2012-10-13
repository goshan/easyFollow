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

@synthesize soundID = _soundID;
@synthesize personView = _personView;
@synthesize imageUp = _imageUp;
@synthesize imageDown = _imageDown;
@synthesize locationManager = _locationManager;
@synthesize personViewController = _personViewController;




//nav bar button function
- (void)follow {
    NSLog(@"follow clicked!");
}

- (void)cancel {
    NSLog(@"cancel clicked!");
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    _personView.alpha = 0.0;
    
    [UIView commitAnimations];
    
    [_personViewController.view removeFromSuperview];
    [_personViewController release];
    
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationItem.rightBarButtonItem setTitle:@"摇一摇"];
    [self.navigationItem.rightBarButtonItem setAction:@selector(shakePhone)];
}

//data exchange

- (void) loadPersonViewWith:(NSDictionary *)data{
    _personViewController = [[foundPersonViewController alloc] initWithNibName:@"foundPersonViewController" bundle:nil friendData:data];
    
    [_personView addSubview:_personViewController.view];
    _personView.alpha = 1.0;
    
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
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
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
        } 
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    ];
    [operation start];
    
    //open image cover
    isOpen = YES;
    [self performSelector:@selector(moveImageCover) withObject:nil afterDelay:0.6];
}

//image animation

- (void) moveImageCover{
    CGFloat imageUpOriY = 0.0;
    CGFloat imageDownOriY = 0.0;
    if (isOpen){
        imageUpOriY = -208.0;
        imageDownOriY = 416.0;
    }
    else {
        imageUpOriY = 0.0;
        imageDownOriY = 208.0;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    
    CGRect imageUpFrame = _imageUp.frame;
    imageUpFrame.origin.y = imageUpOriY;
    [_imageUp setFrame:imageUpFrame];
    
    CGRect imageDownFrame = _imageDown.frame;
    imageDownFrame.origin.y = imageDownOriY;
    [_imageDown setFrame:imageDownFrame];
    
    [UIView commitAnimations];
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

- (void) stopFinding{
    
}


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
    _personView.alpha = 0.0;
    
    CGRect imageUpFrame = _imageUp.frame;
    imageUpFrame.size.height = 208;
    imageUpFrame.origin.y = -208;
    [_imageUp setFrame:imageUpFrame];
    
    CGRect imageDownFrame = _imageDown.frame;
    imageUpFrame.size.height = 208;
    imageDownFrame.origin.y = 416;
    [_imageDown setFrame:imageDownFrame];
    
    // The "shake" nofification is posted by the PaintingWindow object when user shakes the device
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shakePhone) name:@"shake" object:nil];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(stopFinding)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"摇一摇" style:UIBarButtonItemStyleBordered target:self action:@selector(shakePhone)] autorelease];
    
    //login when need
    if (![[Renren sharedRenren] isSessionValid]){
        registViewController *regist = [[[registViewController alloc] initWithNibName:@"registViewController" bundle:nil] autorelease];
        [self.navigationController presentModalViewController:regist animated:YES];
    }
}

- (void)viewDidUnload
{
    [self setImageUp:nil];
    [self setImageDown:nil];
    [self setPersonView:nil];
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
    [_imageUp release];
    [_imageDown release];
    [_personView release];
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
