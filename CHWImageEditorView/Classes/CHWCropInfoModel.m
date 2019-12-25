//
//  CHWCropInfoModel.m
//  画品
//
//  Created by cherish on 2019/12/21.
//  Copyright © 2019 Cherish. All rights reserved.
//

#import "CHWCropInfoModel.h"

@implementation CHWCropInfoModel

- (instancetype)initWithTranslation:(CGPoint)translation rotation:(CGFloat)rotation scale:(CGFloat)scale cropSize:(CGSize)cropSize imageViewSize:(CGSize)imageViewSize shapeType:(ShapeType)shapeType
{
    self = [super init];
    if (self) {
        self.translation = translation;
        self.rotation = rotation;
        self.scale = scale;
        self.cropSize = cropSize;
        self.imageViewSize = imageViewSize;
        self.shapeType = shapeType;
    }
    return self;
}
@end
