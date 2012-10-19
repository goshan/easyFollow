//
//  FeatureListViewController.m
//  MSFTest
//
//  Created by Ruifan Yuan on 6/14/11.
//  Copyright 2011 . All rights reserved.
//

#import "FeatureListViewController.h"
#import "OpenSdkTestAppDelegate.h"



@interface FeatureListViewController (TestMethods)
- (void) testLoginWithMicroblogAccount;
@end

#pragma mark -
#pragma mark Test function definitions
@implementation FeatureListViewController (TestMethods)

- (void) testLoginWithMicroblogAccount {

	self.appKey = @"7f584ba48b4d4dfaa5b06cc484384095";
	self.appSecret = @"3b36158de7748d10cdb14fa338305cfc";
    _viewController = [MsfOpenSdkInterface  initLoginViewController:self.appKey appSecret:self.appSecret];
    _viewController.delegate = self;
    
	UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:_viewController];
	[self presentModalViewController:nc animated:YES];
	[nc release];
}

@end


#pragma mark -
#pragma mark Initialization
@implementation FeatureListViewController

@synthesize appKey = _appKey;
@synthesize appSecret = _appSecret;
@synthesize accessKey = _accessKey;
@synthesize accessSecret = _accessSecret;
@synthesize filePathName = _filePathName;

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
		featureList = [[NSArray arrayWithObjects:@"微博登录", @"选择图片", nil] retain];
    }
    
    return self;
}


#pragma mark -
#pragma mark View lifecycle
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return true; // supports all orientations
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return featureList.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	int section = [indexPath indexAtPosition:0];
	int row = [indexPath indexAtPosition:1];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	if(section == 0) {
		// we have only a single section
		cell.textLabel.text = [featureList objectAtIndex:row];
		cell.textLabel.textAlignment = UITextAlignmentCenter;
	}
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.

	int section = [indexPath indexAtPosition:0];
	int row = [indexPath indexAtPosition:1];
	if(0 == section) {
		switch (row) {
			case 0:
				// Third party microblog login
				[self testLoginWithMicroblogAccount];
				break;
            case 1:
            {
                UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePickerController.delegate = self;
                [self presentModalViewController:imagePickerController animated:YES];
                [imagePickerController release];
				
				
            }
			default:
				break;
		}
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [_viewController release];
	[featureList release];
    [super dealloc];
}

static NSString* toHexString(const unsigned char* buf, int len){
	static char tbl[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
	char* hex = malloc((len << 1) + 1);

	for(int i = 0; i < len; ++i){
		hex[i << 1] = tbl[(buf[i] & 0xf0) >> 4];
        hex[(i << 1) + 1] = tbl[buf[i] & 0x0f];
	}
    
    hex[len << 1] = 0;
    
    NSString* s = [NSString stringWithUTF8String:hex];
    free(hex);
    
	return s;
}

- (void) showMessageBox:(NSString*)content{
	
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
	alert.tag = 'e';
	[alert show];
	[alert release];
}

- (void)loginSucceeded:(NSString *)account tokens:(NSDictionary*)tokens {
    NSLog(@"loginSucceeded called");
    NSLog(@"%@ login succeeded!", account);
    
    NSString *tokenKey = [tokens objectForKey:@"AccessToken"];
    
    NSString *tokenSecret = [tokens objectForKey:@"AccessSecret"];
    
    NSLog(@"%s-%s", [tokenKey UTF8String], [tokenSecret UTF8String]);
    
    
    self.accessKey = tokenKey;
    self.accessSecret = tokenSecret;
    
		
	[self showMessageBox:@"登录成功！"];
    
	[self publishWeibo];
}

-(void)publishWeibo{
	
    NSString *weiboContent = [NSString stringWithUTF8String:"slsussudusu速度发微博了@##$%^&&&**==++ good 。。。。"];
    NSLog(@"ImagePathName:%@", self.filePathName);
	
	_WeiboInterface = [[WeiboInterface alloc] initWithKeys:self.appKey appSecret:self.appSecret accessToken:self.accessKey accessSecret:self.accessSecret];
	
	_WeiboInterface.delegate = self;
	[_WeiboInterface publishWeibo:weiboContent withImage:self.filePathName];
}
								   
- (void)publishWeiboFinished:(int)resultCode resultStr:(NSString*)str
{     NSLog(@"PublishWeiboResult:%d:%@", resultCode, str);
	
	NSString* desc = [NSString stringWithFormat:@"ret:%d, %@", resultCode, str];
	
	[self showMessageBox:desc];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
	[picker dismissModalViewControllerAnimated:YES];
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
	NSString *filePath = [NSTemporaryDirectory() stringByAppendingFormat:@"temp.png"];
	[UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
	self.filePathName = filePath;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	
	[picker dismissModalViewControllerAnimated:YES];
}


@end

