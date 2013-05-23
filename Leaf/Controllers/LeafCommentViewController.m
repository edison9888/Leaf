//
//  LeafCommentViewController.m
//  Leaf
//
//  Created by roger on 13-4-19.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//
#import "UIColor+MLPFlatColors.h"

#import "LeafCommentViewController.h"
#import "LeafCommentModel.h"
#import "LeafCommentCell.h"
#import "LeafBottomBar.h"
#import "LeafLoadingView.h"
#import "LeafMenuBar.h"
#import "LeafReplyController.h"

#define kLeafCommentBtnH    28.0f
#define kLeafCommentCellTag 1001

@interface LeafCommentViewController ()
{
    NSString* _articleId;
    LeafCommentModel *_commentModel;
    UITableView *_table;
    LeafLoadingView *_loading;
    LeafMenuBar *_menuBar;
    int _curIndex;
}

@property (nonatomic, retain) NSString *articleId;

@end

@implementation LeafCommentViewController
@synthesize articleId = _articleId;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_commentModel release], _commentModel = nil;
    [_articleId release], _articleId = nil;
    [_menuBar release], _menuBar = nil;
    
    _table = nil;
    
    [super dealloc];
}


#pragma mark - LeafCommentModel Notification Stuff

- (void)loadCommentSuccess:(NSNotification *)notification
{
    [self hideLeafLoadingView];
    
    [_commentModel.dataArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        int i = [[(LeafCommentData *)obj1 support] intValue];
        int j = [[(LeafCommentData *)obj2 support] intValue];
        return [__INT(j) compare:__INT(i)];

    }];
    
    [_table reloadData];
    
}


- (void)loadCommentEmpty:(NSNotification *)notification
{
    [self hideLeafLoadingView];
    [self postMessage:@"暂无评论!"];
}

- (void)loadCommentFailed:(NSNotification *)notification
{
    [self hideLeafLoadingView];
    [self postMessage:@"评论加载失败!" type:LeafStatusBarOverlayTypeError];
}

- (void)loadCommentCanceled:(NSNotification *)notification
{
    [self hideLeafLoadingView];
}

#pragma mark - 
#pragma mark - loading view

- (void)showLeafLoadingView
{
    CGPoint center = _loading.center;
    center.y = CGHeight(_loading.frame)/2.0;
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _loading.center = center;
                     }
                     completion:NULL];
    
}


- (void)hideLeafLoadingView
{
    CGPoint center = _loading.center;
    center.y =  -CGHeight(_loading.frame)/2.0f;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _loading.center = center;
                     }
                     completion:NULL];
}


#pragma mark -
#pragma mark - Handle BottomBar Events

- (void)backClicked
{
    [self dismissViewControllerWithOption:LeafAnimationOptionHorizontal
                               completion:^{
                                   [self cancel];
                               }];
}

- (void)commentClicked
{
    LeafReplyController *controller = [[LeafReplyController alloc] init];
    controller.articleId = _articleId;
    [self presentViewController:controller
                         option:LeafAnimationOptionVertical
                     completion:^{
                         self.shouldBlockGesture = YES;
                     }];
    [controller release];
}


- (void)refreshClicked
{
    [self loadData:_articleId];
}

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    LeafBottomBar *bar = [[LeafBottomBar alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(_container.frame) - 40.0f, CGRectGetWidth(_container.frame), 40.0f)];
    bar.leftItemType = LeafBottomBarItemTypeBack;
    bar.midItemType = LeafBottomBarItemTypeWrite;
    bar.rightItemType = LeafBottomBarItemTypeRefresh;
    [bar addLeftTarget:self action:@selector(backClicked)];
    [bar addMidTarget:self action:@selector(commentClicked)];
    [bar addRightTarget:self action:@selector(refreshClicked)];
    
    [_container addSubview:bar];
    [bar release];
    
    __block LeafCommentViewController *controller = self;
    [self enablePanRightGestureWithDismissBlock:^(void){
        [controller cancel];
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, CGRectGetHeight(_container.frame) - 40.0f)];
    tableView.dataSource = self;
    tableView.delegate = self;
    [_container addSubview:tableView];
    _table = tableView;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_table setBackgroundColor:kLeafBackgroundColor];
    [tableView release];
     
    LeafLoadingView *loading = [[LeafLoadingView alloc] initWithFrame:CGRectMake(0.0f, -30.0f, CGWidth(self.view.frame), 30.0f)];
    _loading = loading;
    [_container addSubview:_loading];
    [loading release];

    _menuBar = [[LeafMenuBar alloc] initWithFrame:_container.bounds];
    _menuBar.hidden = YES;
    _menuBar.delegate = (NSObject<LeafMenuBarDelegate> *)self;
    [_container addSubview:_menuBar];
    
     _commentModel = [[LeafCommentModel alloc] init];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(loadCommentSuccess:)
                          name:kLeafLoadCommentSuccess
                        object:_commentModel];
    [defaultCenter addObserver:self
                      selector:@selector(loadCommentEmpty:)
                          name:kLeafLoadCommentEmpty
                        object:_commentModel];

    [defaultCenter addObserver:self
                      selector:@selector(loadCommentFailed:)
                          name:kLeafLoadCommentFailed
                        object:_commentModel];
    [defaultCenter addObserver:self
                      selector:@selector(loadCommentCanceled:)
                          name:kLeafLoadCommentCanceled
                        object:_commentModel];

}

