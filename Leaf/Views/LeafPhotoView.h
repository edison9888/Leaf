//
//  LeafPhotoView.h
//  Leaf
//
//  Created by roger on 13-4-3.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeafPhotoView : UIView <UIScrollViewDelegate>
{
    @private
    UIScrollView *_scrollView;
    UIImageView *_imageView;
    UIActivityIndicatorView *_loadingView;
}

@property (nonatomic, assign, readonly) UIImageView *imageView;

- (void)setURL:(NSURL *)url;
- (void)resetFrame;
@end
