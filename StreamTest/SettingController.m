//
//  SettingController.m
//  StreamTest
//
//  Created by Naehee Kim on 10/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "SettingController.h"
#import "StreamAppDelegate.h"
#import "UserStore.h"
#import "UserData.h"

@implementation SettingController

@synthesize friendPickerController = _friendPickerController;
@synthesize selectedFriends = _selectedFriends;
//@synthesize userLocationLabel = _userLocationLabel;

@synthesize menuTableView;
@synthesize myRecommendationViewController;

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
    UserStore *userStore = [UserStore sharedStore];
    UserData *myUserData =  userStore.userData;
    NSLog(@"my userID is %@", myUserData.userID);
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:SCSessionStateChangedNotification
     object:nil];
    
    self.title = @"Profile";
    
    //code to get friends from web server

    //NSString *urlString = @"http://tyche92.pythonanywhere.com/upload/friends/userid/726566112";
    NSString *urlString = [NSString stringWithFormat:@"http://tyche92.pythonanywhere.com/upload/userid/%@", myUserData.userID];
    
    //PHP file name is being set from the parent view
    //[databaseURL appendString:urlString];
    
    //call ASIHTTP delegates (Used to connect to database)
    NSURL *url = [NSURL URLWithString:urlString];
    
    //SynchronousRequest to grab the data
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *error;
    NSURLResponse *response;
    
    NSMutableData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!result) {
        //Display error message here
        NSLog(@"Error");
    } else {
        
        //TODO: set up stuff that needs to work on the data here.
        //NSLog(@"%@", result);
        //NSString* newStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
       // NSLog(@"%@", newStr);
        

        //NSError *myError1 = nil;
        
        //NSDictionary *resJSON = [NSJSONSerialization JSONObjectWithData: [newStr dataUsingEncoding:NSUTF8StringEncoding]
                                       // options: NSJSONReadingMutableContainers
                                        //  error: &myError1];
       // NSLog(@"results JSON : %@", resJSON);
        
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&myError];
        
        // show all values
        NSArray *results = [res objectForKey:@"items"];
        myUserData.toddleFriends = results;
        
        for (id friend in results) {
            NSLog(@"friendid: %@", [friend objectForKey:@"friendid"]);
            NSLog(@"friendname: %@", [friend objectForKey:@"friendname"]);
            NSLog(@"friendurl: %@", [friend objectForKey:@"friendurl"]);
        }
        
        /*for(id key in res) {
            
            id value = [res objectForKey:key];
            
            NSString *keyAsString = (NSString *)key;
            NSString *valueAsString = (NSString *)value;
            
            NSLog(@"key: %@", keyAsString);
            NSLog(@"value: %@", valueAsString);
        }*/
    }

}

- (void)viewDidUnload
{
    //[self setUserLocationLabel:nil];
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
                 NSLog(@"user location: %@", [user.location objectForKey:@"name"]);
                 self.userNameLabel.text = user.name;
                 self.userProfileImage.profileID = user.id;
                 self.userLocationLabel.text = [user.location objectForKey:@"name"];
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
            cell.textLabel.text = @"My friends";
            //cell.detailTextLabel.text = @"Select one";
            //cell.imageView.image = [UIImage imageNamed:@"action-eating.png"];
            break;
            
        default:
            break;
    }
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            if(!self.myRecommendationViewController){
                self.myRecommendationViewController = [[MyRecommendationViewController alloc] init];
                //self.ageController.delegate = self;
            }
            [self.navigationController pushViewController:self.myRecommendationViewController animated:true];
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
