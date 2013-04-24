//
//  StreamViewController.m
//  StreamTest
//
//  Created by Naehee Kim on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <SDWebImage/UIImageView+WebCache.h>
#import <FacebookSDK/FacebookSDK.h>
#import "StreamViewController.h"
#import "StreamCell.h"
#import "DetailViewController.h"
#import "Rec.h"
#import "DataFeedStore.h"
#import "UserStore.h"
#import "StreamAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#define kNameTag 1
#define kDateTag 2
#define kPostTag 3
#define kImageTag 4

@implementation StreamViewController

@synthesize detailController, recs, searchResults, userid, dateFormatter;
@synthesize mainSpinner;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
   
        fetchUserDataDidCallAndSet = NO;
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"furley_bg"]];

    
    self.title = @"toddle";
    
    // Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"StreamCell" bundle:nil];
    
    // Register this NIB which contains the cell
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"StreamCell"];
    
    
    
    self.recs = [[NSMutableArray alloc] init];
    
    
    // set dateFormatter
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd"];
 
    

    
    //add search button
    UIBarButtonItem *searchBtn = [[UIBarButtonItem  alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(showSearchBar)];
    
  
    self.navigationItem.rightBarButtonItem = searchBtn;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    

    
    self.tableView.contentOffset = CGPointMake(0.0, 44.0);
    self.tableView.separatorColor = [UIColor clearColor];
    
    
    // showing activity indicator
    
    mainSpinner = [self showActivityIndicatorOnView:self.parentViewController.view];
    
    // faetch user data : try it when fb session is open
    if(FBSession.activeSession.isOpen){
        NSLog(@"fetch user data");
        [self fetchUserData];
        // Set fetchUserDataDidCall in the completion block in fetchUserData

        
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:SCSessionStateChangedNotification
     object:nil];

    
    // set StreamViewController as UserStore's delegate
    [[UserStore sharedStore] setDelegate:self];
    

}

