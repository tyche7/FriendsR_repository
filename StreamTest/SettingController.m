//
//  SettingController.m
//  StreamTest
//
//  Created by Naehee Kim on 10/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// reference: https://developers.facebook.com/docs/tutorials/ios-sdk-tutorial/show-friends/

#import <FacebookSDK/FacebookSDK.h>
#import "SettingController.h"
#import "StreamAppDelegate.h"

@implementation SettingController

@synthesize friendPickerController = _friendPickerController;
@synthesize selectedFriends = _selectedFriends;

@synthesize menuTableView;

@synthesize navigationControllerOfSettingController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // create a new bar button item
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutButtonWasPressed:)];
        
        // set this bar button item as the right item in the navigationItem
        [[self navigationItem] setRightBarButtonItem:bbi];
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
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:SCSessionStateChangedNotification
     object:nil];
    
    self.title = @"toddle";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.friendPickerController = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (FBSession.activeSession.isOpen) {
        [self populateUserDetails];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
        return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

-(void)logoutButtonWasPressed:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)populateUserDetails
{
    NSLog(@"in populate User Details");
    
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 
                 NSLog(@"user name: %@", user.name);
                 NSLog(@"user id: %@", user.id);
                 NSLog(@"user username: %@", user.username);
                 self.userNameLabel.text = user.name;
                 self.userProfileImage.profileID = user.id;
             }
         }];
    }
}

- (void)sessionStateChanged:(NSNotification*)notification {
    [self populateUserDetails];
}

- (void)showFriends:(id)sender{
    
    NSLog(@"showFriends function");
    
    if (!self.friendPickerController) {
        self.friendPickerController = [[FBFriendPickerViewController alloc]
                                       initWithNibName:nil bundle:nil];
        self.friendPickerController.title = @"Select friends";
    }
    
    [self.friendPickerController loadData];
    [self.navigationController pushViewController:self.friendPickerController
                                         animated:true];
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
        cell.textLabel.clipsToBounds = YES;
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.4
                                                         green:0.6
                                                          blue:0.8
                                                         alpha:1];
        cell.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
        cell.detailTextLabel.clipsToBounds = YES;
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"What are you eating?";
            cell.detailTextLabel.text = @"Select one";
            cell.imageView.image = [UIImage imageNamed:@"action-eating.png"];
            break;
            
        case 1:
            cell.textLabel.text = @"Where are you?";
            cell.detailTextLabel.text = @"Select one";
            cell.imageView.image = [UIImage imageNamed:@"action-location.png"];
            break;
            
        case 2:
            cell.textLabel.text = @"With whom?";
            cell.detailTextLabel.text = @"Select friends";
            cell.imageView.image = [UIImage imageNamed:@"action-people.png"];
            break;
            
        case 3:
            cell.textLabel.text = @"Got a picture?";
            cell.detailTextLabel.text = @"Take one";
            cell.imageView.image = [UIImage imageNamed:@"action-photo.png"];
            break;
            
        default:
            break;
    }
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 2:
            if (!self.friendPickerController) {
                self.friendPickerController = [[FBFriendPickerViewController alloc]
                                               initWithNibName:nil bundle:nil];
                
                // Set the friend picker delegate
                self.friendPickerController.delegate = self;
                
                self.friendPickerController.title = @"Select friends";
            }
            
            [self.friendPickerController loadData];
            [self.navigationController pushViewController:self.friendPickerController
                                                 animated:true];
            break;
    }
}

- (void)updateCellIndex:(int)index withSubtitle:(NSString*)subtitle {
    UITableViewCell *cell = (UITableViewCell *)[self.menuTableView
                                                cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    cell.detailTextLabel.text = subtitle;
}

- (void)updateSelections
{
    
    
    NSString* friendsSubtitle = @"Select friends";
    int friendCount = self.selectedFriends.count;
    if (friendCount > 2) {
        // Just to mix things up, don't always show the first friend.
        id<FBGraphUser> randomFriend =
        [self.selectedFriends objectAtIndex:arc4random() % friendCount];
        friendsSubtitle = [NSString stringWithFormat:@"%@ and %d others",
                           randomFriend.name,
                           friendCount - 1];
    } else if (friendCount == 2) {
        id<FBGraphUser> friend1 = [self.selectedFriends objectAtIndex:0];
        id<FBGraphUser> friend2 = [self.selectedFriends objectAtIndex:1];
        friendsSubtitle = [NSString stringWithFormat:@"%@ and %@",
                           friend1.name,
                           friend2.name];
    } else if (friendCount == 1) {
        id<FBGraphUser> friend = [self.selectedFriends objectAtIndex:0];
        friendsSubtitle = friend.name;
        
        NSLog(@"friend name: %@", friend.name);
        NSLog(@"friend id: %@", friend.id);
        NSLog(@"friend username: %@", friend.username);
        NSLog(@"friend fist name: %@", friend.first_name);
        NSLog(@"friend last name: %@", friend.last_name);
        

     
        
    }
    [self updateCellIndex:2 withSubtitle:friendsSubtitle];
    

}

- (void)friendPickerViewControllerSelectionDidChange:
(FBFriendPickerViewController *)friendPicker
{
    self.selectedFriends = friendPicker.selection;
    [self updateSelections];
}

- (void)dealloc
{
    _friendPickerController.delegate = nil;
}
@end
