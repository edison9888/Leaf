//
//  LeafOfflineViewController.m
//  Leaf
//
//  Created by roger on 13-4-24.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "DDMenuController.h"
#import "RFHUD.h"

#import "LeafOfflineViewController.h"
#import "LeafOfflineModel.h"
#import "LeafProgressBar.h"
#import "LeafNewsData.h"
#import "LeafNavigationBar.h"
#import "LeafNewsItem.h"
#import "LeafContentViewController.h"

#define kLeafOfflineProgressBarH 2.0f
#define kLeafNewsItemTag 1001


@interface LeafOfflineViewController ()
{
    @private
    LeafProgressBar *_progressBar;
    LeafOfflineModel *_model;
    RFHUD *_hud;
    UITableView *_table;
    NSMutableArray *_leaves;
}
@property (nonatomic, assign) RFHUD *hud;
@property (nonatomic, assign, readonly) LeafProgressBar *progressBar;

- (void)showDownloadView;
- (void)cancel;

@end


@implementation LeafOfflineViewController
@synthesize hud = _hud;
@synthesize progressBar = _progressBar;
@synthesize downloadAtOnce = _downloadAtOnce;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _progressBar = nil;
    _hud = nil;
    _table = nil;
    _leaves = nil;
    [_model release], _model = nil;
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
    RFHUD *hud = [[RFHUD alloc] initWithFrame:frame];
    [hud setHudFont:kLeafFont15];
    [hud setHUDType:RFHUDTypeLoading andStatus:@"正在离线"];
    
    __block LeafOfflineViewController *controller = self;
    hud.dismissBlock = ^(void){
        
        controller.progressBar.hidden = YES;
        controller.hud = nil;
        [controller cancel];
    };
    [hud showInKeyWindow];
    _hud = hud;
    [hud release];
    [_progressBar setProgress:0.0f];
    _progressBar.hidden = NO;
}


#pragma mark - 
#pragma mark - LeafOfflineModel Notification Handel

- (void)leafOfflineFinished:(NSNotification *)notification
{
    __block LeafOfflineViewController *controller = self;
    if (_hud) {
        _hud.dismissBlock = ^(void){
            controller.progressBar.hidden = YES;
            controller.hud = nil;
            RFHUD *hud = [[RFHUD alloc] initWithFrame:kLeafWindowRect];
            [hud setHUDType:RFHUDTypeSuccess andStatus:@"完成离线"];
            [hud showInKeyWindow];
            [hud release];
        };
        [_hud close];
    }
    if (_model.array) {
        _leaves = _model.array;
        [_table reloadData];
    }
    NSLog(@"finished offline");
}

- (void)leafOfflineUpdateProgress:(NSNotification *)notification
{
    [_progressBar setProgress:_model.progress];
}

- (void)leafOfflineFailed:(NSNotification *)notification
{
    __block LeafOfflineViewController *controller = self;
    if (_hud) {
        _hud.dismissBlock = ^(void){
            controller.progressBar.hidden = YES;
            controller.hud = nil;
            RFHUD *hud = [[RFHUD alloc] initWithFrame:kLeafWindowRect];
            [hud setHUDType:RFHUDTypeError andStatus:@"离线失败"];
            [hud showInKeyWindow];
            [hud release];
        };
        [_hud close];
    }
}


#pragma mark - 
- (void)menuItemClicked:(id)sender
{
    DDMenuController *menuController = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showLeftController:YES];
}


#pragma mark -
#pragma mark - ViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _model = [[LeafOfflineModel alloc] init];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(leafOfflineFinished:) name:kLeafOfflineFinished object:_model];
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
