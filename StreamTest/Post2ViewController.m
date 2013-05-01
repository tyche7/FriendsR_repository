//
//  RecommendViewController.m
//  StreamTest
//
//  Created by Naehee Kim on 10/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import "Post2ViewController.h"
#import "Rec.h"
#import "DataFeedStore.h"
#import "UserStore.h"
#import "UserData.h"
#import "CameraViewController.h"
#import "OptionViewController.h"
#import "AgeListViewController.h"
#import "NoteViewController.h"
#import <QuartzCore/QuartzCore.h>

#define DataDownloaderRunMode @"myapp.run_mode"
#define DO_SOMETHING_ELSE @"Do something else"
#define purchaseFieldTag 11
#define ageFieldTag 12
#define noteFieldTag 13


@implementation Post2ViewController


@synthesize ageController;
@synthesize postView, purchasePlaceField, rec, productImage;
@synthesize ageLabel;
@synthesize bbiRight;
@synthesize spinner;


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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"furley_bg"]];
    
    // Do any additional setup after loading the view from its nib.

    
    
    
    UIBarButtonItem *bbiLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    bbiLeft.enabled = YES;
    [[self navigationItem] setLeftBarButtonItem:bbiLeft];
    
    
    bbiRight = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonWasPressed:)];
    // set this bar button item as the right item in the navigationItem
    [[self navigationItem] setRightBarButtonItem:bbiRight];
    
    // create a new bar button item
    bbiRight = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonWasPressed:)];
    // set this bar button item as the right item in the navigationItem
    [[self navigationItem] setRightBarButtonItem:bbiRight];
    
    
    self.title = @"Post";
    
    self.infoTableView.scrollEnabled = NO;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
    // dissmiss keyboard whenever postview appears
    
    [self.view endEditing:YES];
    
    // ensure that the purchaseplacefiled does not be a firstresponder
    [self.purchasePlaceField resignFirstResponder];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




-(IBAction)cancel:(id)sender{
    
    //dismiss keyboard if it is active
    [self.view endEditing:YES];
    
    //erase content
    [self eraseContent];
     
    // go back to previousview
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)eraseContent{
    
    UITextField* field;
    for (int i=11; i<14; i++) {
        field = (UITextField *)[self.view viewWithTag:i];
        field.text = @"";
    }
    
    //erase note(description)
    self.noteController.noteTextView.text = @"";
    
    
}





-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save failed" message:@"Failed to save image" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissModalViewControllerAnimated:YES];
}




// table view
// http://stackoverflow.com/questions/409259/having-a-uitextfield-in-a-uitableviewcell

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView
                                               dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
        cell.textLabel.clipsToBounds = YES;
        
    }
    
    UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(140, 13, 155, 22)];
    inputTextField.adjustsFontSizeToFitWidth = YES;
    inputTextField.textColor = [UIColor blackColor];
    inputTextField.font = [UIFont systemFontOfSize:13];
    inputTextField.keyboardType = UIKeyboardTypeDefault;
    inputTextField.returnKeyType = UIReturnKeyNext;
    inputTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
    inputTextField.textAlignment = UITextAlignmentLeft;
    inputTextField.delegate = self;
    
    inputTextField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
    
    
    [cell.contentView addSubview:inputTextField];
    
    switch (indexPath.row) {
            
        case 0:
            cell.textLabel.text = @"Purchased At";
            inputTextField.placeholder = @"optional";
            inputTextField.tag = purchaseFieldTag;
            [inputTextField setEnabled: YES];
            self.purchasePlaceField = inputTextField;
            break;
            
        case 1:
            cell.textLabel.text = @"Age Range";
            NSLog(@"age label selected by user:%@", self.ageLabel);
            NSLog(@"age: %d", rec.ageBand);
            
            if (rec.ageBand > 0 ) {  //if properly set by user
                inputTextField.placeholder = nil;
                inputTextField.text = self.ageLabel;
                
            }else{
                inputTextField.placeholder = @"optional";
            }
            [inputTextField setEnabled:NO];
            inputTextField.tag = ageFieldTag;
            
            break;
            
        case 2:
            cell.textLabel.text = @"Comments";
            inputTextField.placeholder = @"optional";
            [inputTextField setEnabled:NO];
            inputTextField.tag = noteFieldTag;
            
            break;
            
        default:
            break;
    }
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 1){
        
        if(!self.ageController){
            self.ageController = [[AgeListViewController alloc] init];
            self.ageController.delegate = self;
        }
        [self.navigationController pushViewController:self.ageController animated:true];
        
        //dismiss keyboard if it is active
        [self.view endEditing:YES];
        
    }else if (indexPath.row == 2){
        NSLog(@"index path note is selected");
        if(!self.noteController){
            self.noteController = [[NoteViewController alloc] init];
            self.noteController.delegate = self;
        }
        [self.navigationController pushViewController:self.noteController animated:true];
        
        //dismiss keyboard if it is active
        [self.view endEditing:YES];
       
    }
}

