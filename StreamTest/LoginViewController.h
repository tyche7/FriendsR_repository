//
//  LoginViewController.h
//  StreamTest
//
//  Created by Kim on 10/29/12.
//
//

#import <UIKit/UIKit.h>
#import "StreamAppDelegate.h"

@interface LoginViewController : UIViewController

- (IBAction)performLogin:(id)sender;
- (void)loginFailed;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end
