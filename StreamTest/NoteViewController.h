//
//  NoteViewController.h
//  StreamTest
//
//  Created by Naehee Kim on 3/14/13.
//
//

#import <UIKit/UIKit.h>

@protocol NoteViewControllerDelegate;

@interface NoteViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, assign) id<NoteViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITextView* noteTextView;

@end

@protocol NoteViewControllerDelegate <NSObject>

-(void)setNote:(NSString* )note;

@end