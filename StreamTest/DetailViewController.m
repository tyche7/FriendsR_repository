//
//  DetailViewController.m
//  StreamTest
//
//  Created by Naehee Kim on 10/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"
#import "DataFeedStore.h"
#import "Rec.h"
#import "Comment.h"
#import "UserStore.h"
#import "UserData.h"

@implementation DetailViewController

@synthesize rec, productNameAndPurchasePlace, scrollviewContentHeightExceptCommentTable, postViewHeight;
@synthesize scrollView, detailPicImage, commentTableView;
@synthesize imageView, ratingView, productNameLabel, ageLabel, profileView, nameLabel, postView, commentView, commentTextView, keyboardSize;

#define love 0
#define hate 1
#define CELL_HEIGHT 44
#define DEFAULT_HEIGHT 480
#define DEFAULT_SCR_CNT_HEIGHT 450
#define DEFAULT_CMT_TBL_HEIGHT 44

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


// loadview is called when loading starts

- (void)loadView {
    
    
    [super loadView];
    
    // create scrollView
    
    CGRect scrollRect=CGRectMake(0, 0, 320, DEFAULT_HEIGHT);
    scrollView=[[UIScrollView alloc] initWithFrame:scrollRect];
    
    scrollView.contentSize=CGSizeMake(320,DEFAULT_SCR_CNT_HEIGHT);
    scrollView.contentInset=UIEdgeInsetsMake(0.0,0.0,44.0,0.0);
    scrollView.scrollIndicatorInsets=UIEdgeInsetsMake(0.0,0.0,44.0,0.0);
    
    scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"furley_bg"]];
    
    [self.view addSubview:scrollView];
    //self.view=scrollView;
    
    // add a view, or views, as a subview of the scroll view.
    // Initialization code
    
    // product image - square
    CGRect imageRect = CGRectMake(0, 0, 320, 320);
    imageView = [[UIImageView alloc] initWithFrame:imageRect];
    imageView.image = self.detailPicImage;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:imageView];
    
    // triangle image
    
    CGRect triangleRect = CGRectMake(0, 0, 60, 60);
    UIImageView *triangleView = [[UIImageView alloc] initWithFrame:triangleRect];
    triangleView.image = [UIImage imageNamed:@"triangle.png"];
    triangleView.alpha = 0.5f;
    
    [imageView addSubview:triangleView];
    
    
    // rating image
    CGRect ratingRect = CGRectMake(5, 5, 18, 16);
    ratingView = [[UIImageView alloc] initWithFrame:ratingRect];
    
    [imageView addSubview:ratingView];
    
    // product name and purchase place
    CGRect productNameLabelRect = CGRectMake(20, 340, 280, 20);
    productNameLabel = [[UILabel alloc] initWithFrame:productNameLabelRect];
    productNameLabel.textAlignment = UITextAlignmentLeft;
    productNameLabel.adjustsFontSizeToFitWidth = YES;
    productNameLabel.text = productNameAndPurchasePlace;
    productNameLabel.font = [UIFont boldSystemFontOfSize:15];
    productNameLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:productNameLabel];
    
    
    CGRect ageRect = CGRectMake(20, 360, 280, 20);
    ageLabel = [[UILabel alloc] initWithFrame:ageRect];
    ageLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    ageLabel.backgroundColor = [UIColor clearColor];
    
    [scrollView addSubview:ageLabel];
    
    
    
    // add a line
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 385, scrollView.bounds.size.width-40, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:lineView];
    
    // user's profile photo
    CGRect profileRect = CGRectMake(20, 400, 40, 40);
    
    profileView = [[UIImageView alloc] initWithFrame:profileRect];
    
    
    
    profileView.contentMode = UIViewContentModeScaleAspectFit;
    profileView.layer.cornerRadius = 5.0f;
    profileView.layer.masksToBounds = YES;
    [scrollView addSubview:profileView];
    
    // user's name
    CGRect nameLabelRect = CGRectMake(70,420,200,20);
    nameLabel = [[UILabel alloc] initWithFrame:nameLabelRect];
    nameLabel.textAlignment = UITextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:nameLabel];
    
    // user's note
    CGRect postRect = CGRectMake(20, 445, 280, 0);
    postViewHeight  = 0;
    postView = [[UITextView alloc] initWithFrame:postRect];
    [postView setEditable:NO];
    postView.font = [UIFont fontWithName:@"Helvetica" size:13];
    postView.textAlignment = UITextAlignmentLeft;
    postView.backgroundColor = [UIColor clearColor];
    postView.layer.cornerRadius = 2.0f;
    [scrollView addSubview:postView];
    
    
    
    NSLog(@"purchase place type: %d", rec.purchasePlaceType);
    
    scrollviewContentHeightExceptCommentTable = DEFAULT_SCR_CNT_HEIGHT;
    // add comment Table View
    commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, scrollviewContentHeightExceptCommentTable, 320, DEFAULT_CMT_TBL_HEIGHT) style:UITableViewStylePlain];
    commentTableView.dataSource = self;
    commentTableView.delegate = self;
    commentTableView.scrollEnabled = NO;
    
    
    [self.scrollView addSubview:commentTableView];
    
    
    
    NSLog(@"self view origin y %f", self.view.frame.origin.y);
    NSLog(@"self view height %f", self.view.frame.size.height);
    NSLog(@"%f", self.navigationController.view.frame.size.height);
    
    
    CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    //set y position: fullScreenRect.size.height 460 - navbar height - comment view height
    CGRect commentRect = CGRectMake(0, fullScreenRect.size.height-44-44, 320, 44);
    
    NSLog(@"comment view Frame -at first: y: %f", commentRect.origin.y);
    
    
    commentView = [[UIView alloc] initWithFrame:commentRect];
    commentView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:commentView];
    [self.view bringSubviewToFront:commentView];
    
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendButton addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    sendButton.frame = CGRectMake(240, 6, 70, 31);
    [sendButton setTitle:@"send" forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"topnav_black_button.png"] forState:UIControlStateNormal];
    //[sendButton setBackgroundImage:[UIImage imageNamed:@"buttonHighlighted.png"] forState:UIControlStateHighlighted];
    
    sendButton.titleLabel.textColor = [UIColor whiteColor];
    
    [commentView addSubview:sendButton];
    
    
    
    commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 6, 220, 31)];
    commentTextView.backgroundColor = [UIColor whiteColor];
    commentTextView.text = @"Leave a comment";
    commentTextView.textColor = [UIColor lightGrayColor];
    commentTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    commentTextView.delegate = self;
    
    commentTextView.layer.cornerRadius = 2.0f;
    
    [commentTextView.layer setBorderColor:[UIColor blackColor].CGColor];
    [commentTextView.layer setBorderWidth:0.5f];
    [commentTextView.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    [commentTextView.layer setShadowOpacity:0.5];
    //[commentTextView.layer setShadowRadius:3.0];
    //[commentTextView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    
    [commentView addSubview:commentTextView];
    
    
}

