//
//  SettingController.h
//  StreamTest
//
//  Created by Naehee Kim on 10/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Rec.h"

@interface OptionViewController : UIViewController 



@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UITextView *postView;
@property (nonatomic, strong) IBOutlet UIImageView *photoImage;
@property (nonatomic, strong) IBOutlet UITextField *productField;

@property (nonatomic) CGPoint offset;
@property (nonatomic, strong) UITextField *currentField;

@property (strong, nonatomic) UIImage *productImage;

@property (nonatomic, strong) IBOutlet UITextField *purchasePlaceField;

@property (nonatomic, strong) IBOutlet UIButton *imageButton;


@property (strong, nonatomic) IBOutlet UISegmentedControl *onoffSegmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *ageSegmentedControl;


@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UITableView *menuTableView;

@property (nonatomic, strong) Rec *rec;
@property (nonatomic, strong) NSString* userId;


- (IBAction)saveButtonWasPressed:(id)sender;

-(IBAction) writePost:(id)sender;
-(IBAction)textViewDidBeginEditing:(UITextView *)textView;

-(IBAction) ratingChanged:(id)sender;
- (IBAction)cancel:(id)sender;




@end
