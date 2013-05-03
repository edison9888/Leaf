//
//  LeafComposeViewController.m
//  Leaf
//
//  Created by roger on 13-5-3.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafComposeViewController.h"

@interface LeafComposeViewController ()
{
    UIImageView *_shareImageView;
    UITextView *_textView;
}
@end

@implementation LeafComposeViewController


#pragma mark -
#pragma mark - Button Events

- (void)cancelClicked:(id)sender
{
    [_textView resignFirstResponder];
    [self dismissViewControllerWithOption:LeafAnimationOptionVertical
                               completion:^{
        _parentController.shouldBlockGesture = NO;
    }];
}

- (void)confirmClicked:(id)sender
{
    
}

#pragma mark - 

- (UIImage *)scaleImage:(UIImage *)image
{
    CGRect cropRect = CGRectMake(0.0f, 0.0f , 320.0f, 320.0f);
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, cropRect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    return result;
}

- (void)setStatus:(NSString *)status
{
    [_textView setText:status];
    NSRange range = NSMakeRange(0, 0);
    _textView.selectedRange =range;
}

- (void)setShareImage:(UIImage *)image
{
    UIImage *scaledImage = [self scaleImage:image];
    _shareImageView.image = scaledImage;
}

/*
- (void)share:(UIImage *)image
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    if (sinaweibo.isAuthValid) {
        NSString *status = [NSString stringWithFormat:@"%@ -- (来自 Leaf)", _articleTitle];
        [sinaweibo requestWithURL:@"statuses/upload.json"
                           params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   status, @"status",
                                   image, @"pic", nil]
                       httpMethod:@"POST"
                         delegate:self];
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor clearColor];
    _container.hidden = YES;
    _mask.hidden = YES;
    
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 70.0f, 320.0f, CGRectGetHeight(self.view.bounds) - 70.0f)];
    shareView.backgroundColor = kLeafBackgroundColor;
    shareView.userInteractionEnabled = YES;
    [self.view addSubview:shareView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(12.0f, 18.0f, 16.0f, 16.0f)];
    [cancelBtn setImage:[UIImage imageNamed:@"share_cancel"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:cancelBtn];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setFrame:CGRectMake(282.0f, 16.0f, 21.0f, 17.0f)];
    [confirmBtn setImage:[UIImage imageNamed:@"share_ok"] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:confirmBtn];
    
    UIImageView *shareBg = [[UIImageView alloc] initWithFrame:CGRectMake(14.0f, 48.0f, 284.0f, 81.0f)];
    [shareBg setImage:[UIImage imageNamed:@"share_content_background"]];
    [shareBg setUserInteractionEnabled:YES];
    [shareView addSubview:shareBg];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 1.0f, 210, 79.0f)];
    textView.backgroundColor = [UIColor clearColor];
    textView.delegate = self;
    textView.font = kLeafFont15;
    textView.keyboardAppearance = UIKeyboardAppearanceDefault;
    textView.keyboardType = UIKeyboardTypeDefault;
    textView.scrollEnabled = YES;
    textView.showsVerticalScrollIndicator = YES;
    textView.userInteractionEnabled = YES;
    _textView = textView;
    [shareBg addSubview:_textView];
    [textView release];
    
    UIImageView *shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(218.0f, 0.0f, 60.0f, 60.0f)];
    _shareImageView = shareImageView;
    [shareBg addSubview:shareImageView];
    [shareImageView release];
    
    UIImageView *shareClip = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_shareImageView.frame) - 16.0f, 5.0f, 27.0f, 27.0f)];
    [shareClip setImage:[UIImage imageNamed:@"share_clip"]];
    [_shareImageView addSubview:shareClip];
    [shareClip release];
    
    [shareBg release];
    [shareView release];
    
    [_textView becomeFirstResponder];
}



@end
