//
//  CHWBottomBar.h
//  画风
//
//  Created by Cherish on 2017/6/18.
//  Copyright © 2017年 Cherish. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHWBottomBar;
@class CHWBarItem;
@protocol CHWBarDelegate <NSObject>

@required
-(void)bottomBar:(CHWBottomBar*)bottomBar barDidSelectedItemAtIndex:(NSInteger)index;

@end

@interface CHWBottomBar : UIScrollView

@property(nonatomic,weak)id<CHWBarDelegate> barDelegate;
@property (nonatomic, copy) NSMutableArray *barItems;
@property(nonatomic,strong)CHWBarItem* selectedBarItem;

@property CGFloat margin;
@property (nonatomic) CGFloat itemWidth;
@property CGFloat itemBeginX;

@property(nonatomic)BOOL keepSelected;
@property(nonatomic)BOOL canSelectedSameBar;
@end
