//
//  UserStore.h
//  StreamTest
//
//  Created by Naehee Kim on 3/21/13.
//
//

#import <Foundation/Foundation.h>


@protocol FriendsUpdateDelegate <NSObject>

-(void)friendsUpadteToServerDidFinish;

@end

@class UserData;


@interface UserStore : NSObject <NSURLConnectionDelegate>



@property (strong, nonatomic) UserData *userData;
@property (weak, nonatomic) id <FriendsUpdateDelegate> delegate;


+ (UserStore *)sharedStore;
+ (void)deleteStore;




- (void)fetchUserDataWithCompletion:(void (^)(UserData* userData,NSError *err))block;
- (void)fetchUserFriendsWithCompletion:(void (^)(NSArray* friendList,NSError *err))block;


//local DB chnages
-(NSString *)dataFilePath;
//-(void)applicationWillResignActive:(NSNotification *)notification;



@end

