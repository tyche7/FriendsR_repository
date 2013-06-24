//
//  SettingController.m
//  StreamTest
//
//  Created by Naehee Kim on 10/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "OptionViewController.h"


@implementation OptionViewController


@synthesize menuTableView;
@synthesize scrollView;

@synthesize postView, productField,  purchasePlaceField, rec, userId;
@synthesize ageSegmentedControl, onoffSegmentedControl;
@synthesize productImage;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // create a new bar button item
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonWasPressed:)];
        
        // set this bar button item as the right item in the navigationItem
        [[self navigationItem] setRightBarButtonItem:bbi];
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

- (void)loadView {
        
    CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    
    
    scrollView=[[UIScrollView alloc] initWithFrame:fullScreenRect];
    
    
    self.view=scrollView;
    
    scrollView.contentSize=CGSizeMake(320,390);
    
    //scrollView.contentInset=UIEdgeInsetsMake(64.0,0.0,44.0,0.0);
    
    //scrollView.scrollIndicatorInsets=UIEdgeInsetsMake(64.0,0.0,44.0,0.0);
    
    scrollView.backgroundColor = [UIColor whiteColor];
    
    
    
    // do any further configuration to the scroll view
    
    // add a view, or views, as a subview of the scroll view.
    
    
    // post

    
    
    CGRect postRect = CGRectMake(0, 15, 320, 50);
    postView = [[UITextView alloc] initWithFrame:postRect];
    postView.font = [UIFont systemFontOfSize:15];
    postView.editable = YES;
    postView.delegate = self;
    postView.autocorrectionType = UITextAutocorrectionTypeNo;
    //postView.textAlignment = UITextAlignmentLeft;
    postView.text = @"likes or hates because ...";
    postView.backgroundColor = [UIColor lightGrayColor];
    postView.returnKeyType = UIReturnKeyDone;
    
    [scrollView addSubview:postView];
    
    // TextField

    
    
    NSArray *onoffArray = [NSArray arrayWithObjects: @"online", @"offline", nil];
    onoffSegmentedControl = [[UISegmentedControl alloc] initWithItems:onoffArray];
    onoffSegmentedControl.frame = CGRectMake(0, 80, 150, 25);
    onoffSegmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    onoffSegmentedControl.selectedSegmentIndex = 0;
    
    [scrollView addSubview:onoffSegmentedControl];
    
    
    CGRect purchasePlaceRect = CGRectMake(0,120,150,25);
    purchasePlaceField = [[UITextField alloc] initWithFrame:purchasePlaceRect];
    purchasePlaceField.placeholder = @"purchasePlace (optional)";
    purchasePlaceField.font = [UIFont systemFontOfSize:15];
    purchasePlaceField.autocorrectionType = UITextAutocorrectionTypeNo;
    purchasePlaceField.keyboardType = UIKeyboardTypeDefault;
    purchasePlaceField.returnKeyType = UIReturnKeyDone;
    
    
    [ purchasePlaceField addTarget:self action:@selector(setPurchasePlace:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [scrollView addSubview:purchasePlaceField];
      
    
    NSArray *ageArray = [NSArray arrayWithObjects: @"newborn", @"infant", @"toddler", @"child", nil];
    ageSegmentedControl = [[UISegmentedControl alloc] initWithItems:ageArray];
    ageSegmentedControl.frame = CGRectMake(0, 170, 310, 25);
    ageSegmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    ageSegmentedControl.selectedSegmentIndex = 0;
    
    [scrollView addSubview:ageSegmentedControl];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Optional Information";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
       return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

-(void)saveButtonWasPressed:(id)sender {
    
   
}


- (void)dealloc
{
   
}


// handle user input

- (void)keyboardWasShown: (NSNotification *)notif{
    
    
    
    
}

- (void)keyboardWillBeHidden: (NSNotification *)notif{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    scrollView.contentInset = contentInsets;
    
    scrollView.scrollIndicatorInsets = contentInsets;
    
}


- (void)textFieldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
}



-(IBAction) writePost:(id)sender{
    NSString *post = postView.text;
    [rec setPostText:post];
    NSLog(@"post: %@", post);
    
    
    
}

-(IBAction)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"Begin editing");
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    NSLog(@"DidEndEditing");
    NSString *post = textView.text;
    [rec setPostText:post];
    NSLog(@"post: %@", post);
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    
}



//textview tutorial
// (1)how to remove keyboard when the done button is pressed
// (2)how to put the limitation on the length of text
//http://mobile.tutsplus.com/tutorials/iphone/ios-sdk_uitextview_uitextviewdelegate_2/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    if (textView.text.length + text.length > 140){
        if (location != NSNotFound){
            [textView resignFirstResponder];
        }
        return NO;
    }
    else if (location != NSNotFound){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    NSLog(@"textViewDidChange:");
    NSLog(@"length: %d",textView.text.length);
    NSLog(@"remained length: %d",140-textView.text.length);
}


// upload to webserver

//http://stackoverflow.com/questions/8042360/nsdata-and-uploading-images-via-post-in-ios

// http://jinru.wordpress.com/2010/04/14/iphone-sending-post-file-uploading-with-nsurlconnection/

//http://kelp.phate.org/2012/06/post-picture-to-google-image-search.html

//http://www.iriphon.com/2011/11/09/ios-uploading-an-image-from-your-iphone-to-a-server/

-(void)upload:(id)sender{
    
    
    if (!self.userId) {
        self.userId = @"713673762";
        
    }
    
    // Let's assume Recommend view gets userId, userName information from somewhere
    
    if (!rec.userName){
        rec.userName = @"Naehee";
    }
    
    
    NSLog(@"UPLOAD: %@", self.userId);
    NSLog(@"UPLOAD: %@", rec.userName);
    NSLog(@"UPLOAD: %@", rec.productName);
    NSLog(@"UPLOAD: %@", rec.postText);
    NSLog(@"UPLOAD: %@", rec.purchasePlace);
    
    if (!rec.purchasePlace){
        rec.purchasePlace = @"";
    }
    
    //need to create file with userId and timestamp
    
    NSDate *past = [NSDate date];
    NSTimeInterval oldTime = [past timeIntervalSince1970];
    NSString *timestamp = [[NSString alloc] initWithFormat:@"%0.0f", oldTime];
    
    NSString *fileName = [[NSString alloc] initWithFormat:@"%@_%@.jpg", self.userId, timestamp];
    
    
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
    [body appendData:[[NSString stringWithFormat:@"%@",self.userId] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
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
    [body appendData:[[NSString stringWithFormat:@"%d", [onoffSegmentedControl selectedSegmentIndex]+1] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"ageBand\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%d", [ageSegmentedControl selectedSegmentIndex]+1] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
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
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request
                                                                  delegate:self
                                                          startImmediately:YES  ];
    
    //[connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:DataDownloaderRunMode];
    //[connection start];
    
}


@end
