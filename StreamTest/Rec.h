//
//  Rec.h
//  StreamTest
//
//  Created by Naehee Kim on 10/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rec : NSObject

@property (nonatomic, strong) NSString *recId;
@property (nonatomic) int userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) UIImage *userImage;
@property (nonatomic, strong) NSString *postTitle;
@property (nonatomic, strong) NSString *postText;
@property (nonatomic, strong) UIImage *productImage;
@property (nonatomic, strong) NSString *imagePlace;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSString *purchasePlace;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *additionalInfo;
@property (nonatomic, strong) NSString *fileName;

@property (nonatomic, strong) NSMutableArray *comments;


@end
