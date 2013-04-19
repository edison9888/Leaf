//
//  RFHUD.h
//  
//
//  Created by roger on 13-4-16.
//  Copyright (c) 2013年 Mobim. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    RFHUDTypeNone = 0,
    RFHUDTypeSuccess,
    RFHUDTypeError,
    RFHUDTypeLoading,
    RFHUDTypeWaiting
}RFHUDType;

typedef void (^RFHUDBlock) (void);

@interface RFHUD : UIView
{
    UIFont *_hudFont;
    RFHUDBlock _cancelBlock;
}

@property (nonatomic, retain) UIFont *hudFont;
@property (nonatomic, copy) RFHUDBlock cancelBlock;


- (void)setHUDType:(RFHUDType)type andStatus:(NSString *)status;

- (void)show;
- (void)dismissAfterDelay:(CGFloat)delay;

@end
