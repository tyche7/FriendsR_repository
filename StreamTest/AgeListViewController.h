//
//  AgeListViewController.h
//  StreamTest
//
//  Created by Naehee Kim on 3/13/13.
//
//

#import <UIKit/UIKit.h>

@protocol AgeListViewControllerDelegate; 


@interface AgeListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet  UITableView* ageTableView;

@property (nonatomic, assign) id<AgeListViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString* ageLabel;
@property (nonatomic) int age;

@property (nonatomic) int selectedRow;

@end

@protocol AgeListViewControllerDelegate <NSObject>

-(void)setAge:(int)age withLabel:(NSString *)ageLabel;

@end