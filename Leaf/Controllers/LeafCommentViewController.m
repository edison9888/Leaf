//
//  LeafCommentViewController.m
//  Leaf
//
//  Created by roger on 13-4-19.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafCommentViewController.h"
#import "LeafCommentModel.h"
#import "LeafCommentCell.h"

#define kLeafCommentCellTag 1001

@interface LeafCommentViewController ()
{
    LeafCommentModel *_commentModel;
    UITableView *_table;
}

@end

@implementation LeafCommentViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_commentModel release], _commentModel = nil;
    _table = nil;
    [super dealloc];
}


#pragma mark - LeafCommentModel Notification Stuff

- (void)loadCommentSuccess:(NSNotification *)notification
{
    LeafCommentModel *model = (LeafCommentModel *)notification.object;
    if (model) {
        [_table reloadData];
    }
}

- (void)loadCommentFailed:(NSNotification *)notification
{
    
}

- (void)loadCommentCanceled:(NSNotification *)notification
{
    
}



#pragma mark - ViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _commentModel = [[LeafCommentModel alloc] init];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(loadCommentSuccess:)
                          name:kLeafLoadCommentSuccess
                        object:_commentModel];
    
    [defaultCenter addObserver:self
                      selector:@selector(loadCommentFailed:)
                          name:kLeafLoadCommentFailed
                        object:_commentModel];
    [defaultCenter addObserver:self
                      selector:@selector(loadCommentCanceled:)
                          name:kLeafLoadCommentCanceled
                        object:_commentModel];
    
    [self enablePanLeftGestureWithDismissBlock:NULL];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, CGRectGetHeight(self.view.frame))];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    _table = tableView;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_table setAllowsSelection:NO];
    [_table setBackgroundColor:kLeafBackgroundColor];

    [tableView release];
    
}

- (void)loadData:(NSString *)articleId
{
    [_commentModel load:articleId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
               
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", data.time, @"time", data.comment, @"comment", nil];
        [commentCell loadData:dict];
    }
    
    return cell;
}

@end
