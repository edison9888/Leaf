//
//  LeafMainViewController.m
//  Leaf
//
//  Created by roger qian on 13-1-25.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafMainViewController.h"
#import "LeafNavigationBar.h"
#import "LeafConfig.h"
#import "DDMenuController.h"
#import "LeafHelper.h"
#import "LeafNewsItem.h"
#import "LeafNewsData.h"
#import "LeafContentViewController.h"
#import "LeafPhotoViewController.h"

#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "ASIWebPageRequest.h"
#import "ASIDownloadCache.h"

#define kNewsListURL @"http://www.cnbeta.com/api/getNewsList.php?limit=20"
#define kDownloadNewsListURL @"http://www.cnbeta.com/api/getNewsList.php?limit=50"
#define kMoreNewsURL @"http://www.cnbeta.com/api/getNewsList.php?fromArticleId=%@&limit=10"
#define kArticleUrl  @"http://www.cnbeta.com/api/getNewsContent2.php?articleId=%@"

#define kLeafNewsItemTag 1001
#define kScaleFactor 0.02f
#define kAlphaFactor 0.1f

@implementation LeafMainViewController

- (void)dealloc
{
    _bar = nil;
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

- (void)showLeftController:(BOOL)animated
{
    DDMenuController *menuController = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showLeftController:animated];
}

- (void)menuItemClicked:(id)sender
{
    [self showLeftController:YES];
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"simple"]){
        [_table reloadData];
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
        
    LeafNavigationBar *bar = [[LeafNavigationBar alloc] init];
    [bar setTitle:@"cnbeta.com"];
    [bar addLeftItemWithStyle:LeafNavigationItemStyleMenu target:self action:@selector(menuItemClicked:)];
    _bar = bar;
    [_container addSubview:bar];
    [bar release];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, CGWidth(_container.frame), CGHeight(_container.frame) - 44.0f)];
    _table = tableView;
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_table setAllowsSelection:YES];
    [_table setBackgroundColor:kLeafBackgroundColor];
    [_container addSubview:tableView];
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
    
    _leaves = [[NSMutableArray alloc] init];
    _connection = [[LeafURLConnection alloc] init];
    _connection.delegate = self;
    _reloading = NO;
    _loadingMore = NO;
    
    [_headerView pullTheTrigle:_table];
    
    /*
    LeafContentView *contentView = [[LeafContentView alloc] initWithFrame:CGRectMake(CGWidth(self.view.frame), 0.0f, CGWidth(self.view.frame), CGHeight(self.view.frame))];
    [self.view addSubview:contentView];
    _contentView = contentView;
    _contentView.delegate = (NSObject<LeafContentViewDelegate> *)self;
    [contentView release];
    [_contentView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [_contentView addObserver:self forKeyPath:@"mask" options:NSKeyValueObservingOptionNew context:NULL]; 
    */
     
    LeafConfig *config = [LeafConfig sharedInstance];
    [config addObserver:self forKeyPath:@"simple" options:NSKeyValueObservingOptionNew context:NULL];
    
    //[self downloadNews];
}

