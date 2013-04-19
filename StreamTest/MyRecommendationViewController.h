//
//  MyRecommendationViewController.h
//  StreamTest
//
//  Created by Vimal Kini on 4/9/13.
//
//

#import <UIKit/UIKit.h>
#import "UserStore.h"
#import "UserData.h"

@class Rec;
@class Comment;

@interface MyRecommendationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) int originalHeight;
@property (nonatomic, strong) Rec *rec;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImage *detailPicImage;
@property (nonatomic, strong) UITableView *commentTableView;
@property (nonatomic, strong) NSString *productNameAndPurchasePlace;
@property (nonatomic, strong) UserData *myUserdata;
- (void)renderTable;

@end
