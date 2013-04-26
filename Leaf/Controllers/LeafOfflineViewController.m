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

@end


@implementation LeafOfflineViewController
@synthesize hud = _hud;
@synthesize progressBar = _progressBar;
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


#pragma mark - 
#pragma mark - LeafOfflineModel Notification Handel

- (void)leafOfflineFinished:(NSNotification *)notification
{
    __block LeafOfflineViewController *controller = self;
    if (_hud) {
        _hud.dismissBlock = ^(void){
            controller.progressBar.hidden = YES;
            controller.hud = nil;
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            RFHUD *hud = [[RFHUD alloc] initWithFrame:window.bounds];
            [hud setHUDType:RFHUDTypeSuccess andStatus:@"完成离线"];
            [hud show];
            [hud release];
        };
        [_hud close];
    }
    
}

- (void)leafOfflineUpdateProgress:(NSNotification *)notification
{
    [_progressBar setProgress:_model.progress];
}

- (void)leafOfflineFailed:(NSNotification *)notification
{
    [_hud setHUDType:RFHUDTypeError andStatus:@"Network Error"];
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
        [self showDownloadView];
        [_model downloadNews:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
