//
//  StreamCell.m
//  StreamTest
//
//  Created by Naehee Kim on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// reference: iphone 5 programming - book

#import "StreamCell.h"

    

@implementation StreamCell

@synthesize name;
@synthesize date;
@synthesize post;
@synthesize image;
@synthesize picView;


#define kNameTag 1
#define kDateTag 2
#define kPostTag 3
#define kImageTag 4

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect nameLabelRect = CGRectMake(10,5,150,15);
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameLabelRect];
        nameLabel.textAlignment = UITextAlignmentLeft;
        //nameLabel.text = @"user name";
        nameLabel.tag = kNameTag;
        nameLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:nameLabel];
        
        CGRect dateLabelRect = CGRectMake(240, 5, 70, 15);
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:dateLabelRect];
        dateLabel.textAlignment = UITextAlignmentRight;
        //dateLabel.text = @"Oct 25";
        dateLabel.tag = kDateTag;
        dateLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:dateLabel];
        
        CGRect postRect = CGRectMake(10, 25, 300, 60);
        UITextView *postView = [[UITextView alloc] initWithFrame:postRect];
        //postView.textAlignment = UITextAlignmentCenter;
        postView.text = @"Recommendation";
        postView.tag = kPostTag;
        postView.font = [UIFont fontWithName:@"Helvetica" size:14];
        [postView setEditable:NO];
        [self.contentView addSubview:postView];
        
        CGRect imageRect = CGRectMake(30, 90, 260, 195);
        //CGRect imageRect = CGRectMake(40, 90, 160, 120);
        
        picView = [[UIImageView alloc] initWithFrame:imageRect];
        //http://stackoverflow.com/questions/3182649/ios-sdk-uiviewcontentmodescaleaspectfit-vs-uiviewcontentmodescaleaspectfill
        picView.contentMode = UIViewContentModeScaleAspectFit;
        //imageView.contentMode = UIViewContentModeScaleAspectFill;
        picView.clipsToBounds = YES;
        picView.tag =kImageTag;
        [self.contentView addSubview:picView];
        
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setName:(NSString *)n{
    if (![n isEqualToString:name]){
        name = [n copy];
        UILabel *nameLabel = (UILabel *)[self.contentView viewWithTag:kNameTag];
        nameLabel.text = name;
    }
}

- (void)setDate:(NSString *)d{
    if (![d isEqualToString:date]){
        date = [d copy];
        UILabel *dateLabel = (UILabel *)[self.contentView viewWithTag:kDateTag];
        dateLabel.text = date;
    }
}

- (void)setPost:(NSString *)p{
    if (![p isEqualToString:post]){
        post = [p copy];
        UITextView *postView = (UITextView *)[self.contentView viewWithTag:kPostTag];
        postView.text = post;
        
    }
}

    
- (void)setImage:(UIImage *)i{
    //to do
    
    UIImageView *detailPicView = (UIImageView *)[self.contentView viewWithTag:kImageTag];
    
    // the code below adjust the frame size according to the actual picture size.
    
    CGRect newimageRect = picView.frame;
    newimageRect.size.width = i.size.width + 10;
    newimageRect.size.height = i.size.height + 10;
    picView.frame = newimageRect;
    
    detailPicView.image = i;
}


@end
