//
//  mainViewController.m
//  easyFollow
//
//  Created by Qiu Han on 10/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "mainViewController.h"




BOOL isOpen = NO;

@implementation mainViewController
@synthesize imageUp = _imageUp;
@synthesize imageDown = _imageDown;




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
    [UIView setAnimationDuration:0.5];
    
    CGRect imageUpFrame = _imageUp.frame;
    imageUpFrame.origin.y = imageUpOriY;
    [_imageUp setFrame:imageUpFrame];
    
    CGRect imageDownFrame = _imageDown.frame;
    imageDownFrame.origin.y = imageDownOriY;
    [_imageDown setFrame:imageDownFrame];
    
    [UIView commitAnimations];
}

- (void) shakePhone{
    //close image cover
    isOpen = NO;
    [self performSelector:@selector(moveImageCover)];
    
    //open image cover
    isOpen = YES;
    [self performSelector:@selector(moveImageCover) withObject:nil afterDelay:1.0];
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
}

- (void)viewDidUnload
{
    [self setImageUp:nil];
    [self setImageDown:nil];
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
    [super dealloc];
}
@end
