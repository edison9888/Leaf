//
//  LeafOfflineViewController.m
//  Leaf
//
//  Created by roger on 13-4-24.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "RFHUD.h"

#import "LeafOfflineViewController.h"
#import "LeafOfflineModel.h"
#import "LeafProgressBar.h"


#define kLeafOfflineProgressBarH 2.0f

@interface LeafOfflineViewController ()
{
    @private
    LeafProgressBar *_progressBar;
    LeafOfflineModel *_model;
    RFHUD *_hud;
}
@property (nonatomic, assign) RFHUD *hud;
@property (nonatomic, assign, readonly) LeafProgressBar *progressBar;

- (void)showDownloadView;
- (void)dismissHUDAfterDelay:(float)delay;

@end


@implementation LeafOfflineViewController
@synthesize progressBar = _progressBar;
@synthesize hud = _hud;
@synthesize downloadAtOnce = _downloadAtOnce;

- (void)dealloc
{
    _progressBar = nil;
    _hud = nil;
    [_model release], _model = nil;
    [super dealloc];
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
    };
    [hud show];
    _hud = hud;
    [hud release];
    _progressBar.hidden = NO;
}

- (void)dismissHUDAfterDelay:(float)delay
{
    if (_hud) {
        [_hud dismissAfterDelay:delay];
    }
}


#pragma mark - 
#pragma mark - LeafOfflineModel Notification Handel

- (void)leafOfflineFinished:(NSNotification *)notification
{
    [_hud setHUDType:RFHUDTypeSuccess andStatus:@"已完成离线"];
    [self dismissHUDAfterDelay:2.0f];
}

- (void)leafOfflineUpdateProgress:(NSNotification *)notification
{
    NSLog(@"progress: %f", _model.progress);
    [_progressBar setProgress:_model.progress];
}

- (void)leafOfflineFailed:(NSNotification *)notification
{
    [_hud setHUDType:RFHUDTypeError andStatus:@"Network Error"];
    [self dismissHUDAfterDelay:2.0f];
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
        [_model downloadNews:YES];
        [self showDownloadView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
