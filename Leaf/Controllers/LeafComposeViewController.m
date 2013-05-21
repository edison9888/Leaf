//
//  LeafComposeViewController.m
//  Leaf
//
//  Created by roger on 13-5-3.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "UIColor+MLPFlatColors.h"
#import "LeafComposeViewController.h"
#import "UIImageView+WebCache.h"

#define kLeafMaxWeiboLen 140

@interface LeafComposeViewController ()
{
    UIButton *_confirmBtn;
    UIImageView *_shareImageView;
    UITextView *_statusTextView;
    UILabel *_remainLabel;
    
    SinaWeiboRequest *_request;
    UIImage *_shareImage;
}

@property (nonatomic, retain) SinaWeiboRequest *request;
@property (nonatomic, retain) UIImage *shareImage;

- (void)share;
- (void)cancel;

@end

@implementation LeafComposeViewController
@synthesize request = _request;
@synthesize shareImage = _shareImage;
@synthesize url = _url;
@synthesize articleURL = _articleURL;

- (void)dealloc
{
    _confirmBtn = nil;
    _shareImageView = nil;
    _statusTextView = nil;
    _remainLabel = nil;
    _request.delegate = nil;
    [_request release], _request = nil;
    [_shareImage release], _shareImage = nil;
    [_url release], _url = nil;
    [_articleURL release], _articleURL = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark - Button Events

- (void)cancelClicked:(id)sender
{
    [_statusTextView resignFirstResponder];
    [self dismissViewControllerWithOption:LeafAnimationOptionVertical
                               completion:NULL];
}

- (void)confirmClicked:(id)sender
{
    
    SinaWeibo *sinaweibo = [self sinaweibo];
    if ([sinaweibo isAuthValid]) {
        __block LeafComposeViewController *controller = self;
        [self setDismissBlockForHUD:^(void){
            [controller cancel];
        }];
        [self showHUD:RFHUDTypeLoading status:@"正在发送"];
        [self share];
    }
    else {
        [sinaweibo logIn];
    }
    
}

#pragma mark - 

- (void)scaleImage:(UIImage *)image
{
    CGFloat originX = 0.0f;
    CGFloat originY = 0.0f;
    CGFloat width = 0.0f;
    CGFloat height = 0.0f;
    CGFloat scaleFactor = 1.0f;
    if (CGWidth(image) > CGWidth(_shareImageView.frame) && CGHeight(image) > CGHeight(_shareImageView.frame)) {
        if (CGWidth(image) > CGHeight(image)) {
            scaleFactor = CGHeight(image)/CGHeight(_shareImageView.frame);
            width = scaleFactor * CGWidth(_shareImageView.frame);
            height = CGHeight(image);
            originX = (CGWidth(image) - width)/2.0f;
        }
        else
        {
            scaleFactor = CGWidth(image)/CGWidth(_shareImageView.frame);
            width = CGWidth(image);
            height = scaleFactor * CGHeight(_shareImageView.frame);
            originY = (CGHeight(image) - height)/2.0f;
        }
        CGRect cropRect = CGRectMake(originX, originY , width, height);
        
        CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, cropRect);
        [_shareImageView setImage:[UIImage imageWithCGImage:imageRef scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp]];
        CGImageRelease(imageRef);
    }
    else{
        [_shareImageView setImage:image];
    }
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

- (void)setUrl:(NSString *)url
{
    if (!url) {
        return;
    }
    [_url release];
    _url = [url retain];
    __block UIImageView *shareImageView = _shareImageView;
    [shareImageView setImageWithURL:[NSURL URLWithString:url]
           placeholderImage:[UIImage imageNamed:@"placeholder"]
                    success:^(UIImage *image) {
                        [self scaleImage:image];
                    }
                    failure:^(NSError *error){
                        [shareImageView setImage:[UIImage imageNamed:@"placeholder"]];
                    }];
}

- (void)share
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    
    NSString *status = [_statusTextView.text stringByAppendingString:kLeafAds];
    status = [status stringByAppendingString:_articleURL];
    
    /*self.request = [sinaweibo requestWithURL:@"statuses/upload.json"
                           params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   status, @"status",
                                   _shareImage, @"pic", nil]
                       httpMethod:@"POST"
                         delegate:self];
     */
    
    self.request = [sinaweibo requestWithURL:@"statuses/upload_url_text.json"
                                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                               status, @"status",
                                               _url, @"url", nil]
                                  httpMethod:@"POST"
                                    delegate:self];
}


- (void)cancel
{
    if (_request) {
        [_request disconnect];
    }
}

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
    _remainLabel.textAlignment = NSTextAlignmentCenter;
    _remainLabel.backgroundColor = [UIColor clearColor];
    _remainLabel.font = kLeafFont15;
    _remainLabel.textColor = [UIColor blackColor];
    [shareBg addSubview:remainLabel];
    [remainLabel release];

    
    [shareBg release];
    [shareView release];
    
    _url = nil;
    [_statusTextView becomeFirstResponder];
}


- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"LeafComposeViewController viewDidDisappear");
    [super viewDidDisappear:animated];
    
    [self cancel];
}


#pragma mark -
#pragma mark - UITextViewDelegate Methods

- (void)textViewDidChange:(UITextView *)textView
{
    
    int value = kLeafMaxWeiboLen - textView.text.length - kLeafAds.length - _articleURL.length;
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
}


#pragma mark -
#pragma mark - SinaWeiboRequestDelegate Methods

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    __block LeafComposeViewController *controller = self;
    [self setDismissBlockForHUD: ^(void){
        [controller postMessage:@"分享失败!" type:LeafStatusBarOverlayTypeError];
    }];
    [self dismissHUD];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSString *response = [(NSDictionary *)result description];
    NSLog(@"response: %@", response);
    __block LeafComposeViewController *controller = self;
 
    [self setDismissBlockForHUD:^(void){
        [controller postMessage:@"分享成功!" type:LeafStatusBarOverlayTypeSuccess];
        [controller dismissViewControllerWithOption:LeafAnimationOptionVertical completion:NULL];
    }];
    [self dismissHUD];
}




@end
