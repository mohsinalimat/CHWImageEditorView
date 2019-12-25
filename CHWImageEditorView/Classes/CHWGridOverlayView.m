//
//  CHWGridOverlayView.m
//  CropRotateView
//
//  Created by cherish on 2019/12/3.
//  Copyright © 2019 JackyHe. All rights reserved.
//

#import "CHWGridOverlayView.h"
#import "CropRotateConfig.h"

@interface CHWGridOverlayView()
@property(nonatomic,strong)CropRotateConfig* mConfig;

@property(nonatomic,strong)NSMutableArray* cornerLines;
@property(nonatomic,strong)NSMutableArray* centerHLines;
@property(nonatomic,strong)NSMutableArray* centerVLines;
@property(nonatomic,strong)UIView* outerBorderLines;
@property(nonatomic)NSInteger linesNum;
@end

@implementation CHWGridOverlayView

- (instancetype)initWithFrame:(CGRect)frame withConfig:(CropRotateConfig*)config
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        self.mConfig = config;
        self.cropRotateStatus = NONE;
        self.centerHLines = [NSMutableArray array];
        self.centerVLines = [NSMutableArray array];
        self.cornerLines = [NSMutableArray array];
        [self setUpLines];
    }
    return self;
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    [self layoutLines];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self layoutLines];
}

- (void)setCropRotateStatus:(CropRotateStatus)cropRotateStatus{
    _cropRotateStatus = cropRotateStatus;
    _linesNum = 0;
    if (_cropRotateStatus  == SQUARE_CROP) {
        _linesNum = _mConfig.cropLinesCount;
    }else if (_cropRotateStatus  == ROTATE){
        _linesNum = _mConfig.rotateLinesCount;
    }else{
        _linesNum = 0;
    }
    [self addHorizontalLines];
    [self addVerticalLines];
    [self layoutInnnerGridLines];
}

-(void)setGridLineStatus:(BOOL)isHidden animate:(BOOL)isAnimate{
    self.currentGridLineHidden = isHidden;
    void(^UpdateGridLinesStatus)(void) = ^{
        for (int i = 0; i<self.linesNum; i++) {
            UIView* lineH = [self.centerHLines objectAtIndex:i];
            UIView* lineV = [self.centerVLines objectAtIndex:i];
            lineH.alpha = isHidden?0:1;
            lineV.alpha = isHidden?0:1;
        }
    };
    if (isAnimate) {
        [UIView animateWithDuration:0.45 animations:^{
            UpdateGridLinesStatus();
        }];
    }else{
        UpdateGridLinesStatus();
    }
}

-(UIView*)addLineView{
    UIView* view = [[UIView alloc] init];
    view.frame = CGRectZero;
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    return view;
}

-(void)setUpLines
{
    // create outer line
    self.outerBorderLines = [self addLineView];
    _outerBorderLines.layer.backgroundColor = [UIColor clearColor].CGColor;
    _outerBorderLines.layer.borderColor = _mConfig.outerLineColor.CGColor;
    _outerBorderLines.layer.borderWidth = _mConfig.outerLineBorderWidth;
    // create 8 coner lines
    for (int i = 0; i<8; i++) {
        UIView* cornerLine = [self addLineView];
        cornerLine.backgroundColor = _mConfig.cornerColor;
        [self.cornerLines addObject:cornerLine];
    }
    // create inner lines
    [self addHorizontalLines];
    [self addVerticalLines];
}

-(void)addVerticalLines{
    for (UIView* line in _centerVLines) {
        [line removeFromSuperview];
    }
    [_centerVLines removeAllObjects];
    for (NSInteger i = 0; i<_linesNum; i++) {
        UIView* line = [self addLineView];
        line.backgroundColor = _mConfig.innerLineColor;
        [_centerVLines addObject:line];
    }
}

-(void) addHorizontalLines{
    for (UIView* line in _centerHLines) {
        [line removeFromSuperview];
    }
    [_centerHLines removeAllObjects];
    for (NSInteger i = 0; i<_linesNum; i++) {
        UIView* line = [self addLineView];
        line.backgroundColor = _mConfig.innerLineColor;
        [_centerHLines addObject:line];
    }
}

