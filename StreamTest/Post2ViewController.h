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

@protocol Post2ViewControllerDelegate;

@interface Post2ViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate, UITableViewDataSource, UITableViewDelegate, AgeListViewControllerDelegate, NoteViewControllerDelegate>{
    
}


@property (nonatomic, assign) id<Post2ViewControllerDelegate> delegate;

@property (nonatomic, strong) AgeListViewController* ageController;
@property (nonatomic, strong) NoteViewController* noteController;

@property (weak, nonatomic) IBOutlet UITableView *infoTableView;

@property (weak, nonatomic) IBOutlet UITextView *postView;
@property (weak, nonatomic) IBOutlet UITextField *productField;
@property (weak, nonatomic) IBOutlet UITextField *purchasePlaceField;
@property (strong, nonatomic) UIImage *productImage;

@property (nonatomic, strong) Rec *rec;
@property (nonatomic, strong) NSString* ageLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) UIActivityIndicatorView *spinner;

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

@protocol Post2ViewControllerDelegate <NSObject>

-(void)didSave;

@end


