//
//  NoteViewController.m
//  StreamTest
//
//  Created by Naehee Kim on 3/14/13.
//
//

#import "NoteViewController.h"

@interface NoteViewController ()

@end

@implementation NoteViewController

@synthesize noteTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Description";
    [noteTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    NSLog(@"DidEndEditing");
    NSLog(@"post: %@", textView.text);
    
    
    [self.delegate setNote:textView.text];

    
    return TRUE;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    NSLog(@"shouldchangeTextinRange");
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

/*
- (void)textViewDidChange:(UITextView *)textView{
    NSLog(@"textViewDidChange:");
    NSLog(@"length: %d",textView.text.length);

}
*/



@end