- (void)updateCellIndex:(int)index withSubtitle:(NSString*)subtitle {
    UITableViewCell *cell = (UITableViewCell *)[self.infoTableView
                                                cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    
    cell.detailTextLabel.text = subtitle;
}



//http://stackoverflow.com/questions/1347779/how-to-navigate-through-textfields-next-done-buttons
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    NSLog(@"next tag: %d", textField.tag +1);
    
    // Try to find next responder
    //UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    UITextField* nextTextField = (UITextField *)[self.view viewWithTag:nextTag];
    
    if (nextTextField) {
        // Found next responder
        if (nextTextField.enabled) {
            // set it
            [nextTextField becomeFirstResponder];
        }else{
            // remove keyboard.
            [textField resignFirstResponder];
        }
        
        NSLog(@"now next responder became firstResponder");
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
        NSLog(@"no next first responder");
    }
    return NO; // We do not want UITextField to insert line-breaks.
}


//This method is called after the text field resigns its first responder status
-(void)textFieldDidEndEditing:(UITextField *)textField{
    //[self setInfo:textField];
    
}





// Implement the delegate methods

-(void)setAge:(int)age withLabel:(NSString *)_ageLabel{
    self.ageLabel = _ageLabel;
    self.rec.ageBand = age;
    
    //update the associated textfield
    
    UITextField *ageField = (UITextField *)[self.view viewWithTag:ageFieldTag];
    ageField.text = self.ageLabel;
    
    [self.navigationController popViewControllerAnimated:YES];
}

// Implement the delegate methods

-(void)setNote:(NSString* )note{
    self.rec.postText = note;
    
    //update the associated textfield
    
    UITextField *noteField = (UITextField *)[self.view viewWithTag:noteFieldTag];
    noteField.text = note;
    
    [self.navigationController popViewControllerAnimated:YES];
}

// Activity indicator
// http://stackoverflow.com/questions/6336788/ios-waiting-screen

- (UIActivityIndicatorView *)showActivityIndicatorOnView:(UIView*)aView
{
    CGSize viewSize = aView.bounds.size;
    
    // create new dialog box view and components
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]
                                                      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // other size? change it
    activityIndicatorView.bounds = CGRectMake(0, 0, 65, 65);
    activityIndicatorView.hidesWhenStopped = YES;
    activityIndicatorView.alpha = 0.7f;
    activityIndicatorView.backgroundColor = [UIColor blackColor];
    activityIndicatorView.layer.cornerRadius = 10.0f;
    
    // display it in the center of your view
    activityIndicatorView.center = CGPointMake(viewSize.width / 2.0, viewSize.height / 2.0);
    
    [aView addSubview:activityIndicatorView];
    
    [activityIndicatorView startAnimating];
    
    return activityIndicatorView;
}

- (void)showAlertView:(NSString*)title andMessage:(NSString*)msg{
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(title, @"")
                                message:msg
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil] show];
}

