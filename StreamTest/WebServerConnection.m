//
//  WebServerConnection.m
//  StreamTest
//
//  Created by Naehee Kim on 2/28/13.
//
//

#import "WebServerConnection.h"
#import "Rec.h"
#import "Comment.h"
#import "UserStore.h"
#import "UserData.h"

static NSMutableArray *sharedConnectionList = nil;

@implementation WebServerConnection
@synthesize request, completionBlock, saveCommentCompletionBlock ,fetchedRecommendationsAtConnection, fetchedCommentsAtConenction ,connectionType, statusCode;

- (id)initWithRequest:(NSURLRequest *)req
{
    self = [super init];
    if (self){
        [self setRequest:req];
    }
    return self;
}

- (void)start
{
    // Initialize container for data collected from NSURLConnection
    container = [[NSMutableData alloc] init];
    
    NSLog(@"In WebServerConnection: %@", request);
    
    // Spawn connection
    internalConnection = [[NSURLConnection alloc] initWithRequest:[self request] delegate:self startImmediately:YES];
    
    // If this is the first connection started, create the array
    if (!sharedConnectionList)sharedConnectionList = [[NSMutableArray alloc] init];
    
    // Add the connection to the array so it doesn't get destroyed
    [sharedConnectionList addObject:self];
}

// This method will be called several times as the data arrives

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    
    if ([response isKindOfClass: [NSHTTPURLResponse class]]) {
        statusCode = [(NSHTTPURLResponse*) response statusCode];
        /* HTTP Status Codes
         200 OK
         400 Bad Request
         401 Unauthorized (bad username or password)
         403 Forbidden
         404 Not Found
         502 Bad Gateway
         503 Service Unavailable  ***
         */
    }
    [container setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [container appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    statusCode = 0; // Status code is not valid with this kind of error, which is typically a timeout or no network error.
    
    NSLog(@"didFailWithError");
    
    // pass the error from the connection to the completionBlock
    if ([self completionBlock])
        [self completionBlock](nil,error);
    
    // Destroy this conenction
    [sharedConnectionList removeObject:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded!! Received %d bytes of data",[container length]);
    
    
    // before parsing, check if statusCode is 400, 404, or 503
    // if so, pass the error through the completionBolck
    // then return early.
    
    
    if (statusCode == 400 || statusCode == 404 || statusCode == 503) {
        
        NSLog(@"Web connection error code: %d", statusCode);
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:@"Failed to connect web server" forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"web connection" code:statusCode userInfo:errorDetail];
        
        // pass the error from the connection to the completionBlock
        if ([self completionBlock])
            [self completionBlock](nil,error);
    }
    else {
        
        // else if there is no web conenctio error
        // parse the received data
        
        
        
        // convert to JSON
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:container options:NSJSONReadingMutableLeaves error:&myError];
        
        // show all values
        
        for(id key in res) {
            
            id value = [res objectForKey:key];
            
            NSString *keyAsString = (NSString *)key;
            NSString *valueAsString = (NSString *)value;
            
            NSLog(@"key: %@", keyAsString);
            NSLog(@"value: %@", valueAsString);
        }
        
        
        //set DateFormatter
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        // extract specific value...
        NSArray *results = [res objectForKey:@"items"];
        
        switch (self.connectionType) {
            case STREAMVIEWCONTROLLER_REC:
                
                fetchedRecommendationsAtConnection = [[NSMutableArray alloc] init];
                
                for (NSDictionary *result in results) {
                    
                    
                    Rec* rec = [[Rec alloc] init ];
                    [rec setRecId:[result objectForKey:@"entryid"]];
                    [rec setFileName:[result objectForKey:@"name"]]; //file name: eg) "bibim.jpg"
                    [rec setUserName:[result objectForKey:@"user"]];
                    [rec setUserId:[[result objectForKey:@"userid"] intValue]];
                    [rec setPostText:[result objectForKey:@"text"]];
                    [rec setProductName:[result objectForKey:@"productName"]];
                    [rec setBrandName:[result objectForKey:@"brandName"]];
                    [rec setPurchasePlace:[result objectForKey:@"purchasePlace"]];
                    [rec setPrice:[result objectForKey:@"price"]];
                    [rec setRating:[[result objectForKey:@"rating"] intValue]];
                    [rec setPurchasePlaceType:[[result objectForKey:@"purchasePlaceType"] intValue]];
                    [rec setAgeBand:[[result objectForKey:@"ageBand"] intValue]];
                    
                    NSString *timestampString = [result objectForKey:@"create_time"];
                    [rec setDate:[dateFormatter dateFromString:timestampString]];
                    //NSLog(@"timestampString: %@", timestampString);
                    
                    
                    [fetchedRecommendationsAtConnection addObject:rec];
                    
                } //end for
                
                
                
                // pass "fectedRecs" to the completion block - remember, this is the block that the controller supplied.
                if ([self completionBlock])
                    [self completionBlock]([self fetchedRecommendationsAtConnection], nil);
                
                
                break;
                
            case DETAILVIEWCONTROLLER_CMT:
                
                fetchedCommentsAtConenction = [[NSMutableArray alloc] init];
                
                for (NSDictionary *result in results) {
                    // NSString *icon = [result objectForKey:@"name"];
                    
                    //NSLog(@"comment: %@", [result objectForKey:@"comment"]);
                    
                    
                    Comment* comment = [[Comment alloc] init ];
                    [comment setCommentId:[result objectForKey:@"id"]];
                    
                    [comment setUserName:[result objectForKey:@"user"]];
                    [comment setUserId:[result objectForKey:@"userid"]];
                    
                    [comment setComment:[result objectForKey:@"comment"]];
                    
                    [fetchedCommentsAtConenction addObject:comment];
                    
                } //end for
                
                // pass "fectedComments" to the completion block - remember, this is the block that the controller supplied.
                if ([self completionBlock])
                    [self completionBlock]([self  fetchedCommentsAtConenction], nil);
                
                break;
                
                
            case DETAILVIEWCONTROLLER_ADDCMT:
                
                
                if ([self saveCommentCompletionBlock])
                    [self saveCommentCompletionBlock](nil, nil);
                break;
                
            default:
                break;
        }
        
    }
    
    
    // Now destroy this connection
    [sharedConnectionList removeObject:self];
    
    
}


