//
//  RecommendViewController.m
//  StreamTest
//
//  Created by Naehee Kim on 10/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//http://developer.apple.com/library/ios/#documentation/windowsviews/conceptual/UIScrollView_pg/CreatingBasicScrollViews/CreatingBasicScrollViews.html

//http://developer.apple.com/library/ios/#documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html

//UI Actionsheet
//http://agilewarrior.wordpress.com/2012/01/31/how-to-add-an-action-sheet-to-your-iphone-application/

// flip animation
// http://ideiasbynavarro.blogspot.com/2011/09/ios-quick-tips-flip-animation.html
// http://stackoverflow.com/questions/4622996/how-to-do-the-flip-animation-between-two-uiviewcontrollers-while-clicking-info-b

#import <FacebookSDK/FacebookSDK.h>
#import "RecommendViewController.h"
#import "Rec.h"
#import "CameraViewController.h"

#define DataDownloaderRunMode @"myapp.run_mode" 


@implementation RecommendViewController



@synthesize scrollView, postView, photoImage, productField, brandField, storeField, priceField, rec, offset, currentField, imageButton, productImage;

@synthesize saveButton, saveTestButton;

@synthesize cameraButton, cameraRollButton;

@synthesize actionSheet= _actionSheet;

@synthesize barView;