// upload to webserver


-(void)saveButtonWasPressed:(id)sender{
    
  
    // disable save button for users not to be allowed to tap save button while uploading
    [bbiRight setEnabled:NO];
    
    // save data in Rec object

    rec.purchasePlace = purchasePlaceField.text;  
    UserStore *userStore = [UserStore sharedStore];
    rec.userName = userStore.userData.username;
    
    
    NSLog(@"UPLOAD: %@", userStore.userData.userID);
    NSLog(@"UPLOAD: %@", rec.userName);
    NSLog(@"UPLOAD: %@", rec.productName);
    NSLog(@"UPLOAD: %@", rec.postText);
    NSLog(@"UPLOAD: %@", rec.purchasePlace);
    
    if (!rec.postText) rec.postText = @"";
    
    if (!rec.purchasePlace)rec.purchasePlace = @"";
    
    
    // show activity indicator
    self.spinner = [self showActivityIndicatorOnView:self.parentViewController.view];
    
    
    //need to create file with userId and timestamp
    
    NSDate *past = [NSDate date];
    NSTimeInterval oldTime = [past timeIntervalSince1970];
    NSString *timestamp = [[NSString alloc] initWithFormat:@"%0.0f", oldTime];
    
    NSString *fileName = [[NSString alloc] initWithFormat:@"%@_%@.jpg", userStore.userData.userID, timestamp];
    
    
    NSURL *theURL = [NSURL URLWithString:@"http://tyche92.pythonanywhere.com/upload"];
    
    if (!productImage) {
        NSLog(@"ERROR: product Image is NULL");
    }
    
    
    NSData *imageData = UIImagePNGRepresentation(productImage);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:theURL
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:60];
    
    [request setHTTPMethod:@"POST"];
    
    // We need to add a header field named Content-Type with a value that tells that it's a form and also add a boundary.
    // I just picked a boundary by using one from a previous trace, you can just copy/paste from the traces.
    NSString *boundary = @"----WebKitFormBoundarycC4YiaUFwM44F6rT";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    // end of what we've added to the header
    
    // the body of the post
    NSMutableData *body = [NSMutableData data];
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:rec.userName] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@",userStore.userData.userID] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"productname\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:rec.productName] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"text\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:rec.postText] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"rating\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%d", rec.rating] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"purchasePlace\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:rec.purchasePlace] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"purchasePlaceType\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%d", 1] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"ageBand\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%d", rec.ageBand+1] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    // Now we need to append the different data 'segments'. We first start by adding the boundary.
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
    // Now append the image
    // Note that the name of the form field is exactly the same as in the trace ('attachment[file]' in my case)!
    // You can choose whatever filename you want.
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // We now need to tell the receiver what content type we have
    // In my case it's a png image. If you have a jpg, set it to 'image/jpg'
    [body appendData:[[NSString stringWithString:@"Content-Type: image/jpg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Now we append the actual image data
    [body appendData:[NSData dataWithData:imageData]];
    
    // and again the delimiting boundary
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // adding the body we've created to the request
    [request setHTTPBody:body];
    
    [[NSURLConnection alloc] initWithRequest:request
                                    delegate:self
                            startImmediately:YES  ];
    
  
    
}


//NSUrlconnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    // stop spinner
    [spinner stopAnimating];
    
    // enable save button again
    [bbiRight setEnabled:YES];
    
    [self showAlertView:@"Error" andMessage:[error localizedDescription]];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // stop spinner
    [spinner stopAnimating];
    
    // enable save button again
    [bbiRight setEnabled:YES];
    
    // show alert message
    
    //NSLog(@"connectionDidFinishLoading");
    //[self showAlertView:@"Success" andMessage:@"successfully uploaded"];
    
    
    //clear all the information user set 
    [self eraseContent];
    
    // go back to Streamview
    [self.tabBarController setSelectedIndex:0];
    
    
  
    
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    
}
@end
