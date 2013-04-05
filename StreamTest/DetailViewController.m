//
//  DetailViewController.m
//  StreamTest
//
//  Created by Naehee Kim on 10/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "DetailViewController.h"
#import "DataFeedStore.h"
#import "Rec.h"
#import "Comment.h"
#import "UserStore.h"
#import "UserData.h"

@implementation DetailViewController

@synthesize originalHeight, rec, productNameAndPurchasePlace;
@synthesize scrollView, detailPicImage, commentTableView;

#define love 0
#define hate 1
#define CELL_HEIGHT 44
#define DEFAULT_TABLE_HEIGHT 480

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
    
   
    // create scrollView
    
    CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    scrollView=[[UIScrollView alloc] initWithFrame:fullScreenRect];
    
    scrollView.contentSize=CGSizeMake(320,DEFAULT_TABLE_HEIGHT);
    //scrollView.contentInset=UIEdgeInsetsMake(64.0,0.0,44.0,0.0);
    scrollView.scrollIndicatorInsets=UIEdgeInsetsMake(64.0,0.0,44.0,0.0);
    //scrollView.backgroundColor = [UIColor whiteColor];
    
    scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"furley_bg"]];
    
    self.view=scrollView;
    
    // add a view, or views, as a subview of the scroll view.
   // Initialization code
    
    // reference this if you want to resize your image
    // http://stackoverflow.com/questions/8701751/uiimageview-change-size-to-image-size
    // at this point, I assume that the image size from server has only one size
    
    // product image - square
    CGRect imageRect = CGRectMake(0, 0, 320, 320);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageRect];
    imageView.image = self.detailPicImage;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:imageView];
    
    // rating image
    CGRect ratingRect = CGRectMake(0, 0, 50, 50);
    UIImageView *ratingView = [[UIImageView alloc] initWithFrame:ratingRect];
    if (rec.rating == love) {
            ratingView.image = [UIImage imageNamed:@"love.png"];
    }else{
            ratingView.image = [UIImage imageNamed:@"hate.png"];
    }
    [scrollView addSubview:ratingView];
    
    // product name and purchase place
    CGRect productNameLabelRect = CGRectMake(20, 340, 280, 20);
    UILabel *productNameLabel = [[UILabel alloc] initWithFrame:productNameLabelRect];
    productNameLabel.textAlignment = UITextAlignmentLeft;
    productNameLabel.adjustsFontSizeToFitWidth = YES;
    productNameLabel.text = productNameAndPurchasePlace;
    productNameLabel.font = [UIFont boldSystemFontOfSize:15];
    productNameLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:productNameLabel];
    
    
  /*
    if (rec.purchasePlace && ![rec.purchasePlace isEqualToString:@"None"]) {
        
        
        CGRect infoRect2 = CGRectMake(10, 300, 300, 20);
        UILabel *infoLabel2 = [[UILabel alloc] initWithFrame:infoRect2];
        infoLabel2.font = [UIFont fontWithName:@"Helvetica" size:14];
        infoLabel2.text = [NSString stringWithFormat:@"Purchase Place: %@", rec.purchasePlace];
        
        [scrollView addSubview:infoLabel2];
        
    }
    */
    
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
        
        
        CGRect ageRect = CGRectMake(20, 360, 280, 20);
        UILabel *ageLabel = [[UILabel alloc] initWithFrame:ageRect];
        ageLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        ageLabel.text = [NSString stringWithFormat:@"Good for %@", ageRange];
        ageLabel.backgroundColor = [UIColor clearColor];
        
        [scrollView addSubview:ageLabel];
        
    }
    
    // add a line
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 385, scrollView.bounds.size.width-40, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [scrollView addSubview:lineView];
    
    // user's profile photo
    CGRect profileRect = CGRectMake(20, 400, 40, 40);
    
    UIImageView *profileView = [[UIImageView alloc] initWithFrame:profileRect];
    
    
    NSString* urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%d/picture",rec.userId];

    NSLog(@"urlstring:%@", urlString);
    [profileView setImageWithURL:[NSURL URLWithString:urlString]
                placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
  
     
    // **********
    // need to download the latest version of SDWEbImage
    // and apply this option
    
   //    options:SDWebImageRefreshCached];
    

    profileView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:profileView];
    
    // user's name
    CGRect nameLabelRect = CGRectMake(70,400,200,20);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameLabelRect];
    nameLabel.text = rec.userName;
    nameLabel.textAlignment = UITextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:nameLabel];
    
    // user's note  
    CGRect postRect = CGRectMake(70, 420, 240, 50);
    UITextView *postView = [[UITextView alloc] initWithFrame:postRect];
    [postView setEditable:NO];
    postView.font = [UIFont fontWithName:@"Helvetica" size:13];
    postView.text = rec.postText;
    postView.textAlignment = UITextAlignmentLeft;
    postView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:postView];
    

    
    NSLog(@"purchase place type: %d", rec.purchasePlaceType);
    


    originalHeight = 480;
    if (rec.ageBand !=0) originalHeight -= 20; // - heigh of ageRect
    
    
    NSLog(@"scrollview original height:%d", originalHeight);
    scrollView.contentSize=CGSizeMake(320,originalHeight);
    
}

- (void)renderTable
{
    //it's not working
    //http://stackoverflow.com/questions/6860231/how-to-get-the-size-of-a-uitableviews-content-view
    //[commentTableView layoutIfNeeded];
    // Allows you to perform layout before the drawing cycle happens.
    //-layoutIfNeeded forces layout early. So it will correctly return the size. Like dreaming before doing.
    
    
    int tableHeight = CELL_HEIGHT * [self.comments count];
    
    scrollView.contentSize=CGSizeMake(320, originalHeight+tableHeight+50);
    
    commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, originalHeight+50, 320, tableHeight) style:UITableViewStylePlain];
    commentTableView.dataSource = self;
    commentTableView.delegate = self;
    
    [self.view addSubview:commentTableView];
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib
// ViewDidLoad is called when your view loading is finished
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"furley_bg"]];
    
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"user: %@", rec.userName);
    NSLog(@"Product name: %@", rec.productName);
    NSLog(@"post: %@", rec.postText);
    NSLog(@"rec filename: %@", rec.fileName);
    

    self.title = rec.productName;
    self.comments = [[NSMutableArray alloc] init];
    
    // web connection
    
    [self fetchComments];
   
    
     NSLog(@"content size HEIGHT: %f", commentTableView.contentSize.height);
    
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
    [self loadView];
    


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



@end
