//
//  CHWShapeView.h
//  画风
//
//  Created by Cherish on 2019/3/16.
//  Copyright © 2019 Cherish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHWMacroDefine.h"

@interface CHWShapeView : UIView
@property(nonatomic,strong)UIColor* color;
- (instancetype)initWithShape:(ShapeType)shapeType;
@end
