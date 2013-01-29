//
//  LeafContentViewController.h
//  Leaf
//
//  Created by roger on 13-1-29.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeafContentViewController : UIViewController
{
    NSURL *_url;
}

- (id)initWithUrl:(NSURL *)url;
@end
