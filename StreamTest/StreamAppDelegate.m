//
//  StreamAppDelegate.m
//  StreamTest
//
//  Created by Naehee Kim on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import "StreamAppDelegate.h"
#import "StreamViewController.h"
#import "DetailViewController.h"
#import "Post1ViewController.h"
#import "MyViewController.h"
#import "SettingController.h"
#import "LoginViewController.h"
#import "CameraViewController.h"


@implementation StreamAppDelegate

NSString *const SCSessionStateChangedNotification =
@"com.facebook.Scrumptious:SCSessionStateChangedNotification";

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize tabBarController =  _tabBarController;
@synthesize navController, navController1, navController2;
@synthesize rootController;

- (void)customizeAppearance
{
    // Create resizable images
    UIImage *gradientImage44 = [[UIImage imageNamed:@"UINavigation_Purple7"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];

    // Set the background image for *all* UINavigationBars
    [[UINavigationBar appearance] setBackgroundImage:gradientImage44
                                       forBarMetrics:UIBarMetricsDefault];

    
    // Customize the title text for *all* UINavigationBars
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                UITextAttributeTextColor: [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
                          UITextAttributeTextShadowColor: [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
                         UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)],
                                     UITextAttributeFont: [UIFont fontWithName:@"CherrySwash-Regular" size:25.0f]
     }];
    
    UIImage *button30 = [[UIImage imageNamed:@"topnav_black_button"]
                         resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];

    
    [[UIBarButtonItem appearance] setBackgroundImage:button30 forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"topnav_back_button"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];


}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self customizeAppearance];
    
    [FBProfilePictureView class];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    rootController = [[StreamViewController alloc] initWithNibName:@"StreamViewController"  bundle:nil];
 
    navController = [[UINavigationController alloc] initWithRootViewController:rootController];

    UIViewController *postController = [[Post1ViewController  alloc] initWithNibName:@"Post1ViewController" bundle:nil];
    navController1 = [[UINavigationController alloc] initWithRootViewController:postController];
    
    UIViewController *settingController= [[SettingController alloc] initWithNibName:@"SettingController" bundle:nil];
    navController2 = [[UINavigationController alloc] initWithRootViewController:settingController];
    
    self.tabBarController = [[UITabBarController alloc] init];
    navController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Toddle" image:[UIImage imageNamed:@"toddle2"] tag:1];
    navController1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Post" image:[UIImage imageNamed:@"camera30"] tag:2];
    navController2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"User" image:[UIImage imageNamed:@"user"] tag:3];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:navController, navController1,  navController2, nil];

    self.window.rootViewController = self.tabBarController;
    
   
    
    [self.window makeKeyAndVisible];
    
    // see if we have a valid token for the current state.
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded){
        // To -do, show logged in view (this won't display any UX).
        [self openSession];
        
    }else {
        // No, display the login page
        [self showLoginView];
      
    }
    
    //After a user logged in Facebook, populate user details
    //While getting user details and friends info either from facebook server or local archive,
    //Showing modal view - behave SYNCHRONOUSLY; Block the whole user interaction and show SPLASH page.
    //After getting 'notification' through block or delegate method, dismiss the modal view
 
    //[self populateUserDetails];
    //rootController.status_changed_to_login = true;
    
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor purpleColor]];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}



- (void)showLoginView
{
    
    UIViewController *topViewController = [self.navController topViewController];
    UIViewController *modalViewController = [topViewController modalViewController];
    
    // If the login screen is not already displayed, display it. If the login screen is
    // displayed, then getting back here means the login in progress did not successfully
    // complete. In that case, notify the login view so it can update its UI appropriately.
    if (![modalViewController isKindOfClass:[LoginViewController class]]) {
        LoginViewController* loginViewController = [[LoginViewController alloc]
                                                    initWithNibName:@"LoginViewController"
                                                    bundle:nil];
        [topViewController presentModalViewController:loginViewController animated:NO];
    } else {
        LoginViewController* loginViewController =
        (LoginViewController*)modalViewController;
        [loginViewController loginFailed];
    }
    
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            UIViewController *topViewController =
            [self.navController topViewController];
            if ([[topViewController modalViewController]
                 isKindOfClass:[LoginViewController class]]) {
                [topViewController dismissModalViewControllerAnimated:YES];
            }
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self showLoginView];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:SCSessionStateChangedNotification
     object:session];
    
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)openSession
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];

}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}



@end
