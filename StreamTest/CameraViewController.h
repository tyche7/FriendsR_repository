//
//  CameraViewController.h
//  StreamTest
//
//  Created by Kim on 11/16/12.
//
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{

    BOOL newMedia;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)useCamera;
- (IBAction)useCameraRoll;

@end
