//
//  Comment.h
//  StreamTest
//
//  Created by Kim on 12/21/12.
//
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSDate *createDate;


@end
