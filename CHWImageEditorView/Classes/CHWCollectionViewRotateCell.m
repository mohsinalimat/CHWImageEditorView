//
//  CHWCollectionViewRotateCell.m
//  画品
//
//  Created by cherish on 2019/11/2.
//  Copyright © 2019 Cherish. All rights reserved.
//

#import "CHWCollectionViewRotateCell.h"

@interface CHWCollectionViewRotateCell()

@end

@implementation CHWCollectionViewRotateCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}


@end