- (void)viewWillAppear:(BOOL)animated
{
    _connection.delegate = self;
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_connection cancel];
    _connection.delegate = nil;
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
    if (!_reloading) {
        if (_leaves && _leaves.count > 0) {
            LeafNewsData *data = [_leaves lastObject];
            NSString *url = [NSString stringWithFormat:kMoreNewsURL, data.articleId];
            [_connection GET:url];
        }
        _loadingMore = YES;
    }
    
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
    LeafConfig *config = [LeafConfig sharedInstance];
    if (config.simple) {
        return 80.0f;
    }
    // full mode        
    return 92.0f;
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
    LeafConfig *config = [LeafConfig sharedInstance];
    if (config.simple) {
        [leafItem loadData:data withStyle:LeafItemStyleSimple];
    }
    else{
        [leafItem loadData:data withStyle:LeafItemStyleFull];
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 0 || indexPath.row >= _leaves.count) {
        NSLog(@"error: tableview out of bounds");
        return;
    }
    LeafNewsData *data = [_leaves safeObjectAtIndex:indexPath.row];
    if (data) {       
        NSString *url = [NSString stringWithFormat:kArticleUrl, data.articleId];
        LeafContentViewController *vc = [[LeafContentViewController alloc] initWithURL:url];
        vc.view.frame = self.view.bounds;
        [self presentViewController:vc option:LeafAnimationOptionHorizontal completion:^{
            [vc GET];
        }];
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 5) {
        [_footerView setFrame:CGRectMake(0.0f, _table.contentSize.height - 1.0f, CGWidth(_footerView.frame), CGHeight(_footerView.frame))];
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

- (void)stopLoadingAnimation
{
    if (_reloading && !_loadingMore) {
        [self doneReloadingData];
    }
    else if(_loadingMore && !_reloading){
        [self doneLoadingMoreData];
    }
}

#pragma mark - 
#pragma mark - LeafURLConnectionDelegate Methods

- (void)didFinishLoadingData:(NSMutableData *)data
{
    if (!data) {
        NSLog(@"error: data is nil.");
        [self stopLoadingAnimation];
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

- (void)didFailWithError:(NSError *)error
{
    [self stopLoadingAnimation];
}

- (void)connectionDidCancel
{
    [self stopLoadingAnimation];
}



#pragma mark - 
#pragma mark - Download The Latest 50 News

- (void)fetchURL:(NSURL *)url
{
    ASIWebPageRequest *_request = [ASIWebPageRequest requestWithURL:url];
    
	[_request setDidFailSelector:@selector(webPageFetchFailed:)];
	[_request setDidFinishSelector:@selector(webPageFetchSucceeded:)];
	[_request setDelegate:self];
	[_request setDownloadProgressDelegate:self];
	[_request setUrlReplacementMode:ASIReplaceExternalResourcesWithLocalURLs];
	
	// It is strongly recommended that you set both a downloadCache and a downloadDestinationPath for all ASIWebPageRequests
	[_request setDownloadCache:[ASIDownloadCache sharedCache]];
	[_request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    
	// This is actually the most efficient way to set a download path for ASIWebPageRequest, as it writes to the cache directly
    [_request setCacheStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
	[_request setDownloadDestinationPath:[[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:_request]];
	
	[[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
    [_request startAsynchronous];
}

- (void)downloadNewsInfo
{
   // NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:kNewsListURL]];
    NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kDownloadNewsListURL]] returningResponse:nil error:nil];
    if (data) {
       
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (array) {
            for (int i = 0; i<array.count; i++) {
                NSDictionary *dict = [array objectAtIndex:i];
                
                if (dict) {     
                    NSString *articleId = [dict stringForKey:@"ArticleID"];
                    if (articleId && ![articleId isEqualToString:@""]) {
                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kArticleUrl, articleId]];
                        [self fetchURL:url];
                    }
                }
            }            
        }
    }
}

- (void)downloadNews
{
    _count = 0;
    [self performSelectorInBackground:@selector(downloadNewsInfo) withObject:nil];
}



- (void)webPageFetchFailed:(ASIHTTPRequest *)theRequest
{
	
}

- (void)webPageFetchSucceeded:(ASIHTTPRequest *)theRequest
{
    
	NSURL *baseURL;
	// If we're using ASIReplaceExternalResourcesWithLocalURLs, we must set the baseURL to point to our locally cached file
    baseURL = [NSURL fileURLWithPath:[theRequest downloadDestinationPath]];
    
	if ([theRequest downloadDestinationPath]) {
		NSString *response = [NSString stringWithContentsOfFile:[theRequest downloadDestinationPath] encoding:[theRequest responseEncoding] error:nil];
        NSLog(@"WebPage: %@", response);
        _count++;
        NSLog(@"count: %d", _count);
    }
}

#pragma mark -
#pragma mark - LeafContentViewDelegate

- (void)imgLinkClicked:(NSArray *)urls cur:(NSString *)url
{
    int index = 0;
    for (int i = 0; i < urls.count; i++) {
        if ([url isEqualToString:[urls objectAtIndex:i]]) {
            index = i;
        }
    }
    LeafPhotoViewController *vc = [[LeafPhotoViewController alloc] initWithURLs:urls];
    [vc setCurIndex:index];
    [self presentViewController:vc animated:YES completion:NULL];
    [vc release];
    
}

@end
