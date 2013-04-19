//
//  WebServerConnection.h
//  StreamTest
//
//  Created by Naehee Kim on 2/28/13.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    STREAMVIEWCONTROLLER_REC,
    DETAILVIEWCONTROLLER_CMT
    
}CONNECTION_TYPE;


@interface WebServerConnection : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSURLConnection *internalConnection;
    NSMutableData *container;
}

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, copy) void (^completionBlock)(NSMutableArray* recArray, NSError *err);
@property (nonatomic, strong) NSMutableArray *fetchedRecommendationsAtConnection;
@property (nonatomic, strong) NSMutableArray *fetchedCommentsAtConenction;
@property (nonatomic) int connectionType;
@property (nonatomic) int statusCode;

- (id)initWithRequest:(NSURLRequest *)req;
- (void)start;

@end