@synthesize userId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // create a new bar button item

        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(upload:)];
        bbi.enabled = NO;
        // set this bar button item as the right item in the navigationItem
        [[self navigationItem] setRightBarButtonItem:bbi];
        
        
        UIBarButtonItem *bbiLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        
        bbiLeft.enabled = YES;
        [[self navigationItem] setLeftBarButtonItem:bbiLeft];

        
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
    
    displayingPrimary = YES;
    
    CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    
    


    
    

    
    scrollView=[[UIScrollView alloc] initWithFrame:fullScreenRect];
    
    
    self.view=scrollView;
    
    scrollView.contentSize=CGSizeMake(320,390);
    
    //scrollView.contentInset=UIEdgeInsetsMake(64.0,0.0,44.0,0.0);
    
    //scrollView.scrollIndicatorInsets=UIEdgeInsetsMake(64.0,0.0,44.0,0.0);
    
    scrollView.backgroundColor = [UIColor whiteColor];
    
    
    
    // do any further configuration to the scroll view
    
    // add a view, or views, as a subview of the scroll view.
    

    

    


    
    
    
    

    
    // TextField
    

    
    CGRect productRect = CGRectMake(120,121,210,25);
    productField = [[UITextField alloc] initWithFrame:productRect];
    productField.placeholder = @"product name";
    productField.font = [UIFont systemFontOfSize:15];
    productField.autocorrectionType = UITextAutocorrectionTypeNo;
    productField.keyboardType = UIKeyboardTypeDefault;
    productField.returnKeyType = UIReturnKeyDone;
    
    [productField addTarget:self action:@selector(setProduct:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [scrollView addSubview:productField];
    
    CGRect brandRect = CGRectMake(120,151,210,25);
    brandField = [[UITextField alloc] initWithFrame:brandRect];
    brandField.placeholder = @"brand name";
    brandField.font = [UIFont systemFontOfSize:15];
    brandField.autocorrectionType = UITextAutocorrectionTypeNo;
    brandField.keyboardType = UIKeyboardTypeDefault;
    brandField.returnKeyType = UIReturnKeyDone;
    
    [brandField addTarget:self action:@selector(setBrand:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [scrollView addSubview:brandField];
    
    CGRect storeRect = CGRectMake(120,181,210,25);
    storeField = [[UITextField alloc] initWithFrame:storeRect];
    storeField.placeholder = @"store name";
    storeField.font = [UIFont systemFontOfSize:15];
    storeField.autocorrectionType = UITextAutocorrectionTypeNo;
    storeField.keyboardType = UIKeyboardTypeDefault;
    storeField.returnKeyType = UIReturnKeyDone;
    
    [storeField addTarget:self action:@selector(setStore:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [scrollView addSubview:storeField];
    
    
    CGRect priceRect = CGRectMake(120,211,210,25);
    priceField = [[UITextField alloc] initWithFrame:priceRect];
    priceField.placeholder = @"price";
    priceField.font = [UIFont systemFontOfSize:15];
    priceField.autocorrectionType = UITextAutocorrectionTypeNo;
    priceField.keyboardType = UIKeyboardTypeDefault;
    priceField.returnKeyType = UIReturnKeyDone;
    
    [priceField addTarget:self action:@selector(setPrice:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [scrollView addSubview:priceField];
    
    
    // post
    
    CGRect postRect = CGRectMake(0, 0, 320, 80);
    postView = [[UITextView alloc] initWithFrame:postRect];
    postView.font = [UIFont systemFontOfSize:15];
    postView.editable = YES;
    postView.delegate = self;
    postView.autocorrectionType = UITextAutocorrectionTypeNo;
    //postView.textAlignment = UITextAlignmentLeft;
    //postView.text = @"write your recommendation";
    postView.backgroundColor = [UIColor lightGrayColor];
    postView.returnKeyType = UIReturnKeyDone;
    
    [scrollView addSubview:postView];
    

        
    imageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [imageButton addTarget:self
                   action:@selector(selectMedium:)
                    forControlEvents:UIControlEventTouchUpInside];
    //[imageButton setTitle:@"Photo" forState:UIControlStateNormal];
    UIImage *uploadPhotoImg = [UIImage imageNamed:@"upload-photo.png"];
    [imageButton setImage:uploadPhotoImg forState:UIControlStateNormal];
    imageButton.frame = CGRectMake(20, 121, 80, 100);
    [scrollView addSubview:imageButton];
    


    
    
    
    // release scrollView as self.view retains it
    
    // ******************
    // ******************
    // what interacitons do users want? what unique interactions are possible?
    // add options: (1) would like to share (2) would like to give for free
    // post & ask option : (1) ask what product is good for me? (2) recommend....
    // express user's sentiment: (1)love (2)hate!
    // category : ...
    // ******************

    

    
    
    
    
    

    

    
    

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // create a recommendation object
    rec = [[Rec alloc] init];
    
    
    //set up navigation controller
    
    
    //facebook data
    [self populateUserDetails];
    
    // register keyboard notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    self.title = @"Recommend";
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

  

    
}


- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWasShown: (NSNotification *)notif{
    
    

    NSDictionary *info = [notif userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    if (!CGRectContainsPoint(aRect, currentField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, currentField.frame.origin.y-kbSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }

    
    /*
    
    NSDictionary* info = [notif userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect bkgndRect = currentField.superview.frame;
    bkgndRect.size.height += kbSize.height;
    [currentField.superview setFrame:bkgndRect];
    [scrollView setContentOffset:CGPointMake(0.0, currentField.frame.origin.y-kbSize.height) animated:YES];
 
    */
}

- (void)keyboardWillBeHidden: (NSNotification *)notif{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    scrollView.contentInset = contentInsets;
    
    scrollView.scrollIndicatorInsets = contentInsets;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    currentField = textField;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{

    currentField = nil;
}

- (void)textFieldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

-(IBAction) setPhoto:(id)sender{
    UIImage *image = photoImage.image;
    [rec setProductImage:image];
    
}
-(IBAction) setProduct:(id)sender{
    NSString *product = productField.text;
    [rec setProductName:product];
    NSLog(@"Product: %@", product);
    
    [self textFieldReturn:sender];
}
-(IBAction) setBrand:(id)sender{
    NSString *brand = brandField.text;
    [rec setBrandName:brand];
    NSLog(@"Brand: %@", brand);
    [self textFieldReturn:sender];
}
-(IBAction) setStore:(id)sender{
    NSString *store = storeField.text;
    [rec setPurchasePlace:store];
    NSLog(@"Store: %@", store);
    
    [self textFieldReturn:sender];
    
}
-(IBAction) setPrice:(id)sender{
    NSString *price = priceField.text;
    [rec setPrice:price];
    NSLog(@"Price: %@", price);
    
    [self textFieldReturn:sender];
}

-(int)sendRecmd{
    
    // user information
    rec.userId = 1;
    rec.userName = @"Rachel";
    
    // recommend information
   
    //rec.postTitle = @"Moist foundation";
    rec.postText = @"It is a new type of foundation and it is so moist~. It leaves the skin nice a luminous, even skin-toned. It is the best foundation I have tried so far. \n";
    
    return 0;
    
}

- (IBAction)selectMedium:(id)sender {
    
    NSLog(@"in select Medium");

        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Medium Option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Camera Roll", nil];
        [actionSheet showInView:self.view];
 

}

- (IBAction)useCamera{
    
    NSLog(@"in useCamera");
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
        newMedia = YES;
    }
    
}

- (void)useCameraRoll{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
        newMedia = NO;
    }
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:YES];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        

        [imageButton setImage:image forState:UIControlStateNormal];
        //[photoImage setImage:image];
        productImage = image;
        NSLog(@"**********PHOTO IS SET***********");
        
        
        if (newMedia) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
        }
        
    }
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


-(IBAction)cancel:(id)sender{
    postView.text = @"";
    productField.text = @"";
    brandField.text = @"";
    storeField.text = @"";
    priceField.text = @"";
    
    UIImage *uploadPhotoImg = [UIImage imageNamed:@"upload-photo.png"];
    [imageButton setImage:uploadPhotoImg forState:UIControlStateNormal];
    
}



+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize{
  
    CGSize scaledSize = newSize;
    float scaleFactor = 1.0;
    

    
    if( image.size.width > image.size.height ) {
        scaleFactor = image.size.height / image.size.width;
        scaledSize.width = newSize.width;
        scaledSize.height = newSize.height * scaleFactor;
    }
    else {
        scaleFactor = image.size.width / image.size.height;
        scaledSize.height = newSize.height;
        scaledSize.width = newSize.width * scaleFactor;
    }
    

    
    UIGraphicsBeginImageContextWithOptions(scaledSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



// upload to webserver

//http://stackoverflow.com/questions/8042360/nsdata-and-uploading-images-via-post-in-ios

// http://jinru.wordpress.com/2010/04/14/iphone-sending-post-file-uploading-with-nsurlconnection/

//http://kelp.phate.org/2012/06/post-picture-to-google-image-search.html

//http://www.iriphon.com/2011/11/09/ios-uploading-an-image-from-your-iphone-to-a-server/

-(void)upload:(id)sender{

    NSLog(@"in upload");
    
    
    //**********
    // if the image is a default image, then don't send this image to the server
    
    // **********
    // **********
    // FOR TEST
    /*
    rec.userId = 1;
    rec.userName = @"Rachel";
    rec.productName = @"cosmetics";
    
    
    //rec.postTitle = @"Moist foundation";
    rec.postText = @"It is a new type of foundation and it is so moist~. It leaves the skin nice a luminous, even skin-toned. It is the best foundation I have tried so far. \n";
    
     */
    
    if (!self.userId) {
        self.userId = @"713673762";
    }
    NSLog(@"UPLOAD: %@", self.userId);
    NSLog(@"UPLOAD: %@", rec.userName);
    NSLog(@"UPLOAD: %@", rec.productName);
    NSLog(@"UPLOAD: %@", rec.postText);

    UIImage *testImage = [UIImage imageNamed:@"bibim.JPG"];
    
    
    //need to create file with userId and timestamp
    
    //
    
    //
    
    //

    NSDate *past = [NSDate date];
    NSTimeInterval oldTime = [past timeIntervalSince1970];
    NSString *timestamp = [[NSString alloc] initWithFormat:@"%0.0f", oldTime];

    NSString *fileName = [[NSString alloc] initWithFormat:@"%@_%@.jpg", self.userId, timestamp];

  
    NSURL *theURL = [NSURL URLWithString:@"http://groups.ischool.berkeley.edu/friendly/upload"];

    if (!productImage) {
        NSLog(@"ERROR: product Image is NULL");
    }
    
    
    // Resize Image

    
    
    // http://stackoverflow.com/questions/2658738/the-simplest-way-to-resize-an-uiimage
    //http://stackoverflow.com/questions/6703502/how-to-resize-an-uiimage-while-maintaining-its-aspect-ratio
    
    //UIImage *uploadImg = photoImage.image;
    
    CGSize smallSize = CGSizeMake(480.0f, 480.0f);
    UIImage *smallImage = [RecommendViewController imageWithImage:productImage  scaledToSize:smallSize];

    
    //convert the image to low resolution
    //set number between 0~1
    //UIImage* lowResImage = [UIImage imageWithData:UIImageJPEGRepresentation(smallImage, 0.8f)];
     
    NSData *imageData = UIImagePNGRepresentation(smallImage);
    

    
    


    
    
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
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"name\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:rec.productName] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"text\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:rec.postText] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
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
                                                                             startImmediately:NO]; 
                       
    [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:DataDownloaderRunMode]; 
                       
    [connection start];

}

// facebook user info

- (void)populateUserDetails
{
    NSLog(@"in populate User Details");
    
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 
                 NSLog(@"user name: %@", user.name);
                 rec.userName = user.name;
                 
             }
         }];
    }
}

#define DO_SOMETHING_ELSE @"Do something else"


- (IBAction)saveTest:(UIButton *)sender {

    
    NSLog(@"in saveTest");
    /*
    if (self.actionSheet) {
        // do nothing
    } else {
     */
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Save Option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"share with all friends", @"share with some friends", @"share with public", nil];
        //[actionSheet showFromBarButtonItem:sender animated:YES];
        //CGRect tmpRect = CGRectMake(230, 2, 70, 40);
        //[actionSheet showFromRect:tmpRect inView:self.view animated:YES];
        [actionSheet showInView:self.view];
    

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *choice = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (buttonIndex == [actionSheet destructiveButtonIndex]) {
        // destroy something
        NSLog(@"Destroy");
    } else if ([choice isEqualToString:@"Camera"]){
        // do something else
        NSLog(@"useCamera");
        [self useCamera];
        
    } else if ([choice isEqualToString:@"Camera Roll"]){
        // do something else
        NSLog(@"use Camera Roll");
        [self useCameraRoll];
        
    }
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



@end
