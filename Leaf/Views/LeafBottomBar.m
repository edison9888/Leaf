//
//  LeafBottomBar.m
//  Leaf
//
//  Created by roger on 13-4-3.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafBottomBar.h"

#define kLeafBottomBtnMarginTop 5.0f
#define kLeafBottomBtnMarginLeft 15.0f
#define kLeafBottomBtnMarginRight 15.0f


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
        photoRetBtn.frame = CGRectMake(kLeafBottomBtnMarginLeft, kLeafBottomBtnMarginTop, retImg.size.width, retImg.size.height);;
        _returnBtn = photoRetBtn;
        [bg addSubview:photoRetBtn];
        
        UIImage *saveImg = [UIImage imageNamed:@"photo_save"];
        UIButton *photoSaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [photoSaveBtn setImage:saveImg forState:UIControlStateNormal];
        photoSaveBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - kLeafBottomBtnMarginRight - saveImg.size.width, kLeafBottomBtnMarginTop, saveImg.size.width, saveImg.size.height);
        _saveBtn = photoSaveBtn;
        [bg addSubview:photoSaveBtn];
        [bg release];
    }
    return self;
}

- (void)addLeftTarget:(id)target action:(SEL)action
{
    [_returnBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)addRightTarget:(id)target action:(SEL)action
{
    [_saveBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
