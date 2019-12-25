//
//  CHWCropInfoModel.h
//  画品
//
//  Created by cherish on 2019/12/21.
//  Copyright © 2019 Cherish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHWMacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface CHWCropInfoModel : NSObject
@property(nonatomic)CGPoint translation;
@property(nonatomic)CGFloat rotation;
@property(nonatomic)CGFloat scale;
@property(nonatomic)CGSize cropSize;
@property(nonatomic)CGSize imageViewSize;
@property(nonatomic)ShapeType shapeType;
- (instancetype)initWithTranslation:(CGPoint)translation rotation:(CGFloat)rotation scale:(CGFloat)scale cropSize:(CGSize)cropSize imageViewSize:(CGSize)imageViewSize shapeType:(ShapeType)shapeType;
@end

NS_ASSUME_NONNULL_END
