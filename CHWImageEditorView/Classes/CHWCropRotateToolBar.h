//
//  CHWCropRotateToolBar.h
//  画品
//
//  Created by cherish on 2019/12/16.
//  Copyright © 2019 Cherish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHWMacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface CHWCropRotateToolBar : UIView
@property(nonatomic,copy)void(^DidCropRatioHandle)(SquareCropRatio cropRatio);
@property(nonatomic,copy)void(^DidCropShapeHandle)(ShapeType shapeType);
@property(nonatomic,copy)void(^DidRotate90Handle)(BOOL clockWise);
@property(nonatomic,copy)void(^DidFlipHandle)(BOOL horizontal);
@property(nonatomic,copy)void(^ResetCropRotateViewHandle)(void);
@property(nonatomic,copy)void(^ChangeCropStyleHandle)(CroppingStyle cropStyle);
@property(nonatomic,copy)void(^CropImageHandle)(void);
-(void)updateButtonsStatus:(BOOL)isEnable;
-(void)updateCropButtonsStatus:(BOOL)isEnable;
@end

NS_ASSUME_NONNULL_END
