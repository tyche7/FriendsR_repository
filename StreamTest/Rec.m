//
//  Rec.m
//  StreamTest
//
//  Created by Naehee Kim on 10/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Rec.h"

@implementation Rec

@synthesize recId, userId, userName, date, userImage, postTitle, postText, productName, productImage, brandName, purchasePlace, price, additionalInfo, comments, imagePlace, fileName, rating, purchasePlaceType, ageBand;

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:recId forKey:@"recId"];
    [aCoder encodeInt:userId forKey:@"userId"];
    [aCoder encodeObject:userName forKey:@"userName"];
    [aCoder encodeObject:date forKey:@"date"];
    [aCoder encodeObject:userImage forKey:@"userImage"];
    [aCoder encodeObject:postTitle forKey:@"postTitle"];
    [aCoder encodeObject:postText forKey:@"postText"];
    [aCoder encodeObject:productName forKey:@"productName"];
    [aCoder encodeObject:productImage forKey:@"productImage"];
    [aCoder encodeObject:brandName forKey:@"brandName"];
    [aCoder encodeObject:purchasePlace forKey:@"purchasePlace"];
    [aCoder encodeObject:price forKey:@"price"];
    [aCoder encodeObject:additionalInfo forKey:@"additionalInfo"];
    [aCoder encodeObject:comments forKey:@"comments"];
    [aCoder encodeObject:imagePlace forKey:@"imagePlace"];
    [aCoder encodeObject:fileName forKey:@"fileName"];
    [aCoder encodeInt:rating forKey:@"rating"];
    [aCoder encodeInt:purchasePlaceType forKey:@"purchasePlaceType"];
    [aCoder encodeInt:ageBand forKey:@"ageBand"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    
    if(self){
        [self setRecId:[aDecoder decodeObjectForKey:@"recId"]];
        [self setUserId:[aDecoder decodeIntForKey:@"userId"]];
        [self setUserName:[aDecoder decodeObjectForKey:@"userName"]];
        [self setDate:[aDecoder decodeObjectForKey:@"date"]];
        [self setUserImage:[aDecoder decodeObjectForKey:@"userImage"]];
        [self setPostTitle:[aDecoder decodeObjectForKey:@"postTitle"]];
        [self setPostText:[aDecoder decodeObjectForKey:@"postText"]];
        [self setProductName:[aDecoder decodeObjectForKey:@"productName"]];
        [self setProductImage:[aDecoder decodeObjectForKey:@"productImage"]];
        [self setBrandName:[aDecoder decodeObjectForKey:@"brandName"]];
        [self setPurchasePlace:[aDecoder decodeObjectForKey:@"purchasePlace"]];
        [self setPrice:[aDecoder decodeObjectForKey:@"price"]];
        [self setAdditionalInfo:[aDecoder decodeObjectForKey:@"additionalInfo"]];
        [self setComments:[aDecoder decodeObjectForKey:@"comments"]];
        [self setImagePlace:[aDecoder decodeObjectForKey:@"imagePlace"]];
        [self setFileName:[aDecoder decodeObjectForKey:@"fileName"]];
        [self setRating:[aDecoder decodeIntForKey:@"rating"]];
        [self setPurchasePlaceType:[aDecoder decodeIntForKey:@"purchasePlaceType"]];
        [self setAgeBand:[aDecoder decodeIntForKey:@"ageBand"]];
         
    }
    
    return self;
}


@end
