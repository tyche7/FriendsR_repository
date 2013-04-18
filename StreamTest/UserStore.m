//
//  UserStore.m
//  StreamTest
//
//  Created by Naehee Kim on 3/21/13.
//
//

#import <FacebookSDK/FacebookSDK.h>
#import "UserStore.h"
//#import "StreamAppDelegate.h"
#import "UserData.h"



//local db changes
#define kFilename @"userarchive"
#define kDataKey @"Data"



@implementation UserStore

@synthesize userData;

 static UserStore *userStore = nil;

+ (UserStore *)sharedStore{
   
    if (!userStore) {
        NSLog(@"userStore is allocated **");
        userStore = [[UserStore alloc] init];
        userStore.userData = [[UserData alloc] init];
        
    }
    
    return userStore;
}


+ (void)deleteStore{
    userStore = nil;
}


- (void)fetchUserDataWithCompletion:(void (^)(UserData* userData, NSError *err))block{
    
    
    NSLog(@"In fetchUserDataWithCompletion");
    if (FBSession.activeSession.isOpen) {
           NSLog(@"FBsession is open");
        // this is what populateUserDetails did
     
        
        // remove local data storage for user info
        /*
        NSString *filepath = [self dataFilePath];
        if([[NSFileManager defaultManager] fileExistsAtPath:filepath]){
            NSLog(@"user data available in ios archive");
            NSData *data = [[NSMutableData alloc]
                            initWithContentsOfFile:[self dataFilePath]];
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]
                                             initForReadingWithData:data];
            userData = [unarchiver decodeObjectForKey:kDataKey];
            [unarchiver finishDecoding];
            
            NSLog(@"print object - username %@", userData.username);
            NSLog(@"print object - userID %@", userData.userID);
            
            // After getting user data from internal file system
            // run block code
            // This is the controller's completion code
            block(userData,nil);
            
        }
        else{*/
            NSLog(@"No saved data. Let's get from facebook");
            if (FBSession.activeSession.isOpen)
            {
                [[FBRequest requestForMe] startWithCompletionHandler:
                 ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
                 
                {
                     if (!error) {
                         NSLog(@"user name is %@", user.name);
                         NSLog(@"user id is %@", user.id);
                         NSString *userFullName = [NSString stringWithFormat: @"%@ %@", user.first_name,user.last_name];
                         NSString *userPictureURL = [NSString stringWithFormat: @"https://graph.facebook.com/%@/picture", user.id];
                         NSLog(@"user picture is %@", userPictureURL);
                     
                         //Vimal start
                         //code to send user data to server. Move it if there is better place to put this
                         
                         NSURL *theURL = [NSURL URLWithString:@"http://groups.ischool.berkeley.edu/friendly/uploaduserdata"];
                         
                         
                         NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:theURL
                                                                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                                 timeoutInterval:60];
                         
                         [request setHTTPMethod:@"POST"];
                         
                         // We need to add a header field named Content-Type with a value that tells that it's a form and also add a boundary.
                         // I just picked a boundary by using one from a previous trace, you can just copy/paste from the traces.
                         NSString *boundary = @"----WebKitFormBoundaryDonotknowhatIamdoing";
                         
                         NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
                         
                         [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
                         // end of what we've added to the header
                         
                         // the body of the post
                        
                         NSMutableData *body = [NSMutableData data];
                         
                         
                         [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                         [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                         [body appendData:[[NSString stringWithString:user.id] dataUsingEncoding:NSUTF8StringEncoding]];
                         
                         
                         [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                         [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                         [body appendData:[[NSString stringWithFormat:@"%@",userFullName] dataUsingEncoding:NSUTF8StringEncoding]];
                         
                         
                         [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                         [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userimageurl\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                         [body appendData:[[NSString stringWithString:userPictureURL] dataUsingEncoding:NSUTF8StringEncoding]];
                         
                         
                         // and again the delimiting boundary
                         [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                         
                         // adding the body we've created to the request
                         [request setHTTPBody:body];
                         
                         NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request
                                                                                       delegate:self
                                                                               startImmediately:YES  ];
                         //Vimal end
                     
                     
                     userData.userID = user.id;
                     userData.username = userFullName;
                     userData.userImageURL = userPictureURL;
                     
                     /*NSMutableData *data = [[NSMutableData alloc] init];
                     NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                                  initForWritingWithMutableData:data];
                     [archiver encodeObject:userData forKey:kDataKey];
                     [archiver finishEncoding];
                     
                     [data writeToFile:[self dataFilePath] atomically:YES];
                     NSLog(@"writing to file %@", data);*/
                     
                     // After getting user data,
                     // (1) set the userData property for other controllers to use this data
                     // (2) call the block code
                     // This is the controller's completion code
                     
                     [[UserStore sharedStore] setUserData:userData];
                     block(userData,nil);
                     
                     }
                     
                 }];
            }
        // remove local data storage for user info
       /* }*/
        
        
    }else{
        // if facebook session is not open, return error code
        // need to create err object ****
        
          NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:@"Facebook session is not open" forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"Facebook connection" code:700 userInfo:errorDetail];
        
        // This is the controller's completion code
        block(nil,error);
        
    }
    
}

// need to check
- (void)viewUnDidLoad
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}


-(void) uploadFriendsList:(NSString*)friendList {
    
    NSURL *toddlefriendsURL = [NSURL URLWithString:@"http://groups.ischool.berkeley.edu/friendly/uploadfriendsdata"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:toddlefriendsURL
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"----WebKitFormBoundaryDonotknowhatIamdoingprintingfriendslist";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"friends\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@", friendList] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:userData.userID] dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"userid friends update %@",userData.userID);
    
    // and again the delimiting boundary
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // adding the body we've created to the request
    [request setHTTPBody:body];
    NSURLConnection *newconnection = [[NSURLConnection alloc] initWithRequest:request
                                                                     delegate:self
                                                             startImmediately:YES  ];
    
}


- (void)fetchUserFriendsWithCompletion:(void (^)(NSArray* friendList,NSError *err))block{
    
    // requestFriends

    NSLog(@"In requestFriends");
    
    if (FBSession.activeSession.isOpen) {
        
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id data, NSError *error) {
        if(error) {
            NSLog(@"Error requesting /me/friends");
            
            //This is the controller's completion code
            block(nil,error);
            
            return;
            

        }
        NSString *friendlist = @"";
        
        NSArray* friends = (NSArray*)[data data];
        NSLog(@"You have %d friends", [friends count]);
        
        
        //This is the controller's completion code
        block(nil,nil);
        
        // To store or update friendslist into server side DB,
        // send friends' uid
        
        
        for (int i=0; i<[friends count]; i++){
            //NSLog(@"%@", [friends objectAtIndex:i]);
            NSString *friend_id = [[friends objectAtIndex:i] objectForKey:@"id"];
            
            friendlist = [NSString stringWithFormat: @"%@|%@", friendlist, friend_id];
        }
        //NSLog(@"friendslist: %s",friendlist.UTF8String);
        
        NSURL *toddlefriendsURL = [NSURL URLWithString:@"http://groups.ischool.berkeley.edu/friendly/uploadfriendsdata"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:toddlefriendsURL
                                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                timeoutInterval:60];
        [request setHTTPMethod:@"POST"];
        NSString *boundary = @"----WebKitFormBoundaryDonotknowhatIamdoingprintingfriendslist";
        
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"friends\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%s", friendlist.UTF8String] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:userData.userID] dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"userid friends update %@",userData.userID);
        
        // and again the delimiting boundary
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // adding the body we've created to the request
        [request setHTTPBody:body];
        NSURLConnection *newconnection = [[NSURLConnection alloc] initWithRequest:request
                                                                         delegate:self
                                                                 startImmediately:YES  ];
    }];
    }
    
    
}


