//
//  StreamCell.h
//  StreamTest
//
//  Created by Naehee Kim on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StreamCell : UITableViewCell 

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *post;
@property (strong, nonatomic) UIImage *image;
@property (nonatomic) int rating;
@property (strong, nonatomic) UIImageView *picView;
@property (strong, nonatomic) UIImageView *triangleView;
@property (strong, nonatomic) UIImageView *ratingView;
@property (strong, nonatomic) NSString *productNameAndPurchasePlace;
@property (nonatomic) int ageBand;


@end
