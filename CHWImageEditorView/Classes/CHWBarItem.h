//
//  CHWBarIten.h
//  画风
//
//  Created by Cherish on 2017/6/18.
//  Copyright © 2017年 Cherish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHWBarItem : UIControl
@property(nonatomic) BOOL ShowBorder;
@property(nonatomic) BOOL titleOverlay;
@property(nonatomic,strong) UIImage *unselectedBackgroundImage;
@property(nonatomic,strong) UIImage *selectedBackgroundImage;
@property(nonatomic,strong) UIImage *unselectedImage;
@property(nonatomic,strong) UIImage *selectedImage;

- (instancetype)initWithFrame:(CGRect)frame imageSize:(CGSize)size;

#pragma mark - Title configuration

/**
 * The title displayed by the tab bar item.
 */
@property (nonatomic, copy) NSString *title;

/**
 * The offset for the rectangle around the tab bar item's title.
 */
@property (nonatomic) UIOffset titlePositionAdjustment;

/**
 * The title attributes dictionary used for tab bar item's unselected state.
 */
@property (copy) NSDictionary *unselectedTitleAttributes;

/**
 * The title attributes dictionary used for tab bar item's selected state.
 */
@property (copy) NSDictionary *selectedTitleAttributes;

#pragma mark - Image configuration

/**
 * The offset for the rectangle around the tab bar item's image.
 */
@property (nonatomic) UIOffset imagePositionAdjustment;

/**
 * The image used for tab bar item's selected state.
 */
- (UIImage *)finishedSelectedImage;

/**
 * The image used for tab bar item's unselected state.
 */
- (UIImage *)finishedUnselectedImage;

-(void)setSelectedImage:(UIImage*)selectedImage withUnSelectedImage:(UIImage*)unSelectedImage;
-(void)setBackgroundSelectedImage:(UIImage*)selectedImage withUnSelectedImage:(UIImage*)unSelectedImage;
- (void)setFinishedSelectedImage:(UIImage *)selectedImage withFinishedUnselectedImage:(UIImage *)unselectedImage;
@end
