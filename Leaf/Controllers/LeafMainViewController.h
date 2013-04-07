//
//  LeafMainViewController.h
//  Leaf
//
//  Created by roger qian on 13-1-25.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGOLoadMoreTableFooterView.h"
#import "LeafURLConnection.h"
#import "LeafBaseViewController.h"

@class LeafNavigationBar, ASINetworkQueue;
@interface LeafMainViewController : LeafBaseViewController<UITableViewDelegate, UITableViewDataSource, EGORefreshTableHeaderDelegate, EGOLoadMoreTableFooterDelegate, LeafURLConnectionDelegate>
{
    
    LeafNavigationBar *_bar;
    LeafURLConnection *_connection;
    UITableView *_table;
    NSMutableArray *_leaves;
    BOOL _loadingMore;
    BOOL _reloading;
    EGORefreshTableHeaderView *_headerView;
    EGOLoadMoreTableFooterView *_footerView;
    int _count;
}

- (void)downloadNews;

@end
