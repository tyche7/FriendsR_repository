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
#import "PostViewController.h"
#import "Rec.h"
#import "DataFeedStore.h"
#import "CameraViewController.h"
#import "OptionViewController.h"
#import "AgeListViewController.h"
#import "NoteViewController.h"
#import <QuartzCore/QuartzCore.h>

#define DataDownloaderRunMode @"myapp.run_mode" 
#define DO_SOMETHING_ELSE @"Do something else"
#define productFieldTag 10
#define purchaseFieldTag 11
#define ageFieldTag 12
#define noteFieldTag 13


@implementation PostViewController


@synthesize ageController;
@synthesize postView, photoImage, productField, purchasePlaceField, rec, imageButton, productImage, ratingSegmentedControl;
@synthesize cameraButton, cameraRollButton;
@synthesize actionSheet= _actionSheet;
@synthesize barView;
@synthesize userId,ageLabel;
@synthesize bbiRight;
@synthesize productImageisSet;
@synthesize spinner;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        displayMediumChoice = YES;

        
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
    
    // create a recommendation object
    rec = [[Rec alloc] init];
    rec.rating = 0; //love
    rec.ageBand = -1;  //set as -1
    
    
    //set up UIs
    
    
    // post
    
    imageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [imageButton addTarget:self
                    action:@selector(selectMedium:)
          forControlEvents:UIControlEventTouchUpInside];
    //[imageButton setTitle:@"Photo" forState:UIControlStateNormal];
    UIImage *uploadPhotoImg = [UIImage imageNamed:@"upload-photo.png"];
    [imageButton setImage:uploadPhotoImg forState:UIControlStateNormal];
    imageButton.frame = CGRectMake(110, 210, 100, 100);
    [self.view addSubview:imageButton];
    
    
    // TextField
    
    

    
    NSArray *ratingArray = [NSArray arrayWithObjects: [UIImage imageNamed:@"pink_heart2.png"], [UIImage imageNamed:@"broken_heart.png"], nil];
    ratingSegmentedControl = [[UISegmentedControl alloc] initWithItems:ratingArray];
    ratingSegmentedControl.frame = CGRectMake(85, 320, 150, 30);
    ratingSegmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    ratingSegmentedControl.selectedSegmentIndex = 0;
    [ratingSegmentedControl addTarget:self action:@selector(ratingChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:ratingSegmentedControl];

    
    UIBarButtonItem *bbiLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    bbiLeft.enabled = YES;
    [[self navigationItem] setLeftBarButtonItem:bbiLeft];
    
    
    // create a new bar button item
    bbiRight = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonWasPressed:)];
    // set this bar button item as the right item in the navigationItem
    [[self navigationItem] setRightBarButtonItem:bbiRight];
    
    
    // register keyboard notification
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
     */
    
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
    
    if (displayMediumChoice) {
          [self selectMedium:self];
    }
  
}


- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}






-(IBAction)ratingChanged:(UISegmentedControl *)sender{
    
    rec.rating = sender.selectedSegmentIndex;  

}

-(IBAction)cancel:(id)sender{
    
    //dismiss keyboard if it is active
    [self.view endEditing:YES]; 
    
    UITextField* field;
    for (int i=10; i<14; i++) {
        field = (UITextField *)[self.view viewWithTag:i];
        field.text = @"";
    }
    
    //product image is going to be initialized
    productImageisSet = NO;
  
    UIImage *uploadPhotoImg = [UIImage imageNamed:@"upload-photo.png"];
    [imageButton setImage:uploadPhotoImg forState:UIControlStateNormal];
    

    //erase note(description)
    self.noteController.noteTextView.text = @"";

    //set displayMedium
    displayMediumChoice = YES;
    
}



- (IBAction)selectMedium:(id)sender {
    
    NSLog(@"in select Medium");

        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Medium Option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Camera Roll", nil];
        [actionSheet showFromTabBar:self.tabBarController.tabBar];

    // now, set displayMediumChoice NO;
    displayMediumChoice = NO;
 

}




- (IBAction)useCamera{
    
    NSLog(@"in useCamera");
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
        imagePicker.allowsEditing = YES;
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
        imagePicker.allowsEditing = YES;
        [self presentModalViewController:imagePicker animated:YES];
        newMedia = NO;
    }
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    [self dismissModalViewControllerAnimated:YES];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *image =[info objectForKey:UIImagePickerControllerEditedImage];
        

        [imageButton setImage:image forState:UIControlStateNormal];
        //[photoImage setImage:image];
        productImage = image;
        productImageisSet = YES;
    
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

