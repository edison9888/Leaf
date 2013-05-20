//
//  LeafReplyController.m
//  Leaf
//
//  Created by roger on 13-5-17.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafReplyController.h"
#import "ASIHTTPRequest.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"


#define kLeafReplyHTTPBody @"tid=%@&sid=%@&valimg_main=%@&comment=%@&nowsubject=&nowpage=1&nowemail=cryrivers@cnbeta.com"

@interface LeafReplyController ()
{
    UIButton *_confirmBtn;
    UITextView *_statusTextView;
    UIImageView *_valimg;
    UITextField *_verify;
}

@end

@implementation LeafReplyController
@synthesize articleId = _articleId;

- (void)dealloc
{
    [_articleId release], _articleId = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark - Event Handler

- (void)cancelClicked:(id)sender
{
    [self dismissViewControllerWithOption:LeafAnimationOptionVertical
                               completion:NULL];
}


- (void)confirmClicked:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://www.cnbeta.com/Ajax.comment.php?ver=new"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    NSString *body = [NSString stringWithFormat:kLeafReplyHTTPBody, @"0", _articleId, _verify.text, [_statusTextView.text stringByEncodeCharacterEntities]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=utf-8"];
    [request appendPostData:[[body urlEncode]  dataUsingEncoding:NSUTF8StringEncoding]];
    [request startAsynchronous];
}

#pragma mark -
#pragma mark - Controller Lifecycle

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
    
    UIImageView *cancelIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_cancel"]];
    cancelIcon.center = CGPointMake(22.0f, 22.0f);
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(0.0f, 2.0f, 44.0f, 44.0f)];
    [cancelBtn setBackgroundImage:[UIImage imageWithColor:kLeafHighlightColor] forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn addSubview:cancelIcon];
    [shareView addSubview:cancelBtn];
    [cancelIcon release];
    
    UIImageView *confirmIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_ok"]];
    confirmIcon.center = CGPointMake(22.0f, 22.0f);
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setFrame:CGRectMake(268.0f, 2.0f, 44.0f, 44.0f)];
    [confirmBtn setBackgroundImage:[UIImage imageWithColor:kLeafHighlightColor] forState:UIControlStateHighlighted];
    [confirmBtn addTarget:self action:@selector(confirmClicked:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn addSubview:confirmIcon];
    [shareView addSubview:confirmBtn];
    _confirmBtn = confirmBtn;
    [confirmIcon release];
    
    UIImageView *shareBg = [[UIImageView alloc] initWithFrame:CGRectMake(14.0f, 48.0f, 284.0f, 81.0f)];
    [shareBg setImage:[UIImage imageNamed:@"share_content_background"]];
    [shareBg setUserInteractionEnabled:YES];
    [shareView addSubview:shareBg];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 1.0f, 210, 79.0f)];
    textView.backgroundColor = [UIColor clearColor];
    textView.delegate = (id<UITextViewDelegate>)self;
    textView.font = kLeafFont15;
    textView.keyboardAppearance = UIKeyboardAppearanceDefault;
    textView.keyboardType = UIKeyboardTypeDefault;
    textView.scrollEnabled = YES;
    textView.showsVerticalScrollIndicator = YES;
    textView.userInteractionEnabled = YES;
    _statusTextView = textView;
    [shareBg addSubview:textView];
    [textView release];
    
    CGFloat offsetX = CGRectGetMinX(shareBg.frame);
    CGFloat offsetY = CGRectGetMaxY(shareBg.frame) + 10.0f;
    UIImageView *valimg = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX, offsetY, 50, 25)];
    [[SDImageCache sharedImageCache] removeImageForKey:@"http://www.cnbeta.com/validate1.php"];
    [valimg setImageWithURL:[NSURL URLWithString:@"http://www.cnbeta.com/validate1.php"]];
    [shareView addSubview:valimg];
    offsetX = CGRectGetMaxX(valimg.frame) + 10.0f;
    UITextField *verify = [[UITextField alloc] initWithFrame:CGRectMake(offsetX, offsetY, 50, 25)];
    verify.delegate = (id<UITextFieldDelegate>)self;
    verify.font = kLeafFont15;
    verify.keyboardAppearance = UIKeyboardAppearanceDefault;
    verify.keyboardType = UIKeyboardTypeNumberPad;
    _verify = verify;
    [shareView addSubview:verify];
    [verify release];
    [valimg release];
    [shareBg release];
    [shareView release];
    
    [_statusTextView becomeFirstResponder];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