- (void)resizeTableAndScrollViews
{
    
    
    // ********** problem
    // cangnot get tableview hegith as following
    // http://stackoverflow.com/questions/2528073/get-height-of-uitableview-without-scroll-bars
    // when using dynamic height of cell, it is not possible to cacculate table height as it is
    
    //int tableHeight = CELL_HEIGHT * [self.comments count];
    //NSLog(@"comment tableHeight: %d", tableHeight);
    
    [commentTableView layoutIfNeeded];  //calculate the table's layout
    
    float tableHeight = commentTableView.contentSize.height;
    
    NSLog(@" *** Table Height *** : %f", tableHeight);
    
    commentTableView.frame = CGRectMake(0, scrollviewContentHeightExceptCommentTable + postViewHeight +20, 320, tableHeight);
    
    CGSize tobeSize = CGSizeMake(320, scrollviewContentHeightExceptCommentTable + postViewHeight + tableHeight + 80);
    
    scrollView.contentSize=tobeSize;
    
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib
// ViewDidLoad is called when your view loading is finished
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
    
    [self registerForKeyboardNotifications];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

//viewWillAppear is called every time the view appears

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setContent];
    
    [self adjustHeightOfNoteFrame];
    
    
    // show empty table at first ( refresh table)
    
    self.comments = [[NSMutableArray alloc] init];
    
    [[self commentTableView] reloadData];
    [self resizeTableAndScrollViews];
    
    // then go to web to fetch comments, and reload table with comments
    
    [self fetchComments];
    
    // scroll to top
    
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    
    // dissmiss keyboard whenever postview appears
    
    [self.view endEditing:YES];
    
    
}

