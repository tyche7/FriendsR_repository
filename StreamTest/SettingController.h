//
//  SettingController.h
//  StreamTest
//
//  Created by Naehee Kim on 10/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingController : UIViewController < UITableViewDataSource, UITableViewDelegate,  FBFriendPickerDelegate>


@property (strong, nonatomic) NSArray* selectedFriends;

@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UITableView *menuTableView;

@property (strong, nonatomic) UINavigationController *navigationControllerOfSettingController;

@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;

- (IBAction)logoutButtonWasPressed:(id)sender;
- (IBAction)showFriends:(id)sender;
- (void)populateUserDetails;

@end
