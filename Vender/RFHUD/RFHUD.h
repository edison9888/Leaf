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


typedef enum {
    RFHUDCompletionTypeNone = 0,
    RFHUDCompletionTypeCancel,
    RFHUDCompletionTypeChangeStatus
}RFHUDCompletionType;

typedef void (^RFHUDBlock) (void);

@interface RFHUD : UIView
{
    UIFont *_hudFont;
    RFHUDBlock _dismissBlock;
}

@property (nonatomic, retain) UIFont *hudFont;
@property (nonatomic, copy) RFHUDBlock dismissBlock;


- (void)setHUDType:(RFHUDType)type andStatus:(NSString *)status;

- (void)show;
- (void)dismissAfterDelay:(CGFloat)delay;

@end