- (void)loadData:(NSString *)articleId
{
    self.articleId = articleId;
    [_commentModel load:articleId];
    [self showLeafLoadingView];
    
}

- (void)cancel
{
    [_commentModel cancel];
}

#pragma mark - 
#pragma mark - UITableViewDataSource UITableViewDelegate 

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentModel.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = indexPath.row;
    NSString *comment = @"";
    if (index >= 0 && index < _commentModel.dataArray.count) {
        LeafCommentData *data = [_commentModel.dataArray objectAtIndex:index];
        comment = data.comment;
    }
    
    return [LeafCommentCell heightForComment:comment];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"LeafCommentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        LeafCommentCell *commentCell = [[LeafCommentCell alloc] init];
        commentCell.tag = kLeafCommentCellTag;
        [cell.contentView addSubview:commentCell];
        [commentCell release];
    }
     LeafCommentCell *commentCell = (LeafCommentCell *)[cell.contentView viewWithTag:kLeafCommentCellTag];
    LeafCommentData *data = [_commentModel.dataArray safeObjectAtIndex:indexPath.row];
    
    
    if (data) {
        NSString *name = data.name;
        if (!data.name || [data.name isEqualToString:@""]) {
            name = @"匿名";
        }

        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", data.time, @"time", data.comment, @"comment", data.support, @"support", data.against, @"against", nil];
        [commentCell loadData:dict];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _curIndex = indexPath.row;
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect rectInSuperView = [tableView convertRect:rectInTableView toView:tableView.superview];
    
    CGFloat minY = CGRectGetMinY(rectInSuperView);
    CGFloat offsetY = 0.0f;
    if (minY > 80.0f) {
        offsetY = minY - 80.0f;
        _menuBar.type = LeafMenuBarArrowTypeDown;
    }
    else{
        CGFloat maxY = CGRectGetMaxY(rectInSuperView);
        offsetY = maxY - 11.0f;
        _menuBar.type = LeafMenuBarArrowTypeUp;

    }
    
    _menuBar.offsetY = offsetY;
    [_menuBar show];

}

#pragma mark -
#pragma mark - LeafMenuBarDelegate

- (void)menuBar:(LeafMenuBar *)menubar didClickedItemWithType:(LeafMenuBarItemType)type
{
    LeafCommentData *data = [_commentModel.dataArray safeObjectAtIndex:_curIndex];
    if (!data) {
        [self postMessage:@"数据错误， 请刷新再试！" type:LeafStatusBarOverlayTypeWarning];
        return;
    }
    if (type == LeafMenuBarItemTypeUp) {
        [self postMessage:@"谢谢您的参与!"];
        [_commentModel support:data.tid];
    }
    else if(type == LeafMenuBarItemTypeDown){
        [self postMessage:@"谢谢您的参与!"];
        [_commentModel against:data.tid];
        

    }
    else if(type == LeafMenuBarItemTypeReply){
        LeafReplyController *controller = [[LeafReplyController alloc] init];
        controller.articleId = _articleId;
        
        [self presentViewController:controller
                             option:LeafAnimationOptionVertical
                         completion:^{
                             self.shouldBlockGesture = YES;
                             controller.tid = data.tid;
                             [controller release];
                         }];
    }
    else if(type == LeafMenuBarItemTypeCopy){
        [self postMessage:@"复制成功!"];
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
        pasteBoard.string = data.comment;
    }
}

@end
