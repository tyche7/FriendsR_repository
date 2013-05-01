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

@interface Post2ViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate, UITableViewDataSource, UITableViewDelegate, AgeListViewControllerDelegate, NoteViewControllerDelegate>{
    
}

@property (nonatomic, strong) AgeListViewController* ageController;
@property (nonatomic, strong) NoteViewController* noteController;

@property (strong, nonatomic) IBOutlet UITableView *infoTableView;

@property (nonatomic, strong) IBOutlet UITextView *postView;
@property (nonatomic, strong) IBOutlet UITextField *productField;
@property (nonatomic, strong) IBOutlet UITextField *purchasePlaceField;
@property (strong, nonatomic) UIImage *productImage;

@property (nonatomic, strong) Rec *rec;
@property (nonatomic, strong) NSString* ageLabel;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@property (strong, nonatomic) UIBarButtonItem *bbiRight;

- (IBAction)saveButtonWasPressed:(id)sender;

-(IBAction) writePost:(id)sender;
-(IBAction)textViewDidBeginEditing:(UITextView *)textView;

- (IBAction)cancel:(id)sender;
- (void)eraseContent;

+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;


- (void)showAlertView:(NSString*)title andMessage:(NSString*)msg;

- (UIActivityIndicatorView *)showActivityIndicatorOnView:(UIView*)aView;



@end