- (void)registerForKeyboardNotifications

{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
    
}

// Called when the UIKeyboardDidShowNotification is sent.

- (void)keyboardWasShown:(NSNotification*)aNotification

{
    
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    keyboardSize = kbSize;
    
    
    
    
    CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    //set y position: fullScreenRect.size.height 460 - navbar height - comment view height-keyboard height
    commentView.frame = CGRectMake(0, fullScreenRect.size.height-44-44-kbSize.height, 320, 44);  //y: 156
    
    
    
    NSLog(@"After keyboard was shown");
    NSLog(@"comment View : x - %f", commentView.frame.origin.x);
    NSLog(@"comment View : y - %f", commentView.frame.origin.y);
    NSLog(@"comment View : width - %f", commentView.frame.size.width);
    //NSLog(@"comment View : height - %f", commentView. );
    
}



// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    //set y position: fullScreenRect.size.height 460 - navbar height - comment view height
    commentView.frame = CGRectMake(0, fullScreenRect.size.height-44-44, 320, 44);
    
    
    
    NSLog(@"After keyboard was hidden");
    NSLog(@"comment View : y - %f", commentView.frame.origin.y);
    NSLog(@"comment View : height - %f", commentView.frame.size.height);
}


- (void)setContent{
    self.title = rec.productName;
    
    imageView.image = self.detailPicImage;
    
    if (rec.rating == love) {
        ratingView.image = [UIImage imageNamed:@"pink_heart2.png"];
    }else{
        ratingView.image = [UIImage imageNamed:@"broken_heart.png"];
    }
    productNameLabel.text = productNameAndPurchasePlace;
    
    // age range
    if (rec.ageBand != 0){
        
        NSLog(@"age band: %d", rec.ageBand);
        
        NSString *ageRange = [[NSString alloc] init];
        switch (rec.ageBand) {
            case 1: //newborn
                ageRange = @"newborns (~3m)";
                break;
            case 2: //infant
                ageRange = @"infants (3~12m)";
                break;
            case 3: //toddler
                ageRange = @"toddlers (1~4y)";
                break;
            case 4: //kid
                ageRange = @"kids";
                break;
            case 5:  //all ages
                ageRange = @"all ages";
                break;
            case 6:  // Maternity
                ageRange = @"preparing mothers";
                break;
            default:
                break; //do nothing
        }
        
        
        if (rec.rating == love) {
            ageLabel.text = [NSString stringWithFormat:@"Good for %@", ageRange];
        }else{
            ageLabel.text = [NSString stringWithFormat:@"Not Good for %@", ageRange];
        }
        
    }else{
        ageLabel.text = @"";
    }
    
    NSString* urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%d/picture",rec.userId];
    
    NSLog(@"urlstring:%@", urlString);
    [profileView setImageWithURL:[NSURL URLWithString:urlString]
                placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                         options:SDWebImageRefreshCached];
    
    
    nameLabel.text = rec.userName;
    postView.text = rec.postText;
    
    
    
    
    
    
}

- (void)adjustHeightOfNoteFrame{
    
    CGRect frame =  postView.frame;
    frame.size.height = postView.contentSize.height;
    postView.frame = frame;
    
    postViewHeight = postView.contentSize.height;
    
}

