//
//  DetailViewController.m
//  StreamTest
//
//  Created by Naehee Kim on 10/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "DetailViewController.h"
#import "Rec.h"
#import "Comment.h"

@implementation DetailViewController

@synthesize rec, scrollView, detailPicImage, commentTableView;

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

- (void)loadView {
    
    CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    
    scrollView=[[UIScrollView alloc] initWithFrame:fullScreenRect];
    
    self.view=scrollView;
    
    scrollView.contentSize=CGSizeMake(320,758);
    
    //scrollView.contentInset=UIEdgeInsetsMake(64.0,0.0,44.0,0.0);
    
     scrollView.scrollIndicatorInsets=UIEdgeInsetsMake(64.0,0.0,44.0,0.0);
    
    scrollView.backgroundColor = [UIColor whiteColor];
    
    
    
    // do any further configuration to the scroll view
    
    // add a view, or views, as a subview of the scroll view.
    
    /* for test
    rec = [[Rec alloc] init];
    rec.userId = 1;
    rec.userName = @"Rachel";
    rec.postTitle = @"Moist foundation";
    rec.postText = @"It is a new type of foundation and it is so moist~. It leaves the skin nice a luminous, even skin-toned. It is the best foundation I have tried so far. \n";
    rec.productName = @"HERA UV MIST CUSHION";
    rec.brandName = @"Hera";
    rec.price = @"50";
    rec.purchasePlace = @"Nordstrom";
    
    rec.date = [NSDate date];
    */
    

    /*
    rec.productName = @"HERA UV MIST CUSHION";
    rec.brandName = @"Hera";
    rec.price = @"50";
    rec.purchasePlace = @"Nordstrom";
    
    rec.date = [NSDate date];
    */
    
    NSLog(@"user: %@", rec.userName);
    NSLog(@"Product name: %@", rec.productName);
    NSLog(@"post: %@", rec.postText);
    
    //
    self.title = rec.productName;
    
    // Initialization code
    CGRect nameLabelRect = CGRectMake(10,5,70,15);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameLabelRect];
    nameLabel.textAlignment = UITextAlignmentLeft;
    nameLabel.text = rec.userName;
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    

    [scrollView addSubview:nameLabel];
    
    CGRect dateLabelRect = CGRectMake(240, 5, 70, 15);
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:dateLabelRect];
    dateLabel.textAlignment = UITextAlignmentRight;
    dateLabel.text = @"Nov 27";
    
    dateLabel.font = [UIFont boldSystemFontOfSize:14];
    [scrollView addSubview:dateLabel];
    
    CGRect postRect = CGRectMake(10, 25, 300, 50);
    UITextView *postView = [[UITextView alloc] initWithFrame:postRect];
    [postView setEditable:NO];
    postView.font = [UIFont fontWithName:@"Helvetica" size:14];
    postView.text = rec.postText;
    
    [scrollView addSubview:postView];
    
    // reference this if you want to resize your image
    // http://stackoverflow.com/questions/8701751/uiimageview-change-size-to-image-size
    // at this point, I assume that the image size from server has only one size
    
    CGRect imageRect = CGRectMake(30, 100, 260, 195);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageRect];
    
    //imageView.image = self.image;
    
    //NSString* imagePlace = [NSString stringWithFormat:@"http://localhost:5000/uploads/%@", rec.productName];
    //NSLog(@"imagePlace:",imagePlace);
    
    //[imageView setImageWithURL:[NSURL URLWithString:imagePlace] placeholderImage:[UIImage imageNamed:@"hera_foundation.jpg"]];
    
    NSLog(@"rec filename: %@", rec.fileName);
    imageView.image = self.detailPicImage;
    //imageView.image = [UIImage imageNamed:rec.fileName];
    //imageView.image = [UIImage imageWithContentsOfFile:image-path];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:imageView];
    

 
    if (rec.productName){
        CGRect infoRect = CGRectMake(10, 320, 300, 20);
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:infoRect];
        infoLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        infoLabel.text = [NSString stringWithFormat:@"Product Name: %@", rec.productName];
        
        [scrollView addSubview:infoLabel];
    }
    if (rec.brandName) {
        
        CGRect infoRect1 = CGRectMake(10, 340, 300, 20);
        UILabel *infoLabel1 = [[UILabel alloc] initWithFrame:infoRect1];
        infoLabel1.font = [UIFont fontWithName:@"Helvetica" size:14];
        infoLabel1.text = [NSString stringWithFormat:@"Brand Name: %@", rec.brandName];
        
        [scrollView addSubview:infoLabel1];
    }
    
    if (rec.purchasePlace) {
        
    
        CGRect infoRect2 = CGRectMake(10, 360, 300, 20);
        UILabel *infoLabel2 = [[UILabel alloc] initWithFrame:infoRect2];
        infoLabel2.font = [UIFont fontWithName:@"Helvetica" size:14];
        infoLabel2.text = [NSString stringWithFormat:@"Purchase Place: %@", rec.purchasePlace];
        
        [scrollView addSubview:infoLabel2];
    
    }
    
    if (rec.price) {
        
        
        CGRect infoRect3 = CGRectMake(10, 380, 300, 20);
        UILabel *infoLabel3 = [[UILabel alloc] initWithFrame:infoRect3];
        infoLabel3.font = [UIFont fontWithName:@"Helvetica" size:14];
        infoLabel3.text = [NSString stringWithFormat:@"Price: %@", rec.price];
        
        [scrollView addSubview:infoLabel3];
        
    }
    
    // contentSize.height
    
    
    //http://stackoverflow.com/questions/6860231/how-to-get-the-size-of-a-uitableviews-content-view
    [commentTableView layoutIfNeeded];
    // Allows you to perform layout before the drawing cycle happens.
    //-layoutIfNeeded forces layout early. So it will correctly return the size. Like dreaming before doing.

    
    
    //commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(commentTableView.frame.origin.x, commentTableView.frame.origin.y, commentTableView.frame.size.width, commentTableView.contentSize.height) style:UITableViewStylePlain];
    
    commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 450, 320, commentTableView.contentSize.height) style:UITableViewStylePlain];
    commentTableView.dataSource = self;
    commentTableView.delegate = self;
    
    [self.view addSubview:commentTableView];

    
    
    // release scrollView as self.view retains it
    
    self.view=scrollView;
    
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    // Need to check the difference btw loadview and viewWillAppear

    NSString* urlString = [NSString stringWithFormat:@"http://groups.ischool.berkeley.edu/friendly/comments/entryid/%@", rec.recId];
    NSLog(urlString);
    
    // web connection
    self.responseData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [self loadView];
    

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    

    cell.textLabel.text = cmt.comment;
    cell.detailTextLabel.text = cmt.userName;

    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.comments count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

// This method will be called several times as the data arrives

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    // show all values
    for(id key in res) {
        
        id value = [res objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        NSString *valueAsString = (NSString *)value;
        
        NSLog(@"key: %@", keyAsString);
        NSLog(@"value: %@", valueAsString);
    }
    
    // extract specific value...
    NSArray *results = [res objectForKey:@"items"];
    self.comments = [[NSMutableArray alloc] init];
    
    for (NSDictionary *result in results) {
        NSString *icon = [result objectForKey:@"name"];

        NSLog(@"comment: %@", [result objectForKey:@"comment"]);
        
        
        Comment* comment = [[Comment alloc] init ];
        [comment setCommentId:[result objectForKey:@"id"]];

        [comment setUserName:[result objectForKey:@"user"]];
        [comment setUserId:[result objectForKey:@"userid"]];
        
        [comment setComment:[result objectForKey:@"comment"]];
        
        [self.comments addObject:comment];
        
    } //end for
    
    //reload data
    [self loadView];
    [[self commentTableView] reloadData];
    
}


@end
