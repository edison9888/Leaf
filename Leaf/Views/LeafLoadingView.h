//
//  LeafLoadingView.h
//  Leaf
//
//  Created by roger on 13-1-31.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeafLoadingView : UIView
{
    @private
    UIActivityIndicatorView *_indicator;
}

- (void)startAnimation;

@end
