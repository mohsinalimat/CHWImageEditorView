//
//  CHWAngel.h
//  CHWImageEditorView
//
//  Created by cherish on 2019/12/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHWAngle : NSObject
@property(nonatomic)CGFloat radians;
@property(nonatomic)CGFloat degress;

- (instancetype)initWithRadians:(CGFloat)radians;
- (instancetype)initWithDegrees:(CGFloat)degrees;
+(BOOL)isLessBetweenAngle:(CHWAngle*)lessAngle secondAngel:(CHWAngle*)secondAngle;
+(CHWAngle*)addingTwoAngel:(CHWAngle*)firstAngle withSecondAngel:(CHWAngle*)secondAngle;
+(CHWAngle*)multiplyTwoAngel:(CHWAngle*)firstAngle withSecondAngel:(CHWAngle*)secondAngle;
+(CHWAngle*)subtractTwoAngel:(CHWAngle*)firstAngle withSecondAngel:(CHWAngle*)secondAngle;
+(CHWAngle*)negativeAngel:(CHWAngle*)angle;
@end

NS_ASSUME_NONNULL_END
