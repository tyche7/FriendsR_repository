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

@synthesize originalHeight, rec, productNameAndPurchasePlace;
@synthesize scrollView, detailPicImage, commentTableView;
@synthesize imageView, ratingView, productNameLabel, ageLabel, profileView, nameLabel, postView, commentView;

#define love 0
#define hate 1
#define CELL_HEIGHT 44
#define DEFAULT_HEIGHT 480

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

// reference: http://developer.apple.com/library/ios/#documentation/WindowsViews/Conceptual/UIScrollView_pg/CreatingBasicScrollViews/CreatingBasicScrollViews.html
// Implement loadView to create a view hierarchy programmatically, without using a nib
// loadview is called when loading starts

- (void)loadView {
    
    
     [super loadView];
   
    // create scrollView
    
    CGRect scrollRect=CGRectMake(0, 0, 320, DEFAULT_HEIGHT);
    scrollView=[[UIScrollView alloc] initWithFrame:scrollRect];
    
    scrollView.contentSize=CGSizeMake(320,DEFAULT_HEIGHT);
    //scrollView.contentInset=UIEdgeInsetsMake(64.0,0.0,44.0,0.0);
    //scrollView.scrollIndicatorInsets=UIEdgeInsetsMake(64.0,0.0,44.0,0.0);
    
    scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"furley_bg"]];
    
    [self.view addSubview:scrollView];
    //self.view=scrollView;
    
    // add a view, or views, as a subview of the scroll view.
   // Initialization code
    
    // reference this if you want to resize your image
    // http://stackoverflow.com/questions/8701751/uiimageview-change-size-to-image-size
    // at this point, I assume that the image size from server has only one size
    
    // product image - square
    CGRect imageRect = CGRectMake(0, 0, 320, 320);
    imageView = [[UIImageView alloc] initWithFrame:imageRect];
    imageView.image = self.detailPicImage;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:imageView];
    
    // rating image
    CGRect ratingRect = CGRectMake(5, 5, 18, 16);
    ratingView = [[UIImageView alloc] initWithFrame:ratingRect];

    [scrollView addSubview:ratingView];
    
    // product name and purchase place
    CGRect productNameLabelRect = CGRectMake(20, 340, 280, 20);
    productNameLabel = [[UILabel alloc] initWithFrame:productNameLabelRect];
    productNameLabel.textAlignment = UITextAlignmentLeft;
    productNameLabel.adjustsFontSizeToFitWidth = YES;
    productNameLabel.text = productNameAndPurchasePlace;
    productNameLabel.font = [UIFont boldSystemFontOfSize:15];
    productNameLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:productNameLabel];
    

        
        NSLog(@"age band: %d", rec.ageBand);
        

        
        CGRect ageRect = CGRectMake(20, 360, 280, 20);
        ageLabel = [[UILabel alloc] initWithFrame:ageRect];
        ageLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        


        ageLabel.backgroundColor = [UIColor clearColor];
        
        [scrollView addSubview:ageLabel];
        

    
    // add a line
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 385, scrollView.bounds.size.width-40, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [scrollView addSubview:lineView];
    
    // user's profile photo
    CGRect profileRect = CGRectMake(20, 400, 40, 40);
    
    profileView = [[UIImageView alloc] initWithFrame:profileRect];

    

    profileView.contentMode = UIViewContentModeScaleAspectFit;
    profileView.layer.cornerRadius = 5.0f;
    profileView.layer.masksToBounds = YES;
    [scrollView addSubview:profileView];
    
    // user's name
    CGRect nameLabelRect = CGRectMake(70,400,200,20);
    nameLabel = [[UILabel alloc] initWithFrame:nameLabelRect];
    nameLabel.textAlignment = UITextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:nameLabel];
    
    // user's note  
    CGRect postRect = CGRectMake(70, 420, 240, 150);
    postView = [[UITextView alloc] initWithFrame:postRect];
    [postView setEditable:NO];
    postView.font = [UIFont fontWithName:@"Helvetica" size:13];
    postView.textAlignment = UITextAlignmentLeft;
    postView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:postView];
    

    
    NSLog(@"purchase place type: %d", rec.purchasePlaceType);
    


    originalHeight = 600;
    if (rec.ageBand !=0) originalHeight -= 20; // - heigh of ageRect
    
    
    NSLog(@"scrollview original height:%d", originalHeight);
    scrollView.contentSize=CGSizeMake(320,originalHeight);
    
    NSLog(@"self view origin y %f", self.view.frame.origin.y);
    NSLog(@"self view height %f", self.view.frame.size.height);
    NSLog(@"%f", self.navigationController.view.frame.size.height);
    CGRect commentRect = CGRectMake(0, self.view.frame.origin.y +self.view.frame.size.height - 104, 320, 44);
    
    commentView = [[UIView alloc] initWithFrame:commentRect];
    commentView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:commentView];
    
    UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 155, 22)];
    inputTextField.backgroundColor = [UIColor whiteColor];
    inputTextField.textColor = [UIColor blackColor];
    inputTextField.font = [UIFont systemFontOfSize:12];
    inputTextField.placeholder = @"Leave a comment";
    inputTextField.keyboardType = UIKeyboardTypeDefault;
    inputTextField.returnKeyType = UIReturnKeyNext;
    inputTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
    inputTextField.textAlignment = UITextAlignmentLeft;
    inputTextField.delegate = self;
    
    
    inputTextField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
    
    
    [commentView addSubview:inputTextField];
    
    
    
    
    
    
    
    
    
}

