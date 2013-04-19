//
//  StreamViewController.h
//  StreamTest
//
//  Created by Naehee Kim on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UserStore.h"
@class DetailViewController;



@interface StreamViewController : UITableViewController <FriendsUpdateDelegate> {
    __block  BOOL fetchUserDataDidCallAndSet;
}

@property (nonatomic, strong) NSMutableArray *recs;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) IBOutlet DetailViewController *detailController;
@property (nonatomic, strong) NSString *userid;
@property  (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIActivityIndicatorView *mainSpinner;


- (void)fetchUserData;
- (void)fetchUserFriends;
- (void)fetchData;
- (IBAction)showSearchBar;

- (UIActivityIndicatorView *)showActivityIndicatorOnView:(UIView*)aView;


-(void)friendsUpadteToServerDidFinish;

@end
