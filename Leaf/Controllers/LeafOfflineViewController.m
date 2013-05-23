//
//  LeafOfflineViewController.m
//  Leaf
//
//  Created by roger on 13-4-24.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "DDMenuController.h"
#import "UIColor+MLPFlatColors.h"

#import "LeafOfflineViewController.h"
#import "LeafOfflineModel.h"
#import "LeafProgressBar.h"
#import "LeafNewsData.h"
#import "LeafNavigationBar.h"
#import "LeafNewsItem.h"
#import "LeafContentViewController.h"
#import "LeafConfig.h"

#define kLeafOfflineProgressBarH 2.0f
#define kLeafNewsItemTag 1001


@interface LeafOfflineViewController ()
{
    @private
    LeafProgressBar *_progressBar;
    LeafOfflineModel *_model;
    
    UITableView *_table;
    UIView *_empty;
    
    NSMutableArray *_leaves;
}

@property (nonatomic, assign, readonly) LeafProgressBar *progressBar;

- (void)showDownloadView;
- (void)cancel;

@end


@implementation LeafOfflineViewController
@synthesize progressBar = _progressBar;
@synthesize downloadAtOnce = _downloadAtOnce;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self cancel];
    [_model release], _model = nil;

    _progressBar = nil;
    _table = nil;
    _leaves = nil;
        
    [super dealloc];
}

- (void)cancel
{
    if (_model) {
        [_model cancel];
    }
}

#pragma mark -
#pragma mark - Offline Download View Stuff

- (void)showDownloadView
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect frame = window.bounds;
    frame.size.height -= kLeafOfflineProgressBarH;
    [self showHUD:RFHUDTypeLoading status:@"正在离线"];
    __block LeafOfflineViewController *controller = self;
    [self setDismissBlockForHUD:^(void){
        controller.progressBar.hidden = YES;
        [controller cancel];
    }];
    
    [_progressBar setProgress:0.0f];
    _progressBar.hidden = NO;
}

- (void)reload
{
    if (_model.array) {
        _leaves = _model.array;
        [_table reloadData];
    }
}

#pragma mark - 
#pragma mark - LeafOfflineModel Notification Handel

- (void)leafOfflineFinished:(NSNotification *)notification
{
    
    if (![self isHUDHiden]) {
        __block LeafOfflineViewController *controller = self;
        [self setDismissBlockForHUD:^(void){
            [controller postMessage:@"完成离线!" type:LeafStatusBarOverlayTypeSuccess];
            controller.progressBar.hidden = YES;
        }];
        [self dismissHUD];

    }
    _empty.hidden = YES;
    LeafConfig *config = [LeafConfig sharedInstance];
    config.offline = YES;
    [self reload];
    NSLog(@"finished offline");
}

- (void)leafOfflineState:(NSNotification *)notification
{
    LeafConfig *config = [LeafConfig sharedInstance];
    if (!config.offline) {
        [self postMessage:@"离线未完成!" type:LeafStatusBarOverlayTypeWarning];
        _empty.hidden = NO;
    }
    else {
        [self reload];
    }
}

- (void)leafOfflineUpdateProgress:(NSNotification *)notification
{
    [_progressBar setProgress:_model.progress];
}

- (void)leafOfflineFailed:(NSNotification *)notification
{
    __block LeafOfflineViewController *controller = self;
    [self setDismissBlockForHUD:^(void){
            controller.progressBar.hidden = YES;
            [controller postMessage:@"离线失败!" type:LeafStatusBarOverlayTypeError];
    }];
        
    [self dismissHUD];
}


#pragma mark - 
- (void)menuItemClicked:(id)sender
{
    DDMenuController *menuController = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showLeftController:YES];
}


- (void)tap:(UIGestureRecognizer *)recognizer
{
    [self showDownloadView];
    [_model downloadNews:YES];
}


#pragma mark -
#pragma mark - ViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _model = [[LeafOfflineModel alloc] init];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(leafOfflineFinished:) name:kLeafOfflineFinished object:_model];
    [notificationCenter addObserver:self selector:@selector(leafOfflineState:) name:kLeafOfflineState object:_model];
    [notificationCenter addObserver:self selector:@selector(leafOfflineUpdateProgress:) name:kLeafOfflineUpdateProgress object:_model];
    [notificationCenter addObserver:self selector:@selector(leafOfflineFailed:) name:kLeafOfflineFailed object:_model];
    
    LeafNavigationBar *bar = [[LeafNavigationBar alloc] init];
    [bar setTitle:@"离线新闻"];
    [bar addLeftItemWithStyle:LeafNavigationItemStyleMenu target:self action:@selector(menuItemClicked:)];
    [_container addSubview:bar];
    [bar release];

    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 44.0f) style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [table setAllowsSelection:YES];
    table.backgroundColor = kLeafBackgroundColor;
    _table = table;
    [_container addSubview:table];
    [table release];
    
    LeafProgressBar *progressBar = [[LeafProgressBar alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(_container.frame) - kLeafOfflineProgressBarH, CGRectGetWidth(_container.frame), kLeafOfflineProgressBarH)];
    [_container addSubview:progressBar];
    _progressBar = progressBar;
    [progressBar release];
    _progressBar.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    
    UIView *empty = [[UIView alloc] initWithFrame:_container.bounds];
    empty.backgroundColor = [UIColor clearColor];
    empty.hidden = YES;
    [empty addGestureRecognizer:tap];
    [tap release];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 15.0f)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor flatBlackColor];
    label.font = kLeafFont15;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"点击屏幕,完成离线";
    label.center = CGPointMake(CGRectGetWidth(empty.frame)/2.0f, CGRectGetHeight(empty.frame)/2.0f);
    [empty addSubview:label];
    _empty = empty;
    [label release];
    [_container addSubview:empty];
    [empty release];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_downloadAtOnce) {
        [self showDownloadView];
        [_model downloadNews:YES];
        NSLog(@"begin offline.");
    }
    else {
        [_model downloadNews:NO];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark - UITableViewDataSource and UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // full mode
    return 92.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_leaves) {
        return _leaves.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_leaves || indexPath.row < 0 || indexPath.row >= _leaves.count) {
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
    [leafItem loadData:data withStyle:LeafItemStyleFull];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_leaves || indexPath.row < 0 || indexPath.row >= _leaves.count) {
        NSLog(@"error: tableview out of bounds");
        return;
    }
    LeafNewsData *data = [_leaves safeObjectAtIndex:indexPath.row];
    if (data) {
        LeafContentViewController *vc = [[LeafContentViewController alloc] initWithLeafData:data];
        vc.view.frame = self.view.bounds;
        [self presentViewController:vc option:LeafAnimationOptionHorizontal completion:^{
            [self blockDDMenuControllerGesture:YES];
            [vc GET];
        }];
        [vc release];
        NSLog(@"after vc release.");
    }
}


@end