- (void)renderTable
{
    
    int tableHeight = CELL_HEIGHT * [self.comments count];
    NSLog(@"comment tableHeight: %d", tableHeight);
    
    scrollView.contentSize=CGSizeMake(320, originalHeight+tableHeight+50);
    
    commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, originalHeight+50, 320, tableHeight) style:UITableViewStylePlain];
    commentTableView.dataSource = self;
    commentTableView.delegate = self;
    
    [self.scrollView addSubview:commentTableView];
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib
// ViewDidLoad is called when your view loading is finished
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"furley_bg"]];
    
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
    
    
    
    
    
    
    
    self.comments = [[NSMutableArray alloc] init];
    
    // web connection
    
    [self fetchComments];
    
    
    NSLog(@"content size HEIGHT: %f", commentTableView.contentSize.height);
    
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
    
    
    //CGRect aRect = commentView.frame
    commentView.frame = CGRectMake(0, self.view.frame.origin.y + self.view.frame.size.height -44-kbSize.height, 320, 44);


    
}



// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification

{
     commentView.frame = CGRectMake(0, self.view.frame.origin.y +self.view.frame.size.height - 44, 320, 44);

    
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        //cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
        //cell.textLabel.clipsToBounds = YES;
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.4
                                                         green:0.6
                                                          blue:0.8
                                                         alpha:1];
        cell.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
        cell.detailTextLabel.clipsToBounds = YES;
    }
    
    Comment* cmt = [self.comments objectAtIndex:indexPath.row];
    NSLog(@"comment: %@", cmt.comment);

    cell.textLabel.text = cmt.comment;
    cell.detailTextLabel.text = cmt.userName;

    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"number of commnets:%d", [self.comments count]);
    return [self.comments count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}



- (void)fetchComments{
    //Initiate the request
    
    [[DataFeedStore sharedStore]fetchCommentswithRecommendationId:rec.recId withCompletion:^(NSMutableArray *fetchedComments, NSError *err) {
        // when the request completes, this block will be called.
        
        if (!err){
            
        
            self.comments = fetchedComments;
            [self renderTable];
            [[self commentTableView] reloadData];
            
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


//This method is called after the text field resigns its first responder status
-(void)textFieldDidEndEditing:(UITextField *)textField{

    [self postComment:[NSMutableString stringWithString:textField.text]];
    textField.text = @"";
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textfiled should begin edi");
    
    return YES;
}




- (void)postComment:(NSString *) comment{
    
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
        //[[self tableView] reloadData];
        
    }];
    
}


@end
