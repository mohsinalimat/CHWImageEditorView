//
//  CHWGridOverlayView.h
//  CropRotateView
//
//  Created by cherish on 2019/12/3.
//  Copyright © 2019 JackyHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHWMacroDefine.h"

@class CropRotateConfig;

NS_ASSUME_NONNULL_BEGIN

@interface CHWGridOverlayView : UIView
@property(nonatomic)CropRotateStatus cropRotateStatus;
@property(nonatomic)BOOL currentGridLineHidden;
- (instancetype)initWithFrame:(CGRect)frame withConfig:(CropRotateConfig*)config;
-(void)setGridLineStatus:(BOOL)isHidden animate:(BOOL)isAnimate;
@end

NS_ASSUME_NONNULL_END
