//
//  LeafCommentViewController.h
//  Leaf
//
//  Created by roger on 13-4-19.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeafCommentViewController : LeafBaseViewController <UITableViewDataSource, UITableViewDelegate>
- (void)loadData:(NSString *)articleId;
@end