- (void)send:(id)sender{
    [commentTextView resignFirstResponder];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
    UITableViewCell *cell = (UITableViewCell*)[tableView
                                               dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *cellUserLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 15)];
        cellUserLable.font = [UIFont systemFontOfSize:11];
        cellUserLable.textColor = [UIColor darkGrayColor];;
        cellUserLable.tag = 10;
        
        [cell.contentView addSubview:cellUserLable];
        
        
        UITextView *cellTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 17, 320, 22)];
        
        cellTextView.font = [UIFont systemFontOfSize:11];
        cellTextView.editable = NO;
        cellTextView.layer.zPosition = 100;
        cellTextView.tag=11;
        
        [cell.contentView addSubview:cellTextView];
        
        
    }
    
    
    
    Comment* cmt = [self.comments objectAtIndex:indexPath.row];
    //NSLog(@"comment: %@", cmt.comment);
    
    UILabel *userLabel = (UILabel *)[cell.contentView viewWithTag:10];
    userLabel.text = cmt.userName;
    
    UITextView *cmtTextView = (UITextView *)[cell.contentView viewWithTag:11];
    cmtTextView.text = cmt.comment;
    
    //resize the height of cellTextview
    CGRect frame = cmtTextView.frame;
    frame.size.height   = cmtTextView.contentSize.height;
    cmtTextView.frame = frame;
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"number of commnets:%d", [self.comments count]);
    return [self.comments count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Comment *cmt = [self.comments objectAtIndex:indexPath.row];
    
    int cell_content_margin = 10;
    
    CGSize constraint = CGSizeMake(320-cell_content_margin*2, 2000.0f);
    
    CGSize size = [cmt.comment sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    //size.height+namelable.height(15)
    
    CGFloat height = MAX(size.height+15+cell_content_margin*2, 44.0f);
    
    NSLog(@"cell height: %f", height);
    
    return height;
}



- (void)fetchComments{
    
    
    //Initiate the request
    
    [[DataFeedStore sharedStore]fetchCommentswithRecommendationId:rec.recId withCompletion:^(NSMutableArray *fetchedComments, NSError *err) {
        // when the request completes, this block will be called.
        
        if (!err){
            
            
            self.comments = fetchedComments;
            
            [[self commentTableView] reloadData];
            [self resizeTableAndScrollViews];
            
        }else{
            //if things went bad, show an alert view
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [av show];
        }
        
    }];
    
}

// TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    [textField resignFirstResponder];
    
    return NO; // We do not want UITextField to insert line-breaks.
}







- (void)postComment:(NSString *) comment{
    
    // if comment is empty string or nil, return
    if(comment.length == 0 || [comment isEqualToString:@"Leave a comment"]) return;
    
    NSString* entryId = rec.recId;
    
    
    [[DataFeedStore sharedStore] saveComment:comment WithEntryId:entryId WithCompletion:^(NSMutableArray* fetchedComments, NSError *err) {
        // when the request completes, this block will be called.
        
        if (!err){
            NSLog(@"posting comment - success");
            
        }else{
            //if things went bad, show an alert view
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [av show];
        }
        
        // need to reload after posting
        [self fetchComments];
        
    }];
    
}


#pragma mark -
#pragma mark TextView Delegate methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView.textColor == [UIColor lightGrayColor]){
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length == 0){
        textView.textColor= [UIColor lightGrayColor];
        textView.text = @"Leave a comment";
        [textView resignFirstResponder];
    }
}



- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    
    NSLog(@"DidEndEditing");
    
    [self postComment:[NSMutableString stringWithString:textView.text]];
    textView.textColor= [UIColor lightGrayColor];
    textView.text = @"Leave a comment";
    
    return TRUE;
}


- (void)textViewDidEndEditing:(UITextView *)textView{
    
    
    
    CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    //set y position: fullScreenRect.size.height 460 - navbar height - comment view height
    CGRect commentRect = CGRectMake(0, fullScreenRect.size.height-44-44, 320, 44);
    commentView.frame = commentRect;
    
    CGRect textViewFrame = textView.frame;
    textViewFrame.size.height = 31.0f;  //initialize the height
    textView.frame = textViewFrame;
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    
    CGRect frame = textView.frame;
    
    NSLog(@" textView.contentSize.height:%f", textView.contentSize.height);
    NSLog(@" frame.size.height:%f", frame.size.height);
    
    if (textView.contentSize.height > frame.size.height) {
        
        
        frame.size.height = textView.contentSize.height;
        textView.frame = frame;
        
        NSLog (@"textview frame height: %f", textView.frame.size.height);
        
        
        CGRect commentViewFrame = commentView.frame;
        commentViewFrame.size.height = textView.contentSize.height;
        CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
        
        
        //set y position: fullScreenRect.size.height 460 - navbar height - comment view height-keyboard height - 20 (padding)
        commentView.frame = CGRectMake(0, fullScreenRect.size.height-44-textView.frame.size.height-keyboardSize.height-20, 320, textView.frame.size.height+20);
        
        
    }
    
    
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    
    
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}


@end
