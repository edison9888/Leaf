//
//  LeafReplyController.m
//  Leaf
//
//  Created by roger on 13-5-17.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//
#import "UIColor+MLPFlatColors.h"
#import "ASIHTTPRequest.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

#import "LeafReplyController.h"


#define kLeafReplyHTTPBody @"tid=%@&sid=%@&valimg_main=%@&comment=%@&nowsubject=&nowpage=1&nowemail=cryrivers@cnbeta.com"

@interface LeafReplyController ()
{
    UIButton *_confirmBtn;
    UITextView *_statusTextView;
    UIImageView *_valimg;
    UITextField *_verify;
    ASIHTTPRequest *_request;
}

@property (nonatomic, retain) ASIHTTPRequest *request;

- (void)refreshVerifyNumber;
- (BOOL)checkTextFields;

@end

@implementation LeafReplyController
@synthesize articleId = _articleId;
@synthesize request = _request;
@synthesize tid = _tid;

- (void)dealloc
{
    [_articleId release], _articleId = nil;
    [_request clearDelegatesAndCancel];
    [_request release], _request = nil;
    [_tid release], _tid = nil;
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
    if (![self checkTextFields]) {
        NSLog(@"invalid text input.");
        return;
    }
    
    __block LeafReplyController *controller = self;
    [self setDismissBlockForHUD:^{
        if (controller.request) {
            [controller.request clearDelegatesAndCancel];
        }
    }];
    [self showHUD:RFHUDTypeLoading status:@"正在发送评论"];
    
    NSURL *url = [NSURL URLWithString:@"http://www.cnbeta.com/Ajax.comment.php?ver=new"];
    NSLog(@"url: %@", url.absoluteString);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    self.request = request;
    NSString *body = [NSString stringWithFormat:kLeafReplyHTTPBody, _tid, _articleId, _verify.text, [[_statusTextView.text stringByAppendingString:kLeafAds] stringByEncodeCharacterEntities]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=utf-8"];
    NSString *referer = [NSString stringWithFormat:kCBArticle, _articleId];
    [request addRequestHeader:@"Referer" value:referer];
    request.delegate = self;
    [request setDidFinishSelector:@selector(commentSuccess:)];
    [request setDidFailSelector:@selector(commentFailed:)];
    [request appendPostData:[body  dataUsingEncoding:NSUTF8StringEncoding]];
    [request startAsynchronous];
    
    NSLog(@"body: %@", body);
}


#pragma mark -
#pragma mark - Utils

- (void)refreshVerifyNumber
{
    NSString *verifyURL = @"http://www.cnbeta.com/validate1.php";
    [[SDImageCache sharedImageCache] removeImageForKey:verifyURL];
    [_valimg setImageWithURL:[NSURL URLWithString:verifyURL]];
    _verify.text = @"";
}


- (BOOL)checkTextFields
{
    if (_verify.text && _verify.text.length != 4) {
        [self postMessage:@"请输入验证码!" type:LeafStatusBarOverlayTypeWarning];
        return NO;
    }
    
    if (_statusTextView.text && _statusTextView.text.length == 0) {
        [self postMessage:@"评论不能为空!" type:LeafStatusBarOverlayTypeWarning];
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark - Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor clearColor];
    _container.hidden = YES;
    _mask.hidden = YES;
    
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 20.0f, 320.0f, CGRectGetHeight(self.view.bounds) - 70.0f)];
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
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 1.0f, 278.0f, 79.0f)];
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
    UIImageView *valimg = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX, offsetY, 50, 22)];
    _valimg = valimg;
    [shareView addSubview:valimg];
    offsetX = CGRectGetMaxX(valimg.frame) + 10.0f;
    

    UITextField *verify = [[UITextField alloc] initWithFrame:CGRectMake(offsetX, offsetY, 55, 24)];
    verify.textAlignment = NSTextAlignmentLeft;
    verify.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    verify.placeholder = @"验证码";
    verify.borderStyle = UITextBorderStyleNone;
    verify.layer.borderWidth = 1.0f;
    verify.layer.borderColor = [UIColor flatDarkGrayColor].CGColor;
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
    self.tid = @"0";
    [self refreshVerifyNumber];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_statusTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - ASIHTTPReqeust Delegate

- (void)commentSuccess:(ASIHTTPRequest *)request
{
    [self clearHUDBlock];
    [self dismissHUD];
    NSString *response = [request responseString];
   // NSLog(@"response: %@", response);
    if (response && response.length>0) {
        unichar ch = [response characterAtIndex:0];
        NSLog(@"response: %d", ch);
        if (ch == 49) { // wrong verify num
            [self postMessage:@"验证码错误，请重试！" type:LeafStatusBarOverlayTypeError];
            [self refreshVerifyNumber];
        }
        else if(ch == 53){ // success
            [self postMessage:@"评论成功, 稍后生效!" type:LeafStatusBarOverlayTypeSuccess];
            [self clearHUDBlock];
            [self dismissViewControllerWithOption:LeafAnimationOptionVertical completion:NULL];
        }
        else
        {
            [self postMessage:@"评论失败，请重试！" type:LeafStatusBarOverlayTypeError];
            [self refreshVerifyNumber];

        }
    }
    else
    {
        [self postMessage:@"评论失败，请重试！" type:LeafStatusBarOverlayTypeError];
        [self refreshVerifyNumber];
        
    }
}

- (void)commentFailed:(ASIHTTPRequest *)request
{
    [self postMessage:@"评论失败" type:LeafStatusBarOverlayTypeError];
    [self clearHUDBlock];
    [self dismissHUD];
}


@end
