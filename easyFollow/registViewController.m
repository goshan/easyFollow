//
//  registViewController.m
//  easyFollow
//
//  Created by Qiu Han on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "registViewController.h"





CGFloat keyboardHeight = 216.0;
CGFloat rowHeight = 40.0;
CGFloat sectionHeaderHeight = 50.0;
CGFloat sectionHeight = 150.0;


@implementation registViewController

@synthesize tableView = _tableView;
@synthesize activeField = _activeField;
@synthesize allTextField = _allTextField;





- (void) regist{
    
}

- (int) getIndexPathForTextField:(UITextField *)textField{
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
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardHeight, 0.0);
    _tableView.contentInset = contentInsets;
    _tableView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    
    //get screen shown size
    CGRect shownContent = CGRectMake(_tableView.contentOffset.x, _tableView.contentOffset.y, _tableView.frame.size.width, _tableView.frame.size.height-keyboardHeight);
    
    //get section start pos and end pos in Y
    int sectionIndex = [self getIndexPathForTextField:_activeField];
    CGPoint startPoint = CGPointMake(0, sectionHeight*sectionIndex);
    CGPoint endPoint = CGPointMake(0, sectionHeight*(sectionIndex+1));
    
    if (!CGRectContainsPoint(shownContent, startPoint) || !CGRectContainsPoint(shownContent, endPoint) ) {
        CGFloat offsetY = endPoint.y-shownContent.size.height;
        if (offsetY < 0.0){
            offsetY = 0.0;
        }
        CGPoint scrollPoint = CGPointMake(0.0, offsetY);
        [_tableView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _activeField = nil;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *sigleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(willHiddenKeyboard)];
    [_tableView addGestureRecognizer:sigleTap];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return sectionHeaderHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"人人";
            break;
        case 1:
            return @"新浪";
            break;
        default:
            return @"";
            break;
    }
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
    
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    UITextField *textField = (UITextField *)[cell viewWithTag:2];
    
    if (indexPath.row == 0){
        label.text = @"账户";
    }
    else {
        label.text = @"密码";
    }
    
    //set delegate for text editing function to set _activeField
    textField.delegate = self;
    
    //add to _allTextField for getIndexForTextField function
    [_allTextField addObject:textField];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return rowHeight;
}



- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
