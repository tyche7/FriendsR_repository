//
//  StreamViewController.m
//  StreamTest
//
//  Created by Naehee Kim on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// reference: http://agilewarrior.wordpress.com/2012/02/01/how-to-make-http-request-from-iphone-and-parse-json-result/
// https://github.com/rs/SDWebImage

#import <SDWebImage/UIImageView+WebCache.h>
#import "StreamViewController.h"
#import "StreamCell.h"
#import "DetailViewController.h"
#import "Rec.h"

#define kNameTag 1
#define kDateTag 2
#define kPostTag 3
#define kImageTag 4

@implementation StreamViewController

@synthesize detailController, recs, responseData;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Favorites";
    
    // Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"StreamCell" bundle:nil];
    
    // Register this NIB which contains the cell
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"StreamCell"];
    

    // web connection
    self.responseData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1:5000/entries"]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    self.recs = [[NSMutableArray alloc] init];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    

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
    
    // hide navigation bar
    //[[self navigationController] setNavigationBarHidden:YES animated:NO];
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return [recs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
      
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    StreamCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell == nil){
        cell = [[StreamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier];
    }
    
    
    Rec* rec = [recs objectAtIndex:indexPath.row];
    
    cell.name = rec.userName;
    cell.date = @"Nov 27";
    cell.post = rec.postText;
    NSString* imagePlace = [NSString stringWithFormat:@"http://127.0.0.1:5000/uploads/%@", rec.fileName];
    //cell.image = [UIImage imageNamed:imagePlace];
    //cell.image = [UIImage imageNamed:@"hera_foundation.jpg"];
    //cell.image = [UIImage imageNamed:rec.fileName];
    
    // Here we use the new provided setImageWithURL: method to load the web image
    NSLog(@"imagePlace: %@",rec.fileName);

    [cell.picView setImageWithURL:[NSURL URLWithString:imagePlace] placeholderImage:[UIImage imageNamed:@"hera_foundation.jpg"]];

    

    

    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
    
    StreamCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.detailController.detailPicImage = cell.picView.image;
    
    [self.navigationController pushViewController:detailController animated:YES];
    
    
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    //when the data is applied, the total height should be calculated 
     
    
    return 320.0;
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
    
    for (NSDictionary *result in results) {
        NSString *icon = [result objectForKey:@"name"];
        NSLog(@"name: %@", icon);
   
    
        Rec* rec = [[Rec alloc] init ];
        [rec setFileName:[result objectForKey:@"name"]]; //file name: eg) "bibim.jpg"
        [rec setUserName:[result objectForKey:@"user"]];
        [rec setPostText:[result objectForKey:@"text"]];
        [rec setProductName:[result objectForKey:@"productName"]];
        [rec setBrandName:[result objectForKey:@"brandName"]];
        [rec setPurchasePlace:[result objectForKey:@"purchasePlace"]];
        [rec setPrice:[result objectForKey:@"price"]];
    
        [recs addObject:rec];

    } //end for
    
    //reload data
    [[self tableView] reloadData];
    
}




@end