-(void)nextPhase:(id)sender{
    
    OptionViewController* optionController = [[OptionViewController alloc] init];
    optionController.rec = self.rec;
    optionController.productImage =self.productImage;
    [self.navigationController pushViewController:optionController animated:true];
    
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
        
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
        cell.textLabel.clipsToBounds = YES;
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
        cell.detailTextLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.4
                                                         green:0.6
                                                          blue:0.8
                                                         alpha:1];
        cell.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
        cell.detailTextLabel.clipsToBounds = YES;
         
    }

    UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(140, 13, 155, 22)];
    inputTextField.adjustsFontSizeToFitWidth = YES;
    inputTextField.textColor = [UIColor blackColor];
    inputTextField.font = [UIFont systemFontOfSize:13];
    inputTextField.keyboardType = UIKeyboardTypeDefault;
    inputTextField.returnKeyType = UIReturnKeyNext;

    

    //inputTextField.backgroundColor = [UIColor whiteColor];
    inputTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
    //inputTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
    inputTextField.textAlignment = UITextAlignmentLeft;
  
    
    //[inputTextField addTarget:self action:@selector(textFieldIsTouched:) forControlEvents:UIControlEventAllTouchEvents];
    inputTextField.delegate = self;
    
    inputTextField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
    [inputTextField setEnabled: YES];
    
    [cell.contentView addSubview:inputTextField];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Product Name";
            inputTextField.placeholder = @"Required";
            inputTextField.tag = productFieldTag;
            self.productField = inputTextField;
            break;
            
        case 1:
            cell.textLabel.text = @"Purchased At";
            inputTextField.placeholder = @"optional";
            inputTextField.tag = purchaseFieldTag;
            self.purchasePlaceField = inputTextField;
            break;
            
        case 2:
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
            
        case 3:
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
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (indexPath.row == 2){
        
        if(!self.ageController){
            self.ageController = [[AgeListViewController alloc] init];
            self.ageController.delegate = self;
        }
        [self.navigationController pushViewController:self.ageController animated:true];
        
        //dismiss keyboard if it is active
        [self.view endEditing:YES];
        
    }else if (indexPath.row == 3){
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


/*
//setInfo

- (IBAction)setInfo:(UITextField *)textField{
    
    switch (textField.tag) {
        case productFieldTag: //productname
            NSLog(@"productfield is set as %@", textField.text);
            rec.productName = textField.text;
            if ([self allRequiredInfoSet]) {
                bbiRight.enabled = YES;
            }
            break;
        case purchaseFieldTag: //purchase place
            rec.purchasePlace = textField.text;
            break;
        case ageFieldTag: //age
            break;
        case noteFieldTag: //note
            break;
        default:
            break;
    }
    
}
*/





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

//http://stackoverflow.com/questions/8042360/nsdata-and-uploading-images-via-post-in-ios

// http://jinru.wordpress.com/2010/04/14/iphone-sending-post-file-uploading-with-nsurlconnection/

//http://kelp.phate.org/2012/06/post-picture-to-google-image-search.html

//http://www.iriphon.com/2011/11/09/ios-uploading-an-image-from-your-iphone-to-a-server/

-(void)saveButtonWasPressed:(id)sender{
    
    // check if required fields are set right before saving
    // if required filed is set as empty sting
    // show alert message
    
  
        
    NSString* msg;
    if ([productField.text length] == 0) {
        msg = @"Please enter a product name";
        [self showAlertView:@"Message" andMessage:msg];
        return;
    }
    else if (!productImageisSet) {
        msg = @"Please take a photo or choose an existing photo";
        [self showAlertView:@"Message" andMessage:msg];
        return;
    }

    // disable save button for users not to be allowed to tap save button while uploading
    [bbiRight setEnabled:NO];

    
    
    // save data in Rec object
    
    rec.productName = productField.text;
    rec.purchasePlace = purchasePlaceField.text;
    
    // for test **
    
    if (!self.userId) {
        self.userId = @"713673762";
        
    }
    
    if (!rec.userName){
        rec.userName = @"Fake Name";
    }
    
    
    NSLog(@"UPLOAD: %@", self.userId);
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
    
    NSString *fileName = [[NSString alloc] initWithFormat:@"%@_%@.jpg", self.userId, timestamp];
    
    
    NSURL *theURL = [NSURL URLWithString:@"http://groups.ischool.berkeley.edu/friendly/upload"];
    
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
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request
                                                                  delegate:self
                                                          startImmediately:YES  ];
    
    //[connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:DataDownloaderRunMode];
    //[connection start];
    

    
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
    
    NSLog(@"connectionDidFinishLoading");
    [self showAlertView:@"Success" andMessage:@"successfully uploaded"];
    
    
    //clear all the information user set
    [self cancel:self];
    

    
    
    
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    
}
@end
