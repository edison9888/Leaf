//
//  LeafPhotoView.m
//  Leaf
//
//  Created by roger on 13-4-3.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafPhotoView.h"
#import "LeafHelper.h"
#import "UIImageView+WebCache.h"

@implementation LeafPhotoView
@synthesize imageView = _imageView;

- (void)dealloc
{
    _scrollView = nil;
    _imageView = nil;
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView = scrollView;
        [self addSubview:scrollView];
        [scrollView release];
        _scrollView.scrollEnabled = YES;
		_scrollView.pagingEnabled = NO;
		_scrollView.clipsToBounds = NO;
		_scrollView.maximumZoomScale = 3.0f;
		_scrollView.minimumZoomScale = 1.0f;
		_scrollView.showsVerticalScrollIndicator = NO;
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.alwaysBounceVertical = NO;
		_scrollView.alwaysBounceHorizontal = NO;
		_scrollView.bouncesZoom = YES;
		_scrollView.bounces = YES;
		_scrollView.scrollsToTop = NO;
		_scrollView.backgroundColor = [UIColor clearColor];
		_scrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
		_scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        CGRect frame = CGRectInset(self.bounds, 10.0f, 20.0f);
        _imageView = imageView;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:imageView];
        [imageView release];
        
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.frame = CGRectMake(0.0f, 0.0f, 22.0f, 22.0f);
        loadingView.center = CGPointMake(CGWidth(_imageView.frame)/2.0f, CGHeight(_imageView.frame)/2.0f);
        _loadingView = loadingView;
        [_imageView addSubview:loadingView];
        [loadingView release];
    }
    return self;
}

- (void)setURL:(NSURL *)url
{
    [_loadingView startAnimating];
    [_imageView setImageWithURL:url
                        success:^(UIImage *image) {
                            [_loadingView stopAnimating];
                            _imageView.image = image;
                        }
                        failure:^(NSError *error) {
        
                        }];
}

@end