- (void)populateUserDetails
{
    
    NSLog(@"In populateUserDetails");
    
	// Do any additional setup after loading the view, typically from a nib.
    // remove local data storage for user info
    //NSString *filepath = [self dataFilePath];
   /* if([[NSFileManager defaultManager] fileExistsAtPath:filepath]){
        NSLog(@"user data available in ios archive");
        NSData *data = [[NSMutableData alloc]
                        initWithContentsOfFile:[self dataFilePath]];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]
                                         initForReadingWithData:data];
        UserData *userData = [unarchiver decodeObjectForKey:kDataKey];
        [unarchiver finishDecoding];
        
        NSLog(@"print object %s", userData.username);

    }
    else{*/
        NSLog(@"No saved data. Let's get from facebook");
        if (FBSession.activeSession.isOpen) {
            [[FBRequest requestForMe] startWithCompletionHandler:
             ^(FBRequestConnection *connection,
               NSDictionary<FBGraphUser> *user,
               NSError *error) {
                 if (!error) {
                     NSLog(@"user name is %@", user.name);
                     NSLog(@"user id is %@", user.id);
                     NSString *userFullName = [NSString stringWithFormat: @"%@%@", user.first_name,user.last_name];
                     NSString *userPictureURL = [NSString stringWithFormat: @"https://graph.facebook.com/%@/picture", user.id];
                     NSLog(@"user picture is %@", userPictureURL);
                 
                 
                 UserData *userdata = [[UserData alloc] init];
                 userdata.userID = user.id;
                 userdata.username = userFullName;

                 userdata.userImageURL = userPictureURL;
                     
                 // remove local data storage for user info
                     
                 /*NSMutableData *data = [[NSMutableData alloc] init];
                 NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                              initForWritingWithMutableData:data];
                 [archiver encodeObject:userdata forKey:kDataKey];
                 [archiver finishEncoding];
                 
                 [data writeToFile:[self dataFilePath] atomically:YES];
                 NSLog(@"writing to file %@", data);*/
                     
                 }
                 
             }];
        }
    // remove local data storage for user info
    /*}*/
    NSLog(@"Exit populatedetails");
}

//local db changes
-(NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"----------***********----------database path is %s", [documentsDirectory UTF8String]);
    return [documentsDirectory stringByAppendingPathComponent:kFilename];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
    NSLog(@"friendsUpload");
    
    [self.delegate friendsUpadteToServerDidFinish];
    
}


@end
