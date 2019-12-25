//
//  CHWBottomBar.m
//  画风
//
//  Created by Cherish on 2017/6/18.
//  Copyright © 2017年 Cherish. All rights reserved.
//

#import "CHWBottomBar.h"
#import "CHWBarItem.h"

@implementation CHWBottomBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.keepSelected = NO;
        self.canSelectedSameBar = YES;
        [self commonInitial];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInitial];
    }
    return self;
}

-(void)commonInitial{
    self.bounces = NO;
    self.margin = 10;
    self.itemBeginX = 10;
    self.itemWidth = 50;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect frameSize = self.frame;
    for (int i = 0; i < _barItems.count; i++) {
        CHWBarItem* barItem = [_barItems objectAtIndex:i];
        barItem.frame = CGRectMake(_itemBeginX+_itemWidth*i, 0, _itemWidth, frameSize.size.height);
        [barItem setNeedsDisplay];
    }
    self.contentSize = CGSizeMake(_itemBeginX+_itemWidth*_barItems.count + _margin * (_barItems.count-1), frameSize.size.height);
}

-(void)setBarItems:(NSMutableArray*)barItems{
    for (CHWBarItem* item in _barItems) {
        [item removeFromSuperview];
    }
    _barItems = barItems;
    for (CHWBarItem* item in _barItems) {
        [item addTarget:self action:@selector(tabBarItemWasSelected:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:item];
    }
}

-(void)tabBarItemWasSelected:(id)sender{
    if (!_canSelectedSameBar) {
        NSInteger index = [[self barItems] indexOfObject:self.selectedBarItem];
        if (index != 3) {
            if (_selectedBarItem == sender) {
                return;
            }
        }
    }
    
    [self setSelectedBarItem:sender];
    
    if (_barDelegate && [_barDelegate respondsToSelector:@selector(bottomBar:barDidSelectedItemAtIndex:)]) {
        NSInteger index = [[self barItems] indexOfObject:self.selectedBarItem];
        [_barDelegate bottomBar:self barDidSelectedItemAtIndex:index];
        if (!_keepSelected) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.selectedBarItem setSelected:NO];
            });
        }
        
    }
}

-(void)setSelectedBarItem:(CHWBarItem *)selectedBarItem{
    if (_selectedBarItem == selectedBarItem) {
        return;
    }
    [_selectedBarItem setSelected:NO];
    _selectedBarItem = selectedBarItem;
    [_selectedBarItem setSelected:YES];
}
@end
