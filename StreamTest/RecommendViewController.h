//
//  RecommendViewController.h
//  StreamTest
//
//  Created by Naehee Kim on 10/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Rec.h"
@class CameraViewController;



@interface RecommendViewController : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>{
    BOOL    displayKeyboard;
    BOOL    displayingPrimary;
    BOOL    newMedia;
}



@property (nonatomic, strong) IBOutlet UIView *primaryView;
@property (nonatomic, strong) IBOutlet UIView *secondaryView;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UITextView *postView;
@property (nonatomic, strong) IBOutlet UIImageView *photoImage;
@property (nonatomic, strong) IBOutlet UITextField *productField;
@property (nonatomic, strong) IBOutlet UITextField *brandField;
@property (nonatomic, strong) IBOutlet UITextField *storeField;
@property (nonatomic, strong) IBOutlet UITextField *priceField;
@property (nonatomic, strong) IBOutlet UIButton *imageButton;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *productImage;

@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) IBOutlet UIButton *cameraRollButton;

@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *saveTestButton;

@property (nonatomic) CGPoint offset;
@property (nonatomic, strong) UITextField *currentField;

@property (nonatomic, strong) Rec *rec;

@property (nonatomic, weak) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIImageView *barView;

-(IBAction) writePost:(id)sender;
-(IBAction)textViewDidBeginEditing:(UITextView *)textView;
-(IBAction) setPhoto:(id)sender;
-(IBAction) setProduct:(id)sender;
-(IBAction) setBrand:(id)sender;
-(IBAction) setStore:(id)sender;
-(IBAction) setPrice:(id)sender;

- (IBAction)toggleMainViews:(id)sender;
- (IBAction)saveTest:(UIButton *)sender;

- (int)sendRecmd;
- (IBAction)useCamera:(id)sender;
- (IBAction)useCameraRoll:(id)sender;


- (void)populateUserDetails;

@end