- (void)postComment:(NSString *)comment WithEntryId:(NSString *)entryId{
    
    UserStore *userStore = [UserStore sharedStore];
    
    
    NSURL *theURL = [NSURL URLWithString:@"http://tyche92.pythonanywhere.com/comments/add"];
    
    
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] initWithURL:theURL
                                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                timeoutInterval:60];
    
    [postRequest setHTTPMethod:@"POST"];
    
    // We need to add a header field named Content-Type with a value that tells that it's a form and also add a boundary.
    // I just picked a boundary by using one from a previous trace, you can just copy/paste from the traces.
    NSString *boundary = @"----WebKitFormBoundarycC4YiaUFwM44F6rT";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    [postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    // end of what we've added to the header
    
    // the body of the post
    NSMutableData *body = [NSMutableData data];
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[userStore.userData.username dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@",userStore.userData.userID] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"entryid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[entryId dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"comment\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:comment] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // and again the delimiting boundary
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // adding the body we've created to the request
    [postRequest setHTTPBody:body];
    
    
    
    
    
    // Initialize container for data collected from NSURLConnection
    container = [[NSMutableData alloc] init];
    
    // Spawn connection
    internalConnection =      [[NSURLConnection alloc] initWithRequest:postRequest
                                                              delegate:self
                                                      startImmediately:YES  ];
    
    // If this is the first connection started, create the array
    if (!sharedConnectionList)sharedConnectionList = [[NSMutableArray alloc] init];
    
    // Add the connection to the array so it doesn't get destroyed
    [sharedConnectionList addObject:self];
    
    
    
    
}

@end
