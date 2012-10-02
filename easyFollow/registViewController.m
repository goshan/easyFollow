//
//  registViewController.m
//  easyFollow
//
//  Created by Qiu Han on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "registViewController.h"




@implementation registViewController

@synthesize tableView = _tableView;
@synthesize activeField = _activeField;
@synthesize allTextField = _allTextField;





- (void) regist{
    
}

- (int) getIndexForTextField:(UITextField *)textField{
    for (int i=0; i<_allTextField.count; i++){
        if (textField == [_allTextField objectAtIndex:i]){
            return i/2;
        }
    }
    return -1;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _activeField = nil;
}

- (void) showKeyboard:(NSNotification*)notification{
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    _tableView.contentInset = contentInsets;
    _tableView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    
    //resize table height
    CGRect frame = _tableView.frame;
    frame.size.height -= keyboardSize.height+_activeField.frame.size.height+15.0;
    
    //get textField y pos
    CGRect activeFrame = _activeField.frame;
    int index = [self getIndexForTextField:_activeField];
    activeFrame.origin.y += 142.0*index;
    
    if (!CGRectContainsPoint(frame, activeFrame.origin) ) {
        CGFloat offsetY = activeFrame.origin.y-frame.size.height;
        CGPoint scrollPoint = CGPointMake(0.0, offsetY);
        [_tableView setContentOffset:scrollPoint animated:YES];
    }
}

- (void) hiddenKeyboard:(NSNotification*)notification{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _tableView.contentInset = contentInsets;
    _tableView.scrollIndicatorInsets = contentInsets;
}

- (void) willHiddenKeyboard{
    [_activeField resignFirstResponder];
}





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _activeField = nil;
        _allTextField = [[NSMutableArray alloc] init];
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
    self.title = @"注册";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(regist)];
    
    _tableView.allowsSelection = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Table View data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"registCell_id";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* objects =  [[NSBundle  mainBundle] loadNibNamed:@"registCell" owner:nil options:nil];
        cell = [objects objectAtIndex:0];
    }
    
    // Set up the cell...
    UILabel *sectionName = (UILabel *)[cell viewWithTag:1];
    UILabel *user = (UILabel *)[cell viewWithTag:2];
    UILabel *pass = (UILabel *)[cell viewWithTag:3];
    UITextField *user_text = (UITextField *)[cell viewWithTag:4];
    UITextField *pass_text = (UITextField *)[cell viewWithTag:5];
    
    if (indexPath.row == 0){
        sectionName.text = @"人人";
    }
    else {
        sectionName.text = @"微博";
    }
    user.text = @"账户";
    pass.text = @"密码";
    
    //set delegate for text editing function to set _activeField
    user_text.delegate = self;
    pass_text.delegate = self;
    
    //add to _allTextField for getIndexForTextField function
    [_allTextField addObject:user_text];
    [_allTextField addObject:pass_text];
    
    UITapGestureRecognizer *sigleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(willHiddenKeyboard)];
    [cell addGestureRecognizer:sigleTap];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 142.0;
}



- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
