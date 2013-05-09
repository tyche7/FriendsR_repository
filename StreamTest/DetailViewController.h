//
//  DetailViewController.h
//  StreamTest
//
//  Created by Naehee Kim on 10/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Rec;
@class Comment;

@interface DetailViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) int scrollviewContentHeightExceptCommentTable;
@property (nonatomic) int postViewHeight;
@property (nonatomic, strong) Rec *rec;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImage *detailPicImage;
@property (nonatomic, strong) UITableView *commentTableView;
@property (nonatomic, strong) NSString *productNameAndPurchasePlace;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *ratingView;
@property (nonatomic, strong)  UILabel *productNameLabel;
@property (nonatomic, strong)  UILabel *ageLabel;
@property (nonatomic, strong) UIImageView *profileView;
@property (nonatomic, strong)  UILabel *nameLabel;
@property (nonatomic, strong) UITextView *postView;
@property (nonatomic, strong) UIView *commentView;
@property (nonatomic, strong) UITextView *commentTextView;

@property (nonatomic) CGSize keyboardSize;



- (void)resizeTableAndScrollViews;

- (void)postComment:(NSString *) comment;

- (void)send:(id)sender;

- (void)adjustHeightOfNoteFrame;
//- (void)djustHeightOfScrollViewFrame;

@end
