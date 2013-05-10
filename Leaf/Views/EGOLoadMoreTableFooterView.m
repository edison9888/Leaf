//
//  EGOLoadMoreTableFooterView.m
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//  Modified by Roger on 12/18/2012 
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGOLoadMoreTableFooterView.h"

#define TEXT_COLOR	 [UIColor blackColor]
#define kLabelFontSmall [UIFont fontWithName:@"FZLTHK--GBK1-0" size:12.0f]
#define kLabelFontMid   [UIFont fontWithName:@"FZLTZHK--GBK1-0" size:13.0f]
#define BACK_COLOR [UIColor colorWithRed:(217.0f/255.0f) green:(217.0f/255.0f) blue:(216.0f/255.0f) alpha:0.8f]

#define FLIP_ANIMATION_DURATION 0.18f


@interface EGOLoadMoreTableFooterView (Private)
- (void)setState:(EGOPullLoadMoreState)aState;
@end

@implementation EGOLoadMoreTableFooterView

@synthesize delegate=_delegate;

- (void)handleTap:(UIGestureRecognizer *) recognizer
{
    if ([_delegate respondsToSelector:@selector(egoLoadMoreTableFooterDidTriggerLoadMore:)]) {
        [_delegate egoLoadMoreTableFooterDidTriggerLoadMore:self];
    }
    
    [self setState:EGOOPullLoadMoreLoading];
}

- (id)initWithFrame:(CGRect)frame andScrollView:(UIScrollView *)scrollView{
    if (self = [super initWithFrame:frame]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = BACK_COLOR;

		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = kLabelFontMid;
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		
				
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(frame.size.width - 35.0f, 20.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];		
		
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
        [tap release];        
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
		[self setState:EGOOPullLoadMoreNormal];
		
    }
	
    return self;	
}


#pragma mark -
#pragma mark Setters

- (void)setState:(EGOPullLoadMoreState)aState{
	
	switch (aState) {
		case EGOOPullLoadMorePulling:			
			_statusLabel.text = @"更多...";
			break;
		case EGOOPullLoadMoreNormal:			
			_statusLabel.text = @"更多...";
			[_activityView stopAnimating];            
			
			break;
		case EGOOPullLoadMoreLoading:			
			_statusLabel.text = @"加载中...";
			[_activityView startAnimating];			
			break;
		default:
			break;
	}	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoLoadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoLoadMoreTableFooterDataSourceIsLoading:)]) {
		_loading = [_delegate egoLoadMoreTableFooterDataSourceIsLoading:self];
	}
	//NSLog(@"scrollView.contentOffset.y= %f", scrollView.contentOffset.y);
    //NSLog(@"offset: y = %f", scrollView.frame.size.height - (scrollView.contentSize.height - scrollView.contentOffset.y));
    //NSLog(@"scrollView.frame.size.height: %f", scrollView.frame.size.height);
    if (((scrollView.frame.size.height > scrollView.contentSize.height  && scrollView.contentOffset.y > 65.0f) || (scrollView.frame.size.height < scrollView.contentSize.height && scrollView.frame.size.height - (scrollView.contentSize.height - scrollView.contentOffset.y) > 65.0f)) && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(egoLoadMoreTableFooterDidTriggerLoadMore:)]) {
			[_delegate egoLoadMoreTableFooterDidTriggerLoadMore:self];
		}
		
		[self setState:EGOOPullLoadMoreLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
		[UIView commitAnimations];		
	}
}


- (void)egoLoadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:EGOOPullLoadMoreNormal];
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
    [super dealloc];
}


@end
