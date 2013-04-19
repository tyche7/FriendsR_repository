//
//  UserData.m
//  Persistence
//
//  Created by Vimal Kini on 3/13/13.
//  Copyright (c) 2013 UC Berkeley. All rights reserved.
//

#import "UserData.h"

#define kUserIDKey @"UserID"
#define kUserNameKey @"UserName"
#define kUserImageURLKey @"UserImageURL"


@implementation UserData

@synthesize userID;
@synthesize username;
@synthesize userImageURL;
@synthesize toddleFriends;

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)enCoder{
    [enCoder encodeObject:userID forKey:kUserIDKey];
    [enCoder encodeObject:username forKey:kUserNameKey];
    [enCoder encodeObject:userImageURL forKey:kUserImageURLKey];
}

-(id)initWithCoder:(NSCoder *)decoder{
    if(self = [super init]){
        userID = [decoder decodeObjectForKey:kUserIDKey];
        username = [decoder decodeObjectForKey:kUserNameKey];
        userImageURL = [decoder decodeObjectForKey:kUserImageURLKey];
        
    }
    return  self;
}

#pragma mark -
#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone {
    UserData *copy = [[[self class] allocWithZone:zone] init];
    copy.userID = [self.userID copyWithZone:zone];
    copy.username = [self.username copyWithZone:zone];
    copy.userImageURL = [self.userImageURL copyWithZone:zone];
    return copy;
}

@end

