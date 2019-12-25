//
//  CHWWheelDial.h
//  CHWImageEditorView
//
//  Created by cherish on 2019/12/8.
//

#import <UIKit/UIKit.h>
@class CHWAngle;
@class CHWConfigModel;
NS_ASSUME_NONNULL_BEGIN

@interface CHWWheelPlate : UIView

@end

@interface CHWWheelDial : UIView
@property(nonatomic,copy)void(^didRotateBlock)(CHWAngle* angle);
@property(nonatomic,copy)void(^didFinishedRotateBlock)(void);

- (instancetype)initWithFrame:(CGRect)frame withConfigModel:(CHWConfigModel*)configModel;
-(void)setupWithConfig:(CHWConfigModel*)configModel;
-(BOOL)rotateWheelPlateByAngle:(CHWAngle*)angle;
-(void)rotateWheelPlateToAngle:(CHWAngle*)angle animated:(BOOL)animated;
-(CHWAngle*)getRotationAngle;
-(void)resetAngle:(BOOL)animated;
-(void)setRotationCenterByPoint:(CGPoint)point ofView:(UIView*)view;
-(void)resetWheelDial;
@end

NS_ASSUME_NONNULL_END
