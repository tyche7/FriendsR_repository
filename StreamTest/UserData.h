//
//  UserData.h
//  Persistence
//
//  Created by Vimal Kini on 3/13/13.
//  Copyright (c) 2013 UC Berkeley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject <NSCoding, NSCopying>

@property (copy, nonatomic) NSString *userID;   
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *userImageURL;
@property (copy, nonatomic) NSArray *toddleFriends;

@end
