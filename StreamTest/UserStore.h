//
//  UserStore.h
//  StreamTest
//
//  Created by Naehee Kim on 3/21/13.
//
//

#import <Foundation/Foundation.h>

@class UserData;


@interface UserStore : NSObject



@property (strong, nonatomic) UserData *userData;

+ (UserStore *)sharedStore;


- (void)fetchUserDataWithCompletion:(void (^)(UserData* userData,NSError *err))block;
- (void)fetchUserFriendsWithCompletion:(void (^)(NSArray* friendList,NSError *err))block;


//local DB chnages
-(NSString *)dataFilePath;
-(void)applicationWillResignActive:(NSNotification *)notification;



@end

