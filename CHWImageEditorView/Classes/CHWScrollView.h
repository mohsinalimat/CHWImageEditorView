//
//  CHWScrollView.h
//  CropRotateView
//
//  Created by cherish on 2019/12/3.
//  Copyright © 2019 JackyHe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHWScrollView : UIScrollView
@property(nonatomic,strong)UIImageView* imageContainer;
- (instancetype)initWithFrame:(CGRect)frame;
-(void)validateContentOffset;
-(void)updateLayout:(CGSize)newSize;
-(BOOL)shouldScale;
-(void)zoomScaleToBoundByAnimated:(BOOL)animated;
-(void)resetByRect:(CGRect)rect;
@end

NS_ASSUME_NONNULL_END
