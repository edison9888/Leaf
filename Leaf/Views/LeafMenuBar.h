//
//  LeafMenuBar.h
//  Leaf
//
//  Created by roger on 13-5-16.
//  Copyright (c) 2013年 Mobimtech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LeafMenuBarArrowTypeNone,
    LeafMenuBarArrowTypeUp,
    LeafMenuBarArrowTypeDown
} LeafMenuBarArrowType;

typedef enum{
    LeafMenuBarItemTypeNone,
    LeafMenuBarItemTypeUp,
    LeafMenuBarItemTypeDown,
    LeafMenuBarItemTypeReply,
    LeafMenuBarItemTypeCopy
} LeafMenuBarItemType;


@protocol LeafMenuBarDelegate;

@interface LeafMenuBar : UIView
{
    LeafMenuBarArrowType _type;
    CGFloat _offsetY;
}

@property (nonatomic, assign) NSObject <LeafMenuBarDelegate> *delegate;
@property (nonatomic, assign) LeafMenuBarArrowType type;
@property (nonatomic, assign) CGFloat offsetY;

- (void)show;

@end

@protocol LeafMenuBarDelegate <NSObject>

- (void)menuBar:(LeafMenuBar *)menubar didClickedItemWithType:(LeafMenuBarItemType)type;

@end

