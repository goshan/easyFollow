//
//  MSFTestViewController.m
//  MSFTest
//
//  Created by chen qi on 11-5-24.
//  Copyright 2011 tencent. All rights reserved.
//

#import "OpenSdkTestViewController.h"

#import "OpenSdkTestAppDelegate.h"
#import <CommonCrypto/CommonDigest.h>


@implementation OpenSdkTestViewController



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//__conn = new CIMCommonConnection() ;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	
	//delete __conn ;
}


- (void)dealloc {
    [super dealloc];
}

@end
