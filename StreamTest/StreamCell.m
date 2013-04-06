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
@synthesize image, rating, ageBand;
@synthesize picView, ratingView;
@synthesize productNameAndPurchasePlace;




#define kNameTag 1
#define kDateTag 2
#define kPostTag 3
#define kImageTag 4
#define kRatingImageTag 5
#define kProductLabelTag 6
#define kAgeLabelTag 7

#define love 0
#define hate 1

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGRect frameRect = CGRectMake(10, 5, 300, 310);
        UIView *frameView = [[UIView alloc] initWithFrame:frameRect];
        frameView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:frameView];
        
        
        CGRect nameLabelRect = CGRectMake(30,5,150,15);
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameLabelRect];
        nameLabel.textAlignment = UITextAlignmentLeft;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.tag = kNameTag;
        nameLabel.font = [UIFont boldSystemFontOfSize:14];
        nameLabel.textColor = [UIColor grayColor];
        [frameView addSubview:nameLabel];
        
        CGRect dateLabelRect = CGRectMake(210, 5, 70, 15);
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:dateLabelRect];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textAlignment = UITextAlignmentRight;
        dateLabel.tag = kDateTag;
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.font = [UIFont boldSystemFontOfSize:14];
        [frameView addSubview:dateLabel];
        
        /* commendted out for MVP version
        CGRect postRect = CGRectMake(10, 25, 300, 60);
        UITextView *postView = [[UITextView alloc] initWithFrame:postRect];
        //postView.textAlignment = UITextAlignmentCenter;
        postView.text = @"Recommendation";
        postView.tag = kPostTag;
        postView.font = [UIFont fontWithName:@"Helvetica" size:14];
        [postView setEditable:NO];
        [self.contentView addSubview:postView];
         */
        
        CGRect imageRect = CGRectMake(30, 30, 240, 240);
        
        picView = [[UIImageView alloc] initWithFrame:imageRect];
        //http://stackoverflow.com/questions/3182649/ios-sdk-uiviewcontentmodescaleaspectfit-vs-uiviewcontentmodescaleaspectfill
        picView.contentMode = UIViewContentModeScaleAspectFit;
        //imageView.contentMode = UIViewContentModeScaleAspectFill;
        picView.clipsToBounds = YES;
        picView.tag =kImageTag;
        [frameView addSubview:picView];
        
        
        CGRect transparentAgeRect = CGRectMake(50, 230, 240, 20);
        UILabel *ageLabel = [[UILabel alloc] initWithFrame:transparentAgeRect];
        ageLabel.textAlignment = UITextAlignmentCenter;
        ageLabel.tag = kAgeLabelTag;
        ageLabel.backgroundColor = [UIColor clearColor];
        ageLabel.alpha = 0.f; //0.f transparent <- -> 1.f opaque
        ageLabel.font = [UIFont systemFontOfSize:14];
        ageLabel.textColor = [UIColor whiteColor];
        [frameView addSubview:ageLabel];
        
        
        CGRect productNameLabelRect = CGRectMake(10, 280, 300, 20);
        UILabel *productNameLabel = [[UILabel alloc] initWithFrame:productNameLabelRect];
        productNameLabel.textAlignment = UITextAlignmentCenter;
        productNameLabel.backgroundColor = [UIColor clearColor];
        productNameLabel.tag = kProductLabelTag;
        productNameLabel.adjustsFontSizeToFitWidth = YES;
        productNameLabel.minimumFontSize = 13;
        
        productNameLabel.font = [UIFont boldSystemFontOfSize:14];
        
        [frameView addSubview:productNameLabel];
        
        CGRect ratingRect = CGRectMake(30, 280, 20, 25);
        
        ratingView = [[UIImageView alloc] initWithFrame:ratingRect];
        ratingView.contentMode = UIViewContentModeScaleAspectFill;
        ratingView.tag =kRatingImageTag;
        [frameView addSubview:ratingView];
        
        
        
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

- (void)setProductNameAndPurchasePlace:(NSString *)p{
    if (![p isEqualToString:productNameAndPurchasePlace]) {
        productNameAndPurchasePlace = [p copy];
        UILabel *productLabel = (UILabel *)[self.contentView viewWithTag:kProductLabelTag];
        productLabel.text = productNameAndPurchasePlace;
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

- (void)setRating:(int )r{

        UIImageView *rView = (UIImageView *)[self.contentView viewWithTag:kRatingImageTag];
    
        if (r == love) {  //love
            rView.image = [UIImage imageNamed:@"love.png"];

        }else //hate
        {
            rView.image = [UIImage imageNamed:@"hate.png"];
        }

}

- (void)setAgeBand:(int )age{
    
    UILabel *ageLabel = (UILabel *)[self.contentView viewWithTag:kAgeLabelTag];
    NSString *ageRange = [[NSString alloc] init];

    // age range
    if (age!= 0){        
        ageLabel.alpha = 0.5f;
   
        switch (age) {
            case 1: //newborn
                ageRange = @"for Newborns";
                break;
            case 2: //infant
                ageRange = @"for Infants";
                break;
            case 3: //toddler
                ageRange = @"for Toddlers";
                break;
            case 4: //kid
                ageRange = @"for Kids";
                break;
            case 5: //all ages
                ageRange = @"for All Ages";
                break;
            case 6: //mom
                ageRange = @"for Preparing Mothers";
                break;
            default:
                break; //do nothing
        }
        
  
    }else{ //age is out of range
        ageLabel.alpha = 0.0f;
        ageRange = @"";
    }
    
    ageLabel.text = ageRange;

}



@end
