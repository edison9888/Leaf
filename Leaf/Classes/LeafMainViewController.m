//
//  LeafMainViewController.m
//  Leaf
//
//  Created by roger qian on 13-1-25.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import "LeafMainViewController.h"
#import "LeafNavigationBar.h"
#import "UIViewController+NSSidebarController.h"
#import "LeafHelper.h"
#import "LeafNewsItem.h"
#import "LeafNewsData.h"



#define kLeafNewsItemTag 1001

@implementation LeafMainViewController


- (void)dealloc
{
    _bar = nil;
    _mask = nil;
    [_leaves release], _leaves = nil;
    [_connection release], _connection = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)homeItemClicked:(id)sender
{
    NSLog(@"back home.");
    [self.sidebarController showLeftController];
    [_mask setHidden:NO];
    
}

- (void)removeMask
{
    [_mask setHidden:YES];
}

- (void)printFonts
{
    NSArray *familyNames = [UIFont familyNames];
    
    for( NSString *familyName in familyNames ){
        
        NSLog(@"font family: %@", familyName);
        
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        
        for( NSString *fontName in fontNames ){            
            NSLog(@"\tFont: %@ \n", fontName);            
        }
        
    }
}

- (void)refresh
{
    [_connection GET:@"http://www.cnbeta.com/api/getNewsList.php?limit=20"];
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    self.view = view;
    [view release];
    
    LeafNavigationBar *bar = [[LeafNavigationBar alloc] init];
    [bar setTitle:@"cnbeta.com"];
    [bar addItemWithStyle:LeafNavigationItemStyleHome target:self action:@selector(homeItemClicked:)];
    _bar = bar;
    [self.view addSubview:bar];
    [bar release];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, CGWidth(self.view.frame), CGHeight(self.view.frame) - 44.0f)];
    _table = tableView;
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_table setAllowsSelection:NO];
    [_table setBackgroundColor:[UIColor colorWithRed:CGColorConvert(236.0f) green:CGColorConvert(234.0f) blue:CGColorConvert(226.0f) alpha:1.0f]];
    [self.view addSubview:tableView];
    [tableView release];
    
    
    
    UIView *maskView = [[UIView alloc] initWithFrame:self.view.frame];
    maskView.backgroundColor = [UIColor clearColor];
    _mask = maskView;
    [self.view addSubview:maskView];
    [maskView release];
    [_mask setHidden:YES];   
    
    _leaves = [[NSMutableArray alloc] init];
    _connection = [[LeafURLConnection alloc] init];
    _connection.delegate = self;
    [self refresh];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - 
#pragma mark - UITableViewDataSource and UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _leaves.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Leaf";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        LeafNewsItem *item = [[LeafNewsItem alloc] init];
        item.tag = kLeafNewsItemTag;
        [cell.contentView addSubview:item];
        [item release];
    }
    LeafNewsData *data = [_leaves objectAtIndex:indexPath.row];
    LeafNewsItem *leafItem = (LeafNewsItem *)[cell.contentView viewWithTag:kLeafNewsItemTag];
    [leafItem loadData:data];
    
    return cell;
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}*/

#pragma mark - 
#pragma mark - LeafURLConnectionDelegate Methods

- (void)didFinishLoadingData:(NSMutableData *)data
{
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (array) {
        [_leaves removeAllObjects];
        for (int i = 0; i<array.count; i++) {
            NSDictionary *dict = [array objectAtIndex:i];
            if (dict) {
                LeafNewsData *leaf = [[LeafNewsData alloc] init];
                leaf.theme = [dict stringForKey:@"theme"];
                leaf.pubTime = [dict stringForKey:@"pubtime"];
                leaf.title = [dict stringForKey:@"title"];
                leaf.cmtNum = [dict stringForKey:@"cmtnum"];
                leaf.articleId = [dict stringForKey:@"ArticleID"];
                [_leaves addObject:leaf];
                [leaf release];
            }
        }
        [_table reloadData];
    }  
}

@end
