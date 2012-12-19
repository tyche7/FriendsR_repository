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

#import <FacebookSDK/FacebookSDK.h>
#import "RecommendViewController.h"
#import "Rec.h"
#import "CameraViewController.h"


@implementation RecommendViewController

@synthesize primaryView, secondaryView;

@synthesize scrollView, postView, photoImage, productField, brandField, storeField, priceField, rec, offset, currentField, imageButton, imageView, productImage;

@synthesize saveButton, saveTestButton;

@synthesize cameraButton, cameraRollButton;

@synthesize actionSheet= _actionSheet;

@synthesize barView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // create a new bar button item

        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTest:)];
        
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
    
    displayingPrimary = YES;
    
    CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    
    

   
    // *****
    //set up primary view - text method
    // *****

    
    

    
    scrollView=[[UIScrollView alloc] initWithFrame:fullScreenRect];
    
    primaryView = secondaryView;
    
    self.view=scrollView;
    
    scrollView.contentSize=CGSizeMake(320,390);
    
    //scrollView.contentInset=UIEdgeInsetsMake(64.0,0.0,44.0,0.0);
    
    //scrollView.scrollIndicatorInsets=UIEdgeInsetsMake(64.0,0.0,44.0,0.0);
    
    scrollView.backgroundColor = [UIColor whiteColor];
    
    
    
    // do any further configuration to the scroll view
    
    // add a view, or views, as a subview of the scroll view.
    

    

    


    
    
    
    

    
    // Initialization code
    // labels
    
    CGRect productLabelRect = CGRectMake(20,161,80,21);
    UILabel *productLabel = [[UILabel alloc] initWithFrame:productLabelRect];
    productLabel.textAlignment = UITextAlignmentRight;
    productLabel.text = @"Product";
    productLabel.font = [UIFont boldSystemFontOfSize:15];
    
    [scrollView addSubview:productLabel];
    
    CGRect brandLabelRect = CGRectMake(20,194,80,21);
    UILabel *brandLabel = [[UILabel alloc] initWithFrame:brandLabelRect];
    brandLabel.textAlignment = UITextAlignmentRight;
    brandLabel.text = @"Brand";
    brandLabel.font = [UIFont boldSystemFontOfSize:15];
    
    [scrollView addSubview:brandLabel];
    
    
    CGRect storeLabelRect = CGRectMake(20,227,80,21);
    UILabel *storeLabel = [[UILabel alloc] initWithFrame:storeLabelRect];
    storeLabel.textAlignment = UITextAlignmentRight;
    storeLabel.text = @"Store";
    storeLabel.font = [UIFont boldSystemFontOfSize:15];
    
    [scrollView addSubview:storeLabel];
    
    CGRect priceLabelRect = CGRectMake(20,260,80,21);
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:priceLabelRect];
    priceLabel.textAlignment = UITextAlignmentRight;
    priceLabel.text = @"Price";
    priceLabel.font = [UIFont boldSystemFontOfSize:15];
    
    [scrollView addSubview:priceLabel];
    
    // TextField
    

    
    CGRect productRect = CGRectMake(120,161,210,30);
    productField = [[UITextField alloc] initWithFrame:productRect];
    productField.placeholder = @"product name";
    productField.font = [UIFont systemFontOfSize:15];
    productField.autocorrectionType = UITextAutocorrectionTypeNo;
    productField.keyboardType = UIKeyboardTypeDefault;
    productField.returnKeyType = UIReturnKeyDone;
    
    [productField addTarget:self action:@selector(setProduct:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [scrollView addSubview:productField];
    
    CGRect brandRect = CGRectMake(120,194,210,30);
    brandField = [[UITextField alloc] initWithFrame:brandRect];
    brandField.placeholder = @"brand name";
    brandField.font = [UIFont systemFontOfSize:15];
    brandField.autocorrectionType = UITextAutocorrectionTypeNo;
    brandField.keyboardType = UIKeyboardTypeDefault;
    brandField.returnKeyType = UIReturnKeyDone;
    
    [brandField addTarget:self action:@selector(setBrand:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [scrollView addSubview:brandField];
    
    CGRect storeRect = CGRectMake(120,227,210,30);
    storeField = [[UITextField alloc] initWithFrame:storeRect];
    storeField.placeholder = @"store name";
    storeField.font = [UIFont systemFontOfSize:15];
    storeField.autocorrectionType = UITextAutocorrectionTypeNo;
    storeField.keyboardType = UIKeyboardTypeDefault;
    storeField.returnKeyType = UIReturnKeyDone;
    
    [storeField addTarget:self action:@selector(setStore:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [scrollView addSubview:storeField];
    
    
    CGRect priceRect = CGRectMake(120,260,210,30);
    priceField = [[UITextField alloc] initWithFrame:priceRect];
    priceField.placeholder = @"price";
    priceField.font = [UIFont systemFontOfSize:15];
    priceField.autocorrectionType = UITextAutocorrectionTypeNo;
    priceField.keyboardType = UIKeyboardTypeDefault;
    priceField.returnKeyType = UIReturnKeyDone;
    
    [priceField addTarget:self action:@selector(setPrice:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [scrollView addSubview:priceField];
    
    
    // post
    
    CGRect postRect = CGRectMake(20, 60, 280, 80);
    postView = [[UITextView alloc] initWithFrame:postRect];
    postView.font = [UIFont systemFontOfSize:15];
    postView.editable = YES;
    postView.delegate = self;
    postView.autocorrectionType = UITextAutocorrectionTypeNo;
    //postView.textAlignment = UITextAlignmentLeft;
    //postView.text = @"write your recommendation";
    postView.backgroundColor = [UIColor lightGrayColor];
    
    [scrollView addSubview:postView];
    

        
        imageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [imageButton addTarget:self
                   action:@selector(toggleMainViews:)
         forControlEvents:UIControlEventTouchUpInside];
        [imageButton setTitle:@"Photo" forState:UIControlStateNormal];
        imageButton.frame = CGRectMake(20, 2, 70, 40);
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

    
        
    // *****
    //set up secondary view - text method
    // *****
    
    secondaryView = [[UIView alloc] initWithFrame:fullScreenRect];
    [secondaryView setBackgroundColor:[UIColor whiteColor]];
    
    
    
    // image

     CGRect imageRect = CGRectMake(0, 0, 300, 350);
     imageView = [[UIImageView alloc] initWithFrame:imageRect];
     imageView.image = [UIImage imageNamed:@"hera_foundation.jpg"];
     //imageView.image = [UIImage imageWithContentsOfFile:image-path];
     imageView.contentMode = UIViewContentModeScaleAspectFit;
     [secondaryView addSubview:imageView];
    
    
    cameraButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cameraButton setBackgroundColor:[UIColor whiteColor]];
    [cameraButton addTarget:self
                    action:@selector(useCamera:)
          forControlEvents:UIControlEventTouchUpInside];
    [cameraButton setTitle:@"Camera" forState:UIControlStateNormal];
    cameraButton.frame = CGRectMake(13, 360, 80, 44);
    [secondaryView addSubview:cameraButton];


    cameraRollButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cameraRollButton addTarget:self
                    action:@selector(useCameraRoll:)
          forControlEvents:UIControlEventTouchUpInside];
    [cameraRollButton setTitle:@"Camera Roll" forState:UIControlStateNormal];
    cameraRollButton.frame = CGRectMake(100, 360, 112, 44);
    [secondaryView addSubview:cameraRollButton];
    
    saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [saveButton setBackgroundColor:[UIColor whiteColor]];
    [saveButton addTarget:self
                   action:@selector(upload:)
           forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    saveButton.frame = CGRectMake(240, 360, 80, 44);
    [secondaryView addSubview:saveButton];
    
    

    
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
    
    self.title = @"Post";
    
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

- (IBAction)toggleMainViews:(id)sender {
    
    displayingPrimary = YES;
    
    [UIView transitionFromView:(displayingPrimary ? primaryView : secondaryView)
     
                        toView:(displayingPrimary ? secondaryView : primaryView)
     
                      duration:1.0
     
                       options:(displayingPrimary ? UIViewAnimationOptionTransitionFlipFromRight :
                                
                                UIViewAnimationOptionTransitionFlipFromLeft)
                                //|UIViewAnimationOptionShowHideTransitionViews
     
                    completion:^(BOOL finished) {
                        
                        if (finished) {
                            
                            if (displayingPrimary) self.view = secondaryView;
                            else self.view = primaryView;
                            
                            displayingPrimary = !displayingPrimary;
                            
                            
                        }
                        
                        
                        
                    }];
    
}
- (IBAction)useCamera:(id)sender{
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

- (void)useCameraRoll:(id)sender{
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
        
        imageView.image = image;
        productImage = image;
        
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


// upload to webserver

//http://stackoverflow.com/questions/8042360/nsdata-and-uploading-images-via-post-in-ios

// http://jinru.wordpress.com/2010/04/14/iphone-sending-post-file-uploading-with-nsurlconnection/

//http://kelp.phate.org/2012/06/post-picture-to-google-image-search.html

-(void)upload:(id)sender{

    NSLog(@"in upload");
    
    
    //NSData* fileData = [[NSData alloc] initWithContentsOfFile:filePath;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://localhost:5000/upload"]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"0xKhTmLbOuNdArY";
    // This is important! //NSURLConnection is very sensitive to format.
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
                        
    
    NSMutableData *body = [NSMutableData data];
                        
    //for file
    /*
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"param1\"; filename=\"thefilename\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:fileData]];
    */
    
    NSData *imageData = UIImageJPEGRepresentation(productImage, 1.0);
    
    /*
    // add image data
    [body appendData:[[NSString stringWithFormat:@"--%@\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\n", rec.productName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\n\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[[NSString stringWithFormat:@"\n--%@--\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                        
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    */
    //for string parameter
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:rec.userName] dataUsingEncoding:NSUTF8StringEncoding]];
                        
    //for string parameter
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"name\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:rec.productName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
                        
    //for string parameter
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"text\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:rec.postText] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                                           
                        
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // now lets make the connection to the web
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

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
    if (self.actionSheet) {
        // do nothing
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Save Option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"share with all friends", @"share with some friends", @"share with public", nil];
        //[actionSheet showFromBarButtonItem:sender animated:YES];
        //CGRect tmpRect = CGRectMake(230, 2, 70, 40);
        //[actionSheet showFromRect:tmpRect inView:self.view animated:YES];
        [actionSheet showInView:self.view];
    
}
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *choice = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (buttonIndex == [actionSheet destructiveButtonIndex]) {
        // destroy something
        NSLog(@"Destroy");
    } else if ([choice isEqualToString:DO_SOMETHING_ELSE]){
        // do something else
        NSLog(@"Do something else");
    }
}



@end