- (void)sessionStateChanged:(NSNotification*)notification {
    
    
    NSLog(@"in sessionStateChanged");
    
    if (!fetchUserDataDidCallAndSet) {
         NSLog(@"fetch user data");
         [self fetchUserData];

    }


    
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
    
 

    NSLog(@"VIEW WILL APPEAR");
    
    // ****************************************
    // for test, termporarily comment out 
    //fetch data whenever this controller becomes activated
    //Need to handle the case that fetchData is called, before having userData *****
    //of call fetchData, only after user post his data or explicitly want to refresh the view.
    //[self fetchData];
    // ***************************************
    
    if (fetchUserDataDidCallAndSet) {
        [self fetchData];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Activity Indicator

- (UIActivityIndicatorView *)showActivityIndicatorOnView:(UIView*)aView
{
    CGSize viewSize = aView.bounds.size;
    
    // create new dialog box view and components
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]
                                                      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    // other size? change it
    activityIndicatorView.bounds = CGRectMake(0, 0, 65, 65);
    activityIndicatorView.hidesWhenStopped = YES;
    activityIndicatorView.alpha = 0.7f;
    //activityIndicatorView.backgroundColor = [UIColor blackColor];
    //activityIndicatorView.layer.cornerRadius = 10.0f;
    
    // display it in the center of your view
    activityIndicatorView.center = CGPointMake(viewSize.width / 2.0, viewSize.height / 2.0);
    
    [aView addSubview:activityIndicatorView];
    
    [activityIndicatorView startAnimating];
    
    return activityIndicatorView;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     // Return the number of rows in the section.
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return [searchResults count];
    }else{
   
    return [recs count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
      
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    StreamCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell == nil){
        cell = [[StreamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier];
    }
    
    Rec* rec;
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        rec = [searchResults objectAtIndex:indexPath.row];
    }else{
    
        rec = [recs objectAtIndex:indexPath.row];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.name = rec.userName;
    cell.date = [dateFormatter stringFromDate:rec.date];
    cell.rating = rec.rating;
    cell.ageBand = 0; //set initial value

  
    
    //NSLog(@"TIME: %@", rec.date);
    //cell.post = rec.postText;
    NSString* imagePlace = [NSString stringWithFormat:@"http://tyche92.pythonanywhere.com/photos/%@", rec.fileName];
    
    if (!rec.purchasePlace || [rec.purchasePlace isEqualToString:@"None"] || [rec.purchasePlace isEqualToString:@""]) {
        cell.productNameAndPurchasePlace = rec.productName;
    }
    else{
        cell.productNameAndPurchasePlace = [NSString stringWithFormat:@"%@ from %@", rec.productName, rec.purchasePlace];
    }
    
    
    [cell.picView setImage:[UIImage imageNamed:@"hera_foundation.jpg"]];
    
    
    
    //Downloads the image at the given URL if not present in cache or return the cached version otherwise.
    
   // SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
   
    //NSLog(@"%@ image is being downloaded", rec.productName);
    // NSLog(@"%@", imagePlace);
    
    // showing activity indicator
    UIActivityIndicatorView *spinner;
    spinner = [self showActivityIndicatorOnView:cell.picView];
    
    
    //create cell reference
    
    __weak StreamCell *weakReferenceToCell = cell;
  
    
    [cell.picView setImageWithURL:[NSURL URLWithString:imagePlace]
        placeholderImage:[UIImage imageNamed:@"placeholder.png"]
      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
     {    // stopping activity indicator
     
         
             [spinner stopAnimating];
  

         
         
         if (image)
         {
             // do something with image
             NSLog(@"%@ Image has been dowloaded, and now is set", rec.productName);
             //NSLog(@"cell ageband:%d", cell.ageBand);
             

             
             weakReferenceToCell.ageBand = rec.ageBand;
             
         }
  }];
  
  
    return cell;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    self.detailController.title = @"Detail View";
    self.detailController.rec = [recs objectAtIndex:indexPath.row];

    NSLog(@"detailConroller rec: productName %@", self.detailController.rec.productName);
    NSLog(@"detailConroller rec: postText %@", self.detailController.rec.postText);
    
    StreamCell *cell = (StreamCell *)[tableView cellForRowAtIndexPath:indexPath];
    self.detailController.detailPicImage = cell.picView.image;
    self.detailController.productNameAndPurchasePlace = cell.productNameAndPurchasePlace;
    
    self.detailController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailController animated:YES];
    
    
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // http://stackoverflow.com/questions/2213024/uitableview-flexible-dynamic-heightforrowatindexpath
    // Notice: from this method, it's not possible to get a cell using indexpath
    // because indexpath is 0 when this method is called.
    // StreamCell *cell = (StreamCell *)[tableView cellForRowAtIndexPath:indexPath];

    // solution: to calcuate the cell height
    // it's necessary to use data ojbects

    //Rec* rec = [recs objectAtIndex:indexPath.row];
    
     //CGFloat postTextHeight = 0;
    
    /* commented out for MVP version
    UIFont* font = [UIFont fontWithName:@"Helvetica" size:14];
    CGSize size= [rec.postText sizeWithFont:font];
    CGFloat postTextHeight = ceil(size.width/300)*(float)size.height;
    NSLog(@"post text height: %f", postTextHeight);
    */
    
   
    
    CGFloat contentHeight = 320.f;
    
    return MAX(contentHeight, 44.0f);
    
    
    //return 320.0f;
}

- (void)fetchUserData{
    
    [[UserStore sharedStore] fetchUserDataWithCompletion:^(UserData *userData, NSError *err) {
        //when the request completes, this block will be called.
        
        [mainSpinner stopAnimating];
        
        
        if (!err) {
           
           
            // now fetch User Friends after getting user data
            
            [self fetchUserFriends];

            
            
            
 
            
        }
    }];
}

- (void)fetchUserFriends{
    
    [[UserStore sharedStore] fetchUserFriendsWithCompletion:^(NSArray *friendList, NSError *err) {
        
        [mainSpinner stopAnimating];
        
        if (!err) {
             // now dissmiss splash view which blocks or hides the StreamView
            
            
            fetchUserDataDidCallAndSet = YES;
            
            NSLog(@"fetch recommendations - fetchData method");
            [self fetchData];
            

            
        }
    }];
}


- (void)fetchData{
    //Initiate the request
    
    //recs come from cache
    recs = [[DataFeedStore sharedStore] fetchRecommendationsWithCompletion:^(NSMutableArray *fetchedRecommendations, NSError *err) {
        // when the request completes, this block will be called.
        
        if (!err){
            NSLog(@"getting product recs");
            // How many items are there currently?
            int currentItemCount = [recs count];
            
            // fetched from web server
            recs = fetchedRecommendations;
            
            // How many items are there now?
            int newItemCount = [recs count];
            
            // for each new item, insert a new row
            int itemDelta = newItemCount - currentItemCount;
            if (itemDelta>0){
                NSMutableArray* rows = [NSMutableArray array];
                for (int i=0; i<itemDelta; i++){
                    NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
                    [rows addObject:ip];
                }
                
                [[ self tableView] insertRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationTop];
            }
            
            
        }else{
            //if things went bad, show an alert view
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [av show];
        }
        
        [[self tableView] reloadData];
        
    }];
    
}

// reference: http://www.appcoda.com/how-to-add-search-bar-uitableview/

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}


// reference: http://www.peterfriese.de/using-nspredicate-to-filter-data/

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"productName contains[cd] %@",
                                    searchText];
    
    searchResults = [recs filteredArrayUsingPredicate:resultPredicate];
}


- (IBAction)showSearchBar{
       self.tableView.contentOffset = CGPointMake(0.0, 0.0);
}


-(void)friendsUpadteToServerDidFinish{
    
    //now friendsList are stored to the remote server; reload data to show all friends' posts.
    
    NSLog(@"** After updating freidns, let's fetch data");
    [self fetchData];
}



@end
