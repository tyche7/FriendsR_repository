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
@synthesize scrollView, detailPicImage, commentTableView;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
