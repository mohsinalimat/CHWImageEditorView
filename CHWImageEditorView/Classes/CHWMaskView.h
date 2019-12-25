//
//  CHWMaskView.h
//  CropRotateView
//
//  Created by cherish on 2019/12/4.
//  Copyright © 2019 JackyHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHWMacroDefine.h"
#import "CHWMacroDefine.h"

@interface CHWMaskView : UIView
@property(nonatomic)CGRect cropBoxFrame;
@property(nonatomic)ShapeType shapeType;
@property(nonatomic,strong)UIView* maskViewD;
@property(nonatomic,strong)UIView* maskViewS;
- (instancetype)initWithFrame:(CGRect)frame withShape:(ShapeType)shapeType;
-(void)changeMaskShowStatus:(MaskShowStatus)showStatus;
-(void)resetMaskFrameByCropBox:(CGRect)cropBoxFrame withShape:(ShapeType)shapeType;
-(void)removeMaskViews;
-(void)setUpViews;
@end
