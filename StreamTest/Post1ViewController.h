//
//  Post1ViewController.h
//  StreamTest
//
//  Created by Naehee Kim on 4/30/13.
//
//




#import <UIKit/UIKit.h>
#import "Rec.h"
#import "Post2ViewController.h"
@class CameraViewController;


@interface Post1ViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, Post2ViewControllerDelegate>{
    
    BOOL    newMedia;
    BOOL    displayMediumChoice;
   
}


@property (nonatomic, strong) IBOutlet UIImageView *photoImage;
@property (nonatomic, strong) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) IBOutlet UIImage *productImage;
@property (nonatomic, strong) IBOutlet UITextField *productNameField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *ratingSegmentedControl;
@property (nonatomic, strong) Rec *rec;

@property (nonatomic, weak) UIActionSheet *actionSheet;
@property (nonatomic, strong) UITextField *currentField;

@property (strong, nonatomic) UIBarButtonItem *bbiRight;

@property (nonatomic) BOOL productImageisSet;


- (IBAction)cancel:(id)sender;
- (IBAction)selectMedium:(id)sender;
- (IBAction)useCamera;
- (IBAction)useCameraRoll;


+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (void)showAlertView:(NSString*)title andMessage:(NSString*)msg;



@end
