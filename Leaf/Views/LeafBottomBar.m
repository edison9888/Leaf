//
//  LeafBottomBar.m
//  Leaf
//
//  Created by roger on 13-4-3.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafBottomBar.h"

@implementation LeafBottomBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
        bg.image = [UIImage imageNamed:@"bottom_bg"];
        [self addSubview:bg];
        [bg setUserInteractionEnabled:YES];
        
        UIImage *retImg = [UIImage imageNamed:@"photo_return"];
        UIButton *photoRetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [photoRetBtn setImage:retImg forState:UIControlStateNormal];
        photoRetBtn.frame = CGRectMake(0.0f, 0.0f, retImg.size.width, retImg.size.height);;
        _returnBtn = photoRetBtn;
        [bg addSubview:photoRetBtn];
        [bg release];
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action
{
    [_returnBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
