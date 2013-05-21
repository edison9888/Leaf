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
    NSString *_url;
    NSString *_articleURL;
}

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *articleURL;
- (void)setStatus:(NSString *)status;


@end
