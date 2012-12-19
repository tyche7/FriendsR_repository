//
//  StreamViewController.h
//  StreamTest
//
//  Created by Naehee Kim on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class DetailViewController;

@interface StreamViewController : UITableViewController{
    
    NSMutableArray *recs;


}

@property (nonatomic, strong) NSMutableArray *recs;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) IBOutlet DetailViewController *detailController;






@end
