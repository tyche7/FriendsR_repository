//
//  MyRecommendationViewController.m
//  StreamTest
//
//  Created by Vimal Kini on 4/9/13.
//
//

#import "MyRecommendationViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DataFeedStore.h"
#import "Rec.h"
#import "Comment.h"
#import "UserStore.h"
#import "UserData.h"


@interface MyRecommendationViewController ()

@end

@implementation MyRecommendationViewController

@synthesize originalHeight, rec, productNameAndPurchasePlace;
@synthesize scrollView, detailPicImage, commentTableView, myUserdata;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"furley_bg"]];
    UserStore *userstore = [UserStore sharedStore];
    self.myUserdata = userstore.userData;

    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"You have %d friends on toddle ", [myUserdata.toddleFriends count]);
    return [myUserdata.toddleFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"MainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //get friends data
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [[myUserdata.toddleFriends objectAtIndex:row] objectForKey:@"friendname"];
    
    NSString *friendImageUrl = [[myUserdata.toddleFriends objectAtIndex:row] objectForKey:@"friendurl"];
    NSURL *imageURL = [NSURL URLWithString:friendImageUrl];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    cell.imageView.image = image;
    
    return cell;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
