// Rect stuff
#define CGWidth(rect)                   rect.size.width
#define CGHeight(rect)                  rect.size.height
#define CGOriginX(rect)                 rect.origin.x
#define CGOriginY(rect)                 rect.origin.y
#define CGRectCenter(rect)              CGPointMake(NSOriginX(rect) + NSWidth(rect) / 2, NSOriginY(rect) + NSHeight(rect) / 2)
#define CGRectModify(rect,dx,dy,dw,dh)  CGRectMake(rect.origin.x + dx, rect.origin.y + dy, rect.size.width + dw, rect.size.height + dh)
#define NSLogRect(rect)                 NSLog(@"Rect: %@", NSStringFromCGRect(rect))
#define NSLogSize(size)                 NSLog(@"%@", NSStringFromCGSize(size))
#define NSLogPoint(point)               NSLog(@"%@", NSStringFromCGPoint(point))
#define kLeafWindowRect  [[UIApplication sharedApplication] keyWindow].bounds

// Color stuff
#define CGColorConvert(value)           value/255.0f
#define kLeafBackgroundColor    [UIColor colorWithRed:CGColorConvert(236.0f) green:CGColorConvert(234.0f) blue:CGColorConvert(226.0f) alpha:1.0f]
#define kLeafHighlightColor     [UIColor colorWithRed:CGColorConvert(217.0f) green:CGColorConvert(217.0f) blue:CGColorConvert(216.0f) alpha:0.8f]

// Number 
#define __INT(v) [NSNumber numberWithInt:v]
#define __BOOL(v) [NSNumber numberWithBool:v]
// Fonts
#define kLeafFont10     [UIFont fontWithName:@"FZLTHK--GBK1-0" size:10.0f]
#define kLeafFont13     [UIFont fontWithName:@"FZLTHK--GBK1-0" size:13.0f]
#define kLeafFont15     [UIFont fontWithName:@"FZLTHK--GBK1-0" size:15.0f]
#define kLeafFont19     [UIFont fontWithName:@"FZLTHK--GBK1-0" size:19.0f]

#define kLeafBoldFont18 [UIFont fontWithName:@"FZLTZHK--GBK1-0" size:18.0f]
#define kLeafBoldFont16 [UIFont fontWithName:@"FZLTZHK--GBK1-0" size:16.0f]
#define kLeafBoldFont13 [UIFont fontWithName:@"FZLTZHK--GBK1-0" size:13.0f]


// URL Stuff

#define kNewsListURL @"http://www.cnbeta.com/api/getNewsList.php?limit=20"
#define kMoreNewsURL @"http://www.cnbeta.com/api/getNewsList.php?fromArticleId=%@&limit=10"
#define kArticleUrl  @"http://www.cnbeta.com/api/getNewsContent2.php?articleId=%@"
#define kcnbetaUrl @"http://www.cnbeta.com/articles/%@.htm"