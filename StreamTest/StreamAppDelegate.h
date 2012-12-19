//
//  StreamAppDelegate.h
//  StreamTest
//
//  Created by Naehee Kim on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class LoginViewController;
@class StreamViewController;



@interface StreamAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
extern NSString *const SCSessionStateChangedNotification;

@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) UINavigationController *navController1;
@property (strong, nonatomic) UINavigationController *navController2;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) StreamViewController *viewController;
@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) LoginViewController *loginController;

- (void)openSession;

@end
