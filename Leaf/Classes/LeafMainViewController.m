//
//  LeafMainViewController.m
//  Leaf
//
//  Created by roger qian on 13-1-25.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafMainViewController.h"
#import "LeafNavigationBar.h"
#import "UIViewController+NSSidebarController.h"
#import "LeafHelper.h"
#import "LeafNewsItem.h"
#import "LeafNewsData.h"

#define kNewsListURL @"http://www.cnbeta.com/api/getNewsList.php?limit=20"
#define kMoreNewsURL @"http://www.cnbeta.com/api/getNewsList.php?fromArticleId=%@&limit=10"
#define kLeafNewsItemTag 1001

@implementation LeafMainViewController


- (void)dealloc
{
    _bar = nil;
    _mask = nil;
    [_leaves release], _leaves = nil;
    [_connection release], _connection = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)homeItemClicked:(id)sender
{
    NSLog(@"back home.");
    [self.sidebarController showLeftController];
    [_mask setHidden:NO];
    
}

- (void)removeMask
{
    [_mask setHidden:YES];
}

- (void)printFonts
{
    NSArray *familyNames = [UIFont familyNames];
    
    for( NSString *familyName in familyNames ){
        
        NSLog(@"font family: %@", familyName);
        
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        
        for( NSString *fontName in fontNames ){            
            NSLog(@"\tFont: %@ \n", fontName);            
        }
        
    }
}


#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    self.view = view;
    [view release];
    
    LeafNavigationBar *bar = [[LeafNavigationBar alloc] init];
    [bar setTitle:@"cnbeta.com"];
    [bar addItemWithStyle:LeafNavigationItemStyleHome target:self action:@selector(homeItemClicked:)];
    _bar = bar;
    [self.view addSubview:bar];
    [bar release];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, CGWidth(self.view.frame), CGHeight(self.view.frame) - 44.0f)];
    _table = tableView;
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_table setAllowsSelection:YES];
    [_table setBackgroundColor:[UIColor colorWithRed:CGColorConvert(236.0f) green:CGColorConvert(234.0f) blue:CGColorConvert(226.0f) alpha:1.0f]];
    [self.view addSubview:tableView];
    [tableView release];
    
    EGORefreshTableHeaderView *header = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, - CGHeight(_table.frame), CGWidth(_table.frame), CGHeight(_table.frame))];
    header.delegate = self;
    _headerView = header;
    [_table addSubview:header];
    [header release];
    
    EGOLoadMoreTableFooterView *footer = [[EGOLoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGWidth(_table.frame), 100.0f) andScrollView:_table];
    _footerView = footer;
    _footerView.delegate = self;
    _footerView.hidden = YES;
    [_table addSubview:_footerView];
    [footer release];
    
    UIView *maskView = [[UIView alloc] initWithFrame:self.view.frame];
    maskView.backgroundColor = [UIColor clearColor];
    _mask = maskView;
    [self.view addSubview:maskView];
    [maskView release];
    [_mask setHidden:YES];   
    
    _leaves = [[NSMutableArray alloc] init];
    _connection = [[LeafURLConnection alloc] init];
    _connection.delegate = self;
    //[self refresh];
    _reloading = NO;
    _loadingMore = NO;
    
    [_headerView pullTheTrigle:_table];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_headerView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_headerView egoRefreshScrollViewDidEndDragging:scrollView];
    [_footerView egoLoadMoreScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadData{
	if (!_loadingMore) {
        [_connection GET:kNewsListURL];
        _reloading = YES;
    }
}

- (void)doneReloadingData{
	
	//  model should call this when its done loading
    _reloading = NO;
	[_headerView egoRefreshScrollViewDataSourceDidFinishedLoading:_table];
}

- (void)loadMoreData
{
    if (_leaves && _leaves.count > 0) {
        LeafNewsData *data = [_leaves lastObject];
        NSString *url = [NSString stringWithFormat:kMoreNewsURL, data.articleId];
        [_connection GET:url];
        
    }

    _loadingMore = YES;
}

- (void)doneLoadingMoreData
{
    _loadingMore = NO;
    [_footerView egoLoadMoreScrollViewDataSourceDidFinishedLoading:_table];
}


#pragma mark -
#pragma egoRefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadData];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}


#pragma mark -
#pragma EGOLoadMoreTableFooterDelegate Methods

- (void)egoLoadMoreTableFooterDidTriggerLoadMore:(EGOLoadMoreTableFooterView *)view
{
    [self loadMoreData];
}

- (BOOL)egoLoadMoreTableFooterDataSourceIsLoading:(EGOLoadMoreTableFooterView *)view
{
    return _loadingMore;
}


#pragma mark - 
#pragma mark - UITableViewDataSource and UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _leaves.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 0 || indexPath.row >= _leaves.count) {
        NSLog(@"error: tableview out of bounds");
        return nil;
    }
    static NSString *identifier = @"Leaf";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];        
        UIView *backColor = [[UIView alloc] initWithFrame:cell.frame];
        backColor.backgroundColor = [UIColor colorWithRed:CGColorConvert(217.0f) green:CGColorConvert(217.0f) blue:CGColorConvert(216.0f) alpha:0.8f];
        cell.selectedBackgroundView = backColor;
        [backColor release];
        LeafNewsItem *item = [[LeafNewsItem alloc] init];
        item.tag = kLeafNewsItemTag;
        [cell.contentView addSubview:item];
        [item release];
    }
    LeafNewsData *data = [_leaves objectAtIndex:indexPath.row];
    LeafNewsItem *leafItem = (LeafNewsItem *)[cell.contentView viewWithTag:kLeafNewsItemTag];
    [leafItem loadData:data];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 0 || indexPath.row >= _leaves.count) {
        NSLog(@"error: tableview out of bounds");
        return;
    }
    NSLog(@"didSelectRowAtIndexPath: %d", indexPath.row);
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 5) {
        [_footerView setFrame:CGRectMake(0.0f, _table.contentSize.height, CGWidth(_footerView.frame), CGHeight(_footerView.frame))];
        _footerView.hidden = NO;
    }
}
#pragma mark -
#pragma mark - Parser JSON Data

- (void)dealWithData:(NSMutableData *)data clearFirst:(BOOL)clear
{
    if (clear) {
        [_leaves removeAllObjects];
    }
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (array) {        
        for (int i = 0; i<array.count; i++) {
            NSDictionary *dict = [array objectAtIndex:i];
            NSLog(@"dict: %@", [dict description]);
            if (dict) {
                LeafNewsData *leaf = [[LeafNewsData alloc] init];
                leaf.theme = [dict stringForKey:@"theme"];
                leaf.pubTime = [dict stringForKey:@"pubtime"];
                leaf.title = [dict stringForKey:@"title"];
                leaf.cmtNum = [dict stringForKey:@"cmtnum"];
                leaf.articleId = [dict stringForKey:@"ArticleID"];
                [_leaves addObject:leaf];
                [leaf release];
            }
        }
        [_table reloadData];
    }
    
}

#pragma mark - 
#pragma mark - LeafURLConnectionDelegate Methods

- (void)didFinishLoadingData:(NSMutableData *)data
{
    if (!data) {
        NSLog(@"error: data is nil.");
        return;
    }
    
    if(_reloading && !_loadingMore) {
        [self dealWithData:data clearFirst:YES];
        [self doneReloadingData];
    }
    else if(_loadingMore && !_reloading) {
        [self dealWithData:data clearFirst:NO];
        [self doneLoadingMoreData];
    }
    
        
}

@end
