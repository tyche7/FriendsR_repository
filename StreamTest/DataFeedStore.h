//
//  DataFeedStore.h
//  StreamTest
//
//  Created by Naehee Kim on 2/28/13.
//
//

#import <Foundation/Foundation.h>


@interface DataFeedStore : NSObject

@property (nonatomic, strong) NSDate *cacheDate;

+ (DataFeedStore *)sharedStore;

- (NSMutableArray *)fetchRecommendationsWithCompletion:(void (^)(NSMutableArray* fetchedRecommendations, NSError *err))block;

- (void)fetchCommentswithRecommendationId:(NSString *)recId  withCompletion:(void (^)(NSMutableArray* fetchedComments, NSError *err))block;

@end
