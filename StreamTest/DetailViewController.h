//
//  DetailViewController.h
//  StreamTest
//
//  Created by Naehee Kim on 10/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Rec;

@interface DetailViewController : UIViewController

@property (nonatomic, strong) Rec *rec;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImage *detailPicImage;

@end