-(void)layoutLines{
    [self layoutOuterLine];
    [self layoutCornerLines];
    [self layoutInnnerGridLines];
    for (int i = 0; i<self.linesNum; i++) {
        UIView* lineH = [self.centerHLines objectAtIndex:i];
        UIView* lineV = [self.centerVLines objectAtIndex:i];
        lineH.alpha = _currentGridLineHidden?0:1;
        lineV.alpha = _currentGridLineHidden?0:1;
    }
}

-(void)layoutCornerLines{
    CGFloat cornerThickness = _mConfig.cornerBorderThickness;;
    CGFloat cornerLong = _mConfig.cornerBorderLong;
    CGFloat outterThickness = _mConfig.outerLineBorderWidth;
    
    CGRect leftTopCornerFrameH = CGRectMake(-cornerThickness, -cornerThickness, cornerLong, cornerThickness);
    CGRect leftTopCornerFrameV = CGRectMake(-cornerThickness, -cornerThickness, cornerThickness, cornerLong);
   
    CGFloat xdistanceH = CGRectGetWidth(_outerBorderLines.frame)+2*(cornerThickness-outterThickness)-cornerLong;
    CGFloat xdistanceV = CGRectGetWidth(_outerBorderLines.frame)+cornerThickness-outterThickness;
    
    CGFloat ydistanceH = CGRectGetHeight(_outerBorderLines.frame)+cornerThickness-outterThickness;
    CGFloat ydistanceV = CGRectGetHeight(_outerBorderLines.frame)+2*(cornerThickness-outterThickness)-cornerLong;
    
    UIView* leftTopCornerLineH = _cornerLines[0];
    leftTopCornerLineH.frame = leftTopCornerFrameH;
    
    UIView* leftTopCornerLineV = _cornerLines[1];
    leftTopCornerLineV.frame = leftTopCornerFrameV;
    
    UIView* rightTopCornerLineH = _cornerLines[2];
    rightTopCornerLineH.frame = CGRectOffset(leftTopCornerFrameH, xdistanceH, 0);
    UIView* rightTopCornerLineV = _cornerLines[3];
    rightTopCornerLineV.frame = CGRectOffset(leftTopCornerFrameV, xdistanceV, 0);
    
    UIView* rightBottomCornerLineH = _cornerLines[4];
    rightBottomCornerLineH.frame = CGRectOffset(leftTopCornerFrameH, xdistanceH, ydistanceH);
    UIView* rightBottomCornerLineV = _cornerLines[5];
    rightBottomCornerLineV.frame = CGRectOffset(rightTopCornerLineV.frame, 0, ydistanceV);
    
    UIView* leftBottomCornerLineH = _cornerLines[6];
    leftBottomCornerLineH.frame = CGRectOffset(leftTopCornerFrameH, 0, ydistanceH);
    UIView* leftBottomCornerLineV = _cornerLines[7];
    leftBottomCornerLineV.frame = CGRectOffset(leftTopCornerFrameV, 0, ydistanceV);
}

-(void)layoutOuterLine{
    CGFloat outerLineBorderWidth = _mConfig.outerLineBorderWidth;
    _outerBorderLines.frame = CGRectMake(-outerLineBorderWidth, -outerLineBorderWidth, CGRectGetWidth(self.frame)+2*outerLineBorderWidth, CGRectGetHeight(self.frame)+2*outerLineBorderWidth);
    
}

-(void)layoutInnnerGridLines{
    CGFloat y = CGRectGetHeight(self.frame)/(_linesNum+1);
    CGFloat x = CGRectGetWidth(self.frame)/(_linesNum+1);
    for (NSInteger i = 0; i<_linesNum; i++) {
        UIView* lineH = _centerHLines[i];
        UIView* lineV = _centerVLines[i];
        lineH.frame = CGRectMake(0, (i+1)*y, CGRectGetWidth(self.frame), 1);
        lineV.frame = CGRectMake((i+1)*x, 0, 1, CGRectGetHeight(self.frame));
    }
}


@end
