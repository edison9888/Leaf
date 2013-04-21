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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_commentModel release], _commentModel = nil;
    [super dealloc];
}


#pragma mark - LeafCommentModel Notification Stuff

- (void)loadCommentSuccess:(NSNotification *)notification
{
    LeafCommentModel *model = (LeafCommentModel *)notification.object;
    if (model) {
        NSArray *array = model.dataArray;
        if (array.count > 0) {
            LeafCommentData *data = (LeafCommentData *)[array objectAtIndex:0];
            UILabel *comment = [[UILabel alloc] initWithText:data.comment font:kLeafFont13 textColor:[UIColor blackColor] andOrigin:CGPointMake(10.0f, 20.0f)];
            [self.view addSubview:comment];
            [comment release];
        }
        
        for (LeafCommentData *data in array){
            NSLog(@"%@ %@: %@", data.time, data.name, data.comment);
        }
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
