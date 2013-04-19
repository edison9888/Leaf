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

@interface LeafCommentViewController ()
{
    LeafCommentModel *_commentModel;
}

@end

@implementation LeafCommentViewController


#pragma mark - LeafCommentModel Notification Stuff

- (void)loadCommentSuccess:(NSNotification *)notification
{
    LeafCommentModel *model = (LeafCommentModel *)notification.object;
    if (model) {
        
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCommentSuccess:) name:kLeafLoadCommentSuccess object:_commentModel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCommentFailed:) name:kLeafLoadCommentFailed object:_commentModel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCommentCanceled:) name:kLeafLoadCommentCanceled object:_commentModel];
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

@end
