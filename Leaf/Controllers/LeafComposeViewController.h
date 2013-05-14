//
//  LeafComposeViewController.h
//  Leaf
//
//  Created by roger on 13-5-3.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeafComposeViewController : LeafBaseViewController <UITextViewDelegate, SinaWeiboRequestDelegate>
{
    NSString *_themeUrl;
    NSString *_articleUrl;
}

@property (nonatomic, retain) NSString *themeUrl;
@property (nonatomic, retain) NSString *articleUrl;

- (void)setStatus:(NSString *)status;
- (void)setImage:(UIImage *)image;

@end
