//
//  RecommendViewController.h
//  StreamTest
//
//  Created by Naehee Kim on 10/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Rec.h"
#import "AgeListViewController.h"
#import "NoteViewController.h"
@class CameraViewController; 



@interface PostViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate, UITableViewDataSource, UITableViewDelegate, AgeListViewControllerDelegate, NoteViewControllerDelegate>{

    BOOL    newMedia;
    BOOL    displayMediumChoice;
    
    
}

@property (nonatomic, strong) AgeListViewController* ageController;
@property (nonatomic, strong) NoteViewController* noteController;

@property (strong, nonatomic) IBOutlet UITableView *infoTableView;

@property (nonatomic, strong) IBOutlet UITextView *postView;
@property (nonatomic, strong) IBOutlet UIImageView *photoImage;
@property (nonatomic, strong) IBOutlet UITextField *productField;
@property (nonatomic, strong) IBOutlet UITextField *purchasePlaceField;
@property (nonatomic, strong) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) UIImage *productImage;


@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) IBOutlet UIButton *cameraRollButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *ratingSegmentedControl;

@property (nonatomic, strong) Rec *rec;


@property (nonatomic, strong) NSString* ageLabel;

@property (nonatomic, weak) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIImageView *barView;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;


@property (nonatomic) CGPoint offset;
@property (nonatomic, strong) UITextField *currentField;

@property (nonatomic, strong) UIActivityIndicatorView *spinner;




@property (strong, nonatomic) IBOutlet UISegmentedControl *onoffSegmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *ageSegmentedControl;


@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) UIBarButtonItem *bbiRight;

@property (nonatomic) BOOL productImageisSet;


- (IBAction)saveButtonWasPressed:(id)sender;

-(IBAction) writePost:(id)sender;
-(IBAction)textViewDidBeginEditing:(UITextView *)textView;

-(IBAction) ratingChanged:(id)sender;
- (IBAction)cancel:(id)sender;


+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

- (IBAction)selectMedium:(id)sender;


- (IBAction)useCamera;
- (IBAction)useCameraRoll;

- (void)showAlertView:(NSString*)title andMessage:(NSString*)msg;

- (UIActivityIndicatorView *)showActivityIndicatorOnView:(UIView*)aView;



@end

