//
//  Post1ViewController.m
//  StreamTest
//
//  Created by Naehee Kim on 4/30/13.
//
//

//
//  RecommendViewController.m
//  StreamTest
//
//  Created by Naehee Kim on 10/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import "Post1ViewController.h"
#import "Post2ViewController.h"
#import "Rec.h"
#import "DataFeedStore.h"
#import "UserStore.h"
#import "UserData.h"
#import "CameraViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation Post1ViewController


@synthesize photoImage, productNameField,  rec, imageButton, productImage, ratingSegmentedControl;
//@synthesize cameraButton, cameraRollButton;
@synthesize actionSheet= _actionSheet;
@synthesize bbiRight;
@synthesize productImageisSet;


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
    
                       
    // Rating
    
    NSArray *ratingArray = [NSArray arrayWithObjects: [UIImage imageNamed:@"pink_heart2.png"], [UIImage imageNamed:@"broken_heart.png"], nil];
    ratingSegmentedControl = [[UISegmentedControl alloc] initWithItems:ratingArray];
    ratingSegmentedControl.frame = CGRectMake(20, 128, 280, 44);
    ratingSegmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    ratingSegmentedControl.selectedSegmentIndex = 0;
    [ratingSegmentedControl addTarget:self action:@selector(ratingChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:ratingSegmentedControl];
    
    
    UIBarButtonItem *bbiLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    bbiLeft.enabled = YES;
    [[self navigationItem] setLeftBarButtonItem:bbiLeft];
    
    
    // create a new bar button item
    bbiRight = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextButtonWasPressed:)];
    // set this bar button item as the right item in the navigationItem
    [[self navigationItem] setRightBarButtonItem:bbiRight];
    
    
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
    
    // dissmiss keyboard whenever postview appears
    
    [self.view endEditing:YES];
    
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
    
    [self eraseContent];
    
    // go back to Streamview
    [self.tabBarController setSelectedIndex:0];
    
}

-(void)eraseContent{
    
    //dismiss keyboard if it is active
    [self.view endEditing:YES];
    
    [self.productNameField setText:@""];
    
    //product image is going to be initialized
    productImageisSet = NO;
    
    UIImage *uploadPhotoImg = [UIImage imageNamed:@"upload-photo.png"];
    [imageButton setImage:uploadPhotoImg forState:UIControlStateNormal];
    
    // set rating segment as love
    ratingSegmentedControl.selectedSegmentIndex = 0;
    
    
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

-(void)nextButtonWasPressed:(id)sender{


     NSString* msg;
    if ([productNameField.text length] == 0) {
        msg = @"Please enter a product name";
        [self showAlertView:@"Message" andMessage:msg];
        return;
    }   
    
    else if (!productImageisSet) {
        msg = @"Please take a photo or choose an existing photo";
        [self showAlertView:@"Message" andMessage:msg];
        return;
    }
    
    rec.productName = productNameField.text;
    
    Post2ViewController* post2viewController = [[Post2ViewController alloc] init];
    post2viewController.rec = self.rec;
    post2viewController.productImage =self.productImage;
    post2viewController.delegate = self;
    [self.navigationController pushViewController:post2viewController animated:true];
    
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



//http://stackoverflow.com/questions/1347779/how-to-navigate-through-textfields-next-done-buttons
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{


        // Not found, so remove keyboard.
        [textField resignFirstResponder];
        NSLog(@"resign first responder");
        rec.productName = textField.text;
        NSLog(@"productname: %@", rec.productName);

    return NO; // We do not want UITextField to insert line-breaks.
}


//This method is called after the text field resigns its first responder status
-(void)textFieldDidEndEditing:(UITextField *)textField{
    //[self setInfo:textField];
    
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

// implement delegate method
- (void)didSave{
    [self eraseContent];
}


@end

