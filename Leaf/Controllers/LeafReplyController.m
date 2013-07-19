//
//  LeafReplyController.m
//  Leaf
//
//  Created by roger on 13-5-17.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//
#import "UIColor+MLPFlatColors.h"
#import "ASIFormDataRequest.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "GCDHelper.h"
#import "LeafCookieManager.h"

#import "LeafReplyController.h"

#define kLeafVerifyURL @"http://www.cnbeta.com/captcha.htm?refresh=1&_=%@"
#define kLeafCommentURL @"http://www.cnbeta.com/comment"

@interface LeafReplyController ()
{
    UIButton *_confirmBtn;
    UITextView *_statusTextView;
    UIImageView *_valimg;
    UITextField *_verify;
    ASIFormDataRequest *_request;
    NSString *_verifyURL;
    UIImage *_verifyImage;
}

@property (nonatomic, retain) ASIFormDataRequest *request;
@property (nonatomic, retain) NSString *verifyURL;
@property (nonatomic, retain) UIImage *verifyImage;
- (void)refreshVerifyNumber;
- (BOOL)checkTextFields;

@end

@implementation LeafReplyController
@synthesize articleId = _articleId;
@synthesize request = _request;
@synthesize tid = _tid;
@synthesize verifyURL = _verifyURL;
@synthesize verifyImage = _verifyImage;

