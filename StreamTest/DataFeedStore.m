//
//  DataFeedStore.m
//  StreamTest
//
//  Created by Naehee Kim on 2/28/13.
//
//

#import "UserStore.h"
#import "UserData.h"
#import "DataFeedStore.h"
#import "WebServerConnection.h"

@implementation DataFeedStore

+ (DataFeedStore *)sharedStore{
    static DataFeedStore *feedStore = nil;
    if (!feedStore) {
        feedStore = [[DataFeedStore alloc] init];
    }
    
    return feedStore;
}


- (NSMutableArray* )fetchRecommendationsWithCompletion:(void (^)(NSMutableArray* fetchedRecommendations, NSError *err))block
{
    
    
    // Construct the cache path
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    cachePath = [cachePath stringByAppendingPathComponent:@"applearchive"];
    NSLog(@"cache path %@",cachePath);
    // Load the cached data
    
    NSMutableArray* cachedRecArray = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
    
    // If there is not cached data, create an empty array to fill up
    if (!cachedRecArray) {
        cachedRecArray = [[NSMutableArray alloc] init];
    }
    
    __block NSMutableArray *recArrayCopy = [cachedRecArray copy];
    
    //Make sure that we already have userinfo at UserStore before using it here
    
    
    
    NSString* userid = [[[UserStore sharedStore] userData] userID];
    NSLog(@"userID: %@", userid);
    
    NSString *urlString = [NSString stringWithFormat:@"http://tyche92.pythonanywhere.com/entries"];
    
    if (userid)
        urlString = [NSString stringWithFormat:@"http://tyche92.pythonanywhere.com/entries/userid/%@", userid];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // create an empty array
    NSMutableArray *fetchedRecsMadeInStore = [[NSMutableArray alloc] init];
    
    // create a connection "actor" object that will transfer data from the server
    WebServerConnection *connection = [[WebServerConnection alloc] initWithRequest:request];
    
    // when the connection completes, this block from the controller will be called
    //[connection setCompletionBlock:block];
    
    [connection setCompletionBlock:^(NSMutableArray *recArray, NSError *err){
        //This is the store's completion code
        //IF everythin went smoothly, save the rec Array to disk and set cache date
        
        if(!err){
            recArrayCopy = recArray;
            [NSKeyedArchiver archiveRootObject:recArrayCopy toFile:cachePath];
        }
        
        // This is the controller's completion code:
        block(recArrayCopy,err);
    }];
    
    
    // Let ... parse the returning data from the web service
    [connection setFetchedRecommendationsAtConnection:fetchedRecsMadeInStore];
    
    //set connection type
    [connection setConnectionType:STREAMVIEWCONTROLLER_REC];
    
    //Begin the connection
    [connection start];
    
    
    NSLog(@"size of the cached rec.. array:%d",[cachedRecArray count]);
    return cachedRecArray;
    
}
- (void)fetchCommentswithRecommendationId:(NSString *)recId withCompletion:(void (^)(NSMutableArray* fetchedComments, NSError *err))block
{
    
    // get user's comments
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://tyche92.pythonanywhere.com/comments/entryid/%@", recId];
    
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // create an empty array
    NSMutableArray *fetchedCommentsInStore = [[NSMutableArray alloc] init];
    
    // create a connection "actor" object that will transfer data from the server
    WebServerConnection *connection = [[WebServerConnection alloc] initWithRequest:request];
    
    // when the connection completes, this block from the controller will be called
    [connection setCompletionBlock:block];
    
    // Let ... parse the returning data from the web service
    [connection setFetchedRecommendationsAtConnection:fetchedCommentsInStore];
    
    //set connection type
    [connection setConnectionType:DETAILVIEWCONTROLLER_CMT];
    
    //Begin the connection
    [connection start];
    
}

- (void)setCacheDate:(NSDate *)cacheDate{
    [[NSUserDefaults standardUserDefaults] setObject:cacheDate forKey:@"cacheDate"];
}

- (NSDate *)cacheDate{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"cacheDate"];
}

@end
