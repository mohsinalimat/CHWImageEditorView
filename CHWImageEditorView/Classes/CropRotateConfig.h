//
//  CropRotateConfig.h
//  CropRotateView
//
//  Created by cherish on 2019/12/4.
//  Copyright © 2019 JackyHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHWMacroDefine.h"
#import "CHWConfigModel.h"
#import "CHWMacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface CropRotateConfig : NSObject
@property(nonatomic)ShapeType shapeType;
@property(nonatomic)CGRect cropBoxOriginalFrame;
@property(nonatomic)CGRect cropBoxFrame;
@property(nonatomic)CGPoint startOriginPoint;
@property(nonatomic)CropRotateOverlayEdge touchedEdgeType;

@property(nonatomic)CGFloat aspectRatio;// default the origin image ratio

@property(nonatomic,strong)CHWAngle* angle;

@property(nonatomic)CGFloat radians;

@property(nonatomic)Rotate90Degree  rotate90Degree;

@property(nonatomic)CropRotateViewStatus viewStatus;

@property(nonatomic)CGPoint pointLocationOnLeftTop;
@property(nonatomic)CGPoint pointLocationOnRightBottom;
@property(nonatomic,strong)CHWConfigModel* wheelConfig;

@property(nonatomic,copy)void(^statusChanged)(CropRotateViewStatus viewStatus);

/*
 config for Grid Overlay
 */
@property(nonatomic,strong)UIColor* outerLineColor;// default white color
@property(nonatomic,strong)UIColor* innerLineColor;// default white color
@property(nonatomic,strong)UIColor* cornerColor;// default white color

@property(nonatomic)CGFloat outerLineBorderWidth;// default width 1.0
@property(nonatomic)CGFloat innerLineBorderWidth;// default width 1.0
@property(nonatomic)CGFloat cornerBorderLong;// default width 14.0
@property(nonatomic)CGFloat cornerBorderThickness;// default 4.0

@property(nonatomic)CGFloat cropLinesCount;// default  3 lines
@property(nonatomic)CGFloat rotateLinesCount;// default  9 lines

-(void)calulateCropBoxFrame:(CGRect)initialCropBox byImageScale:(CGFloat)scale;
-(CGFloat)getCurrentRadians;
-(void)prepareForCropByTouchPoint:(CGPoint)point;
-(CGFloat)getTotalRadiasByRadians:(CGFloat)radians;
-(void)resetCropFrame:(CGRect)frame;
-(void)reset:(BOOL)forceFixedRatio;
-(void)counterclockwiseRotate90:(BOOL)isClockwise;
-(CGRect)getNewCropBoxFrameWith:(CGPoint) point contentFrame:(CGRect)contentFrame withViewPading:(CGFloat)cropViewPadding aspectRatioLockEnabled:(BOOL)aspectRatioLockEnabled;
-(BOOL)checkNeedCropOrNot;
@end

NS_ASSUME_NONNULL_END
