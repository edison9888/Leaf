//
//  LeafPhotoViewController.m
//  Leaf
//
//  Created by roger on 13-4-3.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafPhotoViewController.h"
#import "LeafPhotoView.h"
#import "LeafBottomBar.h"
#import "LeafHelper.h"
#import "LeafPhotoProgressBar.h"

#define kLeafBottomProgressBarH 2.0f

@interface LeafPhotoViewController ()
{
    UIScrollView *_scrollView;
    LeafPhotoProgressBar *_progressBar;
    int _cur;
}

@property (nonatomic, retain) NSArray *urls;
@property (nonatomic, retain) NSMutableArray *photoViews;

- (void)loadScrollViewWithPage:(int)page;
- (void)setProgress:(int)index;
@end

@implementation LeafPhotoViewController
@synthesize urls = _urls;
@synthesize photoViews = _photoViews;
- (void)dealloc
{
    [_urls release], _urls = nil;
    [_photoViews release], _photoViews = nil;
    _scrollView = nil;
    _progressBar = nil;
    [super dealloc];
}

- (id)initWithURLs:(NSArray *)urls
{
    self = [super init];
    if (self) {
        
        self.urls = urls;
    }
    
    return self;
}

- (void)setCurIndex:(int)index
{
    _cur = index;
}

#pragma mark - 

- (void)returnClicked:(id)sender
{
    [self dismissViewControllerWithOption:LeafAnimationOptionVertical
                               completion:^void{
                                   self.parentController.shouldBlockGesture = NO;
                               }];
}


#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGWidth(self.view.bounds), CGHeight(self.view.bounds) - kLeafBottomProgressBarH)];
    _scrollView = scrollView;
    _scrollView.delegate = self;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _scrollView.multipleTouchEnabled=YES;
    _scrollView.scrollEnabled=YES;
    _scrollView.directionalLockEnabled=YES;
    _scrollView.canCancelContentTouches=YES;
    _scrollView.delaysContentTouches=YES;
    _scrollView.clipsToBounds=YES;
    _scrollView.alwaysBounceHorizontal=YES;
    _scrollView.bounces=YES;
    _scrollView.pagingEnabled=YES;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.contentSize = CGSizeMake(CGWidth(_scrollView.frame) * (_urls.count > 0 ? _urls.count : 1), CGHeight(_scrollView.frame));
    [_container addSubview:_scrollView];
    [scrollView release];
    
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < _urls.count; i++) {
        [views addObject:[NSNull null]];
    }
    self.photoViews = views;
    [views release];
    
    LeafBottomBar *bottom = [[LeafBottomBar alloc] initWithFrame:CGRectMake(0.0f, CGHeight(self.view.frame) - 40.0f - kLeafBottomProgressBarH, CGWidth(self.view.frame), 40.0f)];
    [_container addSubview:bottom];
    [bottom addTarget:self action:@selector(returnClicked:)];
    [bottom release];
    
    LeafPhotoProgressBar *progressBar = [[LeafPhotoProgressBar alloc] initWithFrame:CGRectMake(0.0f, CGHeight(self.view.frame) - kLeafBottomProgressBarH, CGWidth(self.view.frame), kLeafBottomProgressBarH)];
    [_container addSubview:progressBar];
    _progressBar = progressBar;
    [progressBar release];
    
    [self setProgress:_cur];
    
    [self loadScrollViewWithPage:_cur - 1];
    [self loadScrollViewWithPage:_cur];
    [self loadScrollViewWithPage:_cur + 1];
    //_scrollView.contentOffset.x = cur * _scrollView.frame.size.width;
    CGRect visibleRect = _scrollView.bounds;
    visibleRect.origin.x = _cur * _scrollView.frame.size.width;
    [_scrollView scrollRectToVisible:visibleRect animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)setProgress:(int)index
{
    CGFloat progress = 0.0f;
    if (_urls && _urls.count > 0) {
        progress = (CGFloat)(index + 1 )/_urls.count;
    }
    
    [_progressBar setProgress:progress];

}

#pragma mark -
#pragma scrollview stuff

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0 || page >= _urls.count) {
        return;
    }
    
    LeafPhotoView *photo = [_photoViews safeObjectAtIndex:page];
    if ([photo isKindOfClass:[NSNull class]]) {
        LeafPhotoView *photoView = [[LeafPhotoView alloc] initWithFrame:_scrollView.bounds];
        [_photoViews replaceObjectAtIndex:page withObject:photoView];
        photo = photoView;
        NSString *url = [_urls safeObjectAtIndex:page];
        if (url) {
            NSLog(@"url:%@", url);
           [photoView setURL:[NSURL URLWithString:url]];
        }
        
        [photoView release];
    }
    
    if (photo && photo.superview == nil) {
        CGRect frame = _scrollView.frame;
        frame.origin.x = CGWidth(_scrollView.frame) * page;
        frame.origin.y = 0;
        photo.frame = frame;
        [_scrollView addSubview:photo];
    }
}

- (void)resetFrame:(int)page
{
    if (page < 0 || page >= _urls.count) {
        return;
    }
    LeafPhotoView *photo = [_photoViews safeObjectAtIndex:page];
    if (photo && [photo isKindOfClass:[LeafPhotoView class]]) {
        [photo resetFrame];
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    
    int page = floor((scrollView.contentOffset.x - pageWidth/2) / pageWidth) + 1;
    [self loadScrollViewWithPage:page -1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    [self resetFrame:page - 1];
    [self resetFrame:page + 1];
    _cur = page;
    
   
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setProgress:_cur];
}


@end