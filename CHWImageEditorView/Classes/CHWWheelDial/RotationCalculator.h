//
//  RotationCalculator.h
//  CHWImageEditorView
//
//  Created by cherish on 2019/12/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RotationCalculator : NSObject
- (instancetype)initMidPoint:(CGPoint)midPoint;
-(CGFloat)getRotationRadiansByOldPoint:(CGPoint)p1 andNewPoint:(CGPoint)p2;
@end

NS_ASSUME_NONNULL_END
