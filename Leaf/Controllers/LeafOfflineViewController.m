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
    RFHUD *_hud;
}

@property (nonatomic, assign, readonly) LeafProgressBar *progressBar;

- (void)showDownloadView;
- (void)dismissDownloadView;

@end


@implementation LeafOfflineViewController
@synthesize progressBar = _progressBar;
@synthesize downloadAtOnce = _downloadAtOnce;

- (void)dealloc
{
    _progressBar = nil;
    _hud = nil;
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
    hud.cancelBlock = ^(void){
        controller.progressBar.hidden = YES;
    };
    [hud show];
    _hud = hud;
    [hud release];
}

- (void)dismissDownloadView
{
    [_hud dismissAfterDelay:0.0f];
}

#pragma mark -
#pragma mark - ViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
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
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
