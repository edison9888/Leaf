//
//  LeafComposeViewController.m
//  Leaf
//
//  Created by roger on 13-5-3.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafComposeViewController.h"

#define kLeafMaxWeiboLen 140

@interface LeafComposeViewController ()
{
    UIButton *_confirmBtn;
    UIImageView *_shareImageView;
    UITextView *_statusTextView;
    UILabel *_remainLabel;
}
@end

@implementation LeafComposeViewController


- (void)dealloc
{
    _confirmBtn = nil;
    _shareImageView = nil;
    _statusTextView = nil;
    _remainLabel = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark - Button Events

- (void)cancelClicked:(id)sender
{
    [_statusTextView resignFirstResponder];
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
    if(!status){
        NSLog(@"status is nil.");
        return;
    }
    [_statusTextView setText:status];
    NSRange range = NSMakeRange(0, 0);
    _statusTextView.selectedRange =range;
    int remainLen = kLeafMaxWeiboLen - status.length;
    _remainLabel.text = [NSString stringWithFormat:@"%d", remainLen];
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


#pragma mark -

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
    _confirmBtn = confirmBtn;
    
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
    _statusTextView = textView;
    [shareBg addSubview:textView];
    [textView release];
    
    UIImageView *shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(shareBg.bounds) - 60.0f, 0.0f, 60.0f, 60.0f)];
    _shareImageView = shareImageView;
    [shareBg addSubview:shareImageView];
    [shareImageView release];
    
    UIImageView *shareClip = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_shareImageView.frame) - 16.0f, 5.0f, 27.0f, 27.0f)];
    [shareClip setImage:[UIImage imageNamed:@"share_clip"]];
    [_shareImageView addSubview:shareClip];
    [shareClip release];
    
    UILabel *remainLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_shareImageView.frame), CGRectGetMaxY(_shareImageView.frame), 60.0f, 20.0f)];
    _remainLabel = remainLabel;
    _remainLabel.textAlignment = UITextAlignmentCenter;
    _remainLabel.backgroundColor = [UIColor clearColor];
    _remainLabel.font = kLeafFont15;
    _remainLabel.textColor = [UIColor blackColor];
    [shareBg addSubview:remainLabel];
    [remainLabel release];

    
    [shareBg release];
    [shareView release];
    
    [_statusTextView becomeFirstResponder];
}


#pragma mark -
#pragma mark - UITextViewDelegate Methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"textView text: %@", textView.text);
    NSLog(@"replacementText: %@", text);
    
    
    int value = kLeafMaxWeiboLen - textView.text.length - range.length;
    if (value < 0) {
        _remainLabel.textColor = [UIColor redColor];
        [_confirmBtn setEnabled:NO];
    }
    else
    {
        _remainLabel.textColor = [UIColor blackColor];
        [_confirmBtn setEnabled:YES];
    }
    _remainLabel.text = [NSString stringWithFormat:@"%d", value];
    return YES;
}


@end
