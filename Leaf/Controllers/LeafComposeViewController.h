//
//  LeafComposeViewController.h
//  Leaf
//
//  Created by roger on 13-5-3.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeafComposeViewController : LeafBaseViewController <UITextViewDelegate, SinaWeiboRequestDelegate>

- (void)setStatus:(NSString *)status;
- (void)setImage:(UIImage *)image;

@end