- (void)dealloc
{
    [_articleId release], _articleId = nil;
    [_request clearDelegatesAndCancel];
    [_request release], _request = nil;
    [_tid release], _tid = nil;
    [_verifyImage release], _verifyImage = nil;
    [_verifyURL release], _verifyURL = nil;
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
    NSString *content = _statusTextView.text;
    LeafCookieManager *manager = [LeafCookieManager sharedInstance];
    NSHTTPCookie *cookie = [manager cookieForToken];
    NSHTTPCookie *session = [manager cookieForSession];
    if (!cookie || !session) {
        [self postMessage:@"验证码无效!" type:LeafStatusBarOverlayTypeWarning];
        return;
    }
    NSString *token = [manager token];
    
    __block LeafReplyController *controller = self;
    [self setDismissBlockForHUD:^{
        if (controller.request) {
            [controller.request clearDelegatesAndCancel];
        }
    }];
    [self showHUD:RFHUDTypeLoading status:@"正在发送评论"];
    NSURL *url = [NSURL URLWithString:kLeafCommentURL];

    
    NSMutableArray *cookies = [NSMutableArray arrayWithObjects:cookie, session, nil];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    self.request = request;
    [request setRequestCookies:cookies];
    [request setUseCookiePersistence:NO];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Referer" value:[NSString stringWithFormat:kCBArticle, _articleId]];
    [request addRequestHeader:@"Origin" value:@"http://www.cnbeta.com"];
    [request addRequestHeader:@"Host" value:@"www.cnbeta.com"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=utf-8"];
    request.delegate = self;
    [request setDidFinishSelector:@selector(commentSuccess:)];
    [request setDidFailSelector:@selector(commentFailed:)];
    [request setPostValue:@"publish" forKey:@"op"];
    [request setPostValue:content forKey:@"content"];
    [request setPostValue:_articleId forKey:@"sid"];
    [request setPostValue:@"" forKey:@"name"];
    [request setPostValue:@"Re:" forKey:@"subject"];
    if (_tid && ![_tid isEqualToString:@""]) {
        [request setPostValue:_tid forKey:@"pid"];
    }
    [request setPostValue:_verify.text forKey:@"seccode"];
    [request setPostValue:token forKey:@"YII_CSRF_TOKEN"];
    [request startAsynchronous];
}


#pragma mark -
#pragma mark - Utils

- (void)refreshVerifyNumber
{
    [GCDHelper dispatchBlock:^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSDate *date = [NSDate date];
        NSString *timestamp = [NSString stringWithFormat:@"%lld", (long long)([date timeIntervalSince1970] * 1000)];
        
        LeafCookieManager *manager = [LeafCookieManager sharedInstance];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:kLeafVerifyURL, timestamp]]];
        [request addRequestHeader:@"Referer" value:[NSString stringWithFormat:kCBArticle, _articleId]];
        
        NSHTTPCookie *session = [manager cookieForSession];
        NSHTTPCookie *token = [manager cookieForToken];
        if (token && session) {
            NSMutableArray *cookies = [NSMutableArray arrayWithObjects:token, session, nil];
            [request setRequestCookies:cookies];
        }
        [request setUseCookiePersistence:NO];
        [request startSynchronous];
        if (request.responseCookies) {
            for (NSHTTPCookie *cookie in request.responseCookies) {
                NSLog(@"cookie: %@",[cookie description]);
                if (cookie && [cookie.name isEqualToString:@"PHPSESSID"]) {
                    [manager updateSessionId:cookie.value];
                }
            }
        }
        session = [manager cookieForSession];
        NSData *data = request.responseData;
        if (data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
            if (dict) {
                NSString *url = [dict stringForKey:@"url"];
                self.verifyURL = [NSString stringWithFormat:@"http://www.cnbeta.com%@", url];
                NSLog(@"verifyURL: %@", _verifyURL);
                
                ASIHTTPRequest *veriReq = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:_verifyURL]];
                
                if (session) {
                    NSMutableArray *cookies = [NSMutableArray arrayWithObjects:session, nil];
                    [veriReq setRequestCookies:cookies];
                    [veriReq setUseCookiePersistence:NO];
                }
                [veriReq  addRequestHeader:@"Referer" value:[NSString stringWithFormat:kCBArticle, _articleId]];
                [veriReq startSynchronous];
                
                if (veriReq.responseData) {
                   self.verifyImage = [UIImage imageWithData:veriReq.responseData];
                }
            }
        }
        
    } complete:^{

        _valimg.image = _verifyImage;
        _verify.text = @"";
    }];
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshVerifyNumber)];
    CGFloat offsetX = CGRectGetMinX(shareBg.frame);
    CGFloat offsetY = CGRectGetMaxY(shareBg.frame) + 10.0f;
    UIImageView *valimg = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX, offsetY, 55, 24)];
    valimg.userInteractionEnabled = YES;
    [valimg addGestureRecognizer:tap];
    _valimg = valimg;
    [shareView addSubview:valimg];
    offsetX = CGRectGetMaxX(valimg.frame) + 10.0f;
    [tap release];

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
    verify.keyboardType = UIKeyboardTypeDefault;
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


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
    
    if (!request.responseData) {
        NSLog(@"error: response is nil");
        return;
    }
    NSString *response = [request responseString];
    NSLog(@"response: %@", response);
    
    NSData *data = request.responseData;
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    if (dict) {
        NSString *status = [dict stringForKey:@"status"];
        
        if ([status isEqualToString:@"error"]) {
            NSDictionary *result = [dict objectForKey:@"result"];
            int error_code = [result intForKey:@"error_code"];
            if (error_code == 6) {
                [self postMessage:@"该文章禁止评论!" type:LeafStatusBarOverlayTypeError];
                [self dismissViewControllerWithOption:LeafAnimationOptionVertical completion:NULL];
            }
            else if(error_code == 8)
            {
                [self postMessage:@"验证码错误，请重试！" type:LeafStatusBarOverlayTypeError];
                [self refreshVerifyNumber];
            }
            else
            {
                [self postMessage:@"评论失败，请重试！" type:LeafStatusBarOverlayTypeError];
                [self refreshVerifyNumber];
            }
        }
        else
        {
            [self postMessage:@"评论成功, 稍后生效!" type:LeafStatusBarOverlayTypeSuccess];
            [self dismissViewControllerWithOption:LeafAnimationOptionVertical completion:NULL];
        }
    }
    
}

- (void)commentFailed:(ASIHTTPRequest *)request
{
    [self postMessage:@"评论失败" type:LeafStatusBarOverlayTypeError];
    [self clearHUDBlock];
    [self dismissHUD];
}


@end
