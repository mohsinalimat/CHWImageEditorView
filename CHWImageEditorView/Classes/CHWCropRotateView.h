//
//  CHWCropRotateView.h
//  CropRotateView
//
//  Created by cherish on 2019/12/3.
//  Copyright © 2019 JackyHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CropRotateConfig.h"
#import "CHWMacroDefine.h"

@class CHWCropRotateView;
@protocol CHWCropRotateDelegate <NSObject>

@optional

-(void)cropViewDidBecomeResettable:(CHWCropRotateView*)cropRotateView canResettable:(BOOL)canResettable;

-(void)cropViewDidBecomeCropable:(CHWCropRotateView*)cropRotateView canCropable:(BOOL)canCropable;
@end

@interface CHWCropRotateView : UIView
@property(nonatomic,strong)UIImage* image;
@property(nonatomic)BOOL forceFixedRatio;
@property(nonatomic)CroppingStyle croppingStyle;
@property(nonatomic,weak)id<CHWCropRotateDelegate> delegate;
- (instancetype)initWithImage:(UIImage*)image withConfig:(CropRotateConfig*)config;
- (instancetype)initWithConfig:(CropRotateConfig*)config;
-(void)squareCropImageByRatio:(SquareCropRatio)cropRatio;
-(void)reset;
-(void)resetUIFrame;
-(UIImage*)crop;
-(void)counterclockwiseRotate90:(BOOL)isClock;
- (void)setCroppingShapeStyle:(ShapeType)shapeType;
@end
