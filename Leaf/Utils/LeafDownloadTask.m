//
//  LeafDownloadTask.m
//  Leaf
//
//  Created by roger qian on 13-3-27.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafDownloadTask.h"
#import "LeafHelper.h"
#import "TFHpple.h"


#define kNewsListURL @"http://www.cnbeta.com/api/getNewsList.php?limit=50"
#define kArticleUrl  @"http://www.cnbeta.com/api/getNewsContent2.php?articleId=%@"

@implementation LeafDownloadTask
@synthesize url = _url;

- (void)dealloc
{
    [_url release], _url = nil;

    [super dealloc];
}

- (id)initWithURL:(NSURL *)url
{
    if (self = [super init]) {
        self.url = url;
        _executing = NO;
        _finished = NO;
    }
    
    return self;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return _executing;
}

- (BOOL)isFinished
{
    return _finished;
}

- (void)start
{
    if ([self isCancelled]) {
    // Must move the operation to the finished state if it is canceled. 
        [self willChangeValueForKey:@"isFinished"]; 
        _finished = YES; 
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    // If the operation is not canceled, begin executing the task.
    [self willChangeValueForKey:@"isExecuting"]; 
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    _executing = YES; 
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)main
{    
    [self willChangeValueForKey:@"isFinished"];
    _finished = NO;
    [self didChangeValueForKey:@"isFinished"];
    
    if (_url) {
        NSData *htmlData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:_url] returningResponse:nil error:nil];
        
        if (htmlData) {
            TFHpple *doc = [[TFHpple alloc] initWithHTMLData:htmlData];
            NSArray *elements = [doc searchWithXPathQuery:@"//img"];
            [doc release];
            for (TFHppleElement *element in elements) {                
                NSString *imageUrl = [element objectForKey:@"src"];
                [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]] returningResponse:nil error:nil];
                //NSLog(@"downloaded image: %@", imageUrl);
            }            
        }        
    } 
    
    [self willChangeValueForKey:@"isFinished"];
    _finished = YES;
    [self didChangeValueForKey:@"isFinished"];
     
}

@end
