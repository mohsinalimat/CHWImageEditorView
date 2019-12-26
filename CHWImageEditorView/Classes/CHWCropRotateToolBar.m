//
//  CHWCropRotateToolBar.m
//  画品
//
//  Created by cherish on 2019/12/16.
//  Copyright © 2019 Cherish. All rights reserved.
//

#import "CHWCropRotateToolBar.h"
#import "UIImage+EditImageWithColor.h"
#import "CHWShapeView.h"
#import "CHWCollectionViewRotateCell.h"
#import "CHWBottomBar.h"
#import "CHWBarItem.h"

#define CollectionViewCellIDId  @"CollectionViewCellIDId"
#define CollectionViewHeadViewId  @"CollectionViewHeadViewId"
#define CollectionViewFootViewId  @"CollectionViewFootViewId"

#define CROP_RATIO_COLLECTIONVIEW_TAG  2882
#define CROP_SHAPE_COLLECTIONVIEW_TAG  2883
#define ROTATE_PROPERTY_COLLECTIONVIEW_TAG  2884

@interface CHWCropRotateToolBar()<UICollectionViewDataSource,UICollectionViewDelegate,CHWBarDelegate>
@property(nonatomic,strong)UICollectionView* mCropRatiosCollection;
@property(nonatomic,strong)UICollectionView* mCropShapeCollection;
@property(nonatomic,strong)UICollectionView* mRotateComponeCollectionView;
@property(nonatomic,strong)NSArray* mCropRatios;
@property(nonatomic,strong)NSMutableArray* mRotateIcons;
@property(nonatomic,strong)NSMutableArray* mRotateHiglightIcons;
@property(nonatomic,strong)UIColor* highLightColor;
@property(nonatomic,strong)CHWBottomBar* cropTypeBar;
@property(nonatomic,strong)UIButton* resetBtn;
@property(nonatomic,strong)UIButton* cropImageBtn;
@property(nonatomic,strong)UIView* bottomBar;
@property(nonatomic,strong)UIView* topContentBar;
@property(nonatomic)CGFloat margin;
@property(nonatomic)CGFloat currentSelectedIndex;
@property(nonatomic,strong)NSBundle* currentBundle;
@end

@implementation CHWCropRotateToolBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentBundle = [NSBundle bundleForClass:[self class]];
        self.margin = 10.0;
        self.currentSelectedIndex= -1;
        [self setUpViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentBundle = [NSBundle bundleForClass:[self class]];
        self.margin = 10.0;
        self.currentSelectedIndex= -1;
        [self setUpViews];
    }
    return self;
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    [self layoutFrame];
}

-(void)layoutFrame{
    _topContentBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 60);
    _bottomBar.frame = CGRectMake(0, CGRectGetMaxY(_topContentBar.frame), CGRectGetWidth(self.bounds), TABBARHEIGHT);
    
    if (_currentSelectedIndex == -1) {
        _topContentBar.frame = CGRectZero;
        _bottomBar.frame = CGRectMake(0, CGRectGetMaxY(_topContentBar.frame), CGRectGetWidth(self.bounds), TABBARHEIGHT);
        self.frame = CGRectMake(0, CGRectGetHeight(self.superview.frame)-TABBARHEIGHT, CGRectGetWidth(self.superview.frame), TABBARHEIGHT);
    }else{
        _topContentBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 60);
        _bottomBar.frame = CGRectMake(0, CGRectGetMaxY(_topContentBar.frame), CGRectGetWidth(self.bounds), TABBARHEIGHT);
        self.frame = CGRectMake(0, CGRectGetHeight(self.superview.frame)-TABBARHEIGHT-60, CGRectGetWidth(self.superview.frame), TABBARHEIGHT+60);
    }
    
    _resetBtn.frame = CGRectMake(_margin, (CGRectGetHeight(_bottomBar.bounds)-AdaptTabHeight-30)/2.0, 60, 30);
    _cropImageBtn.frame = CGRectMake(CGRectGetWidth(_bottomBar.bounds)-_margin-60, (CGRectGetHeight(_bottomBar.bounds)-AdaptTabHeight-30)/2.0, 60, 30);
    _cropTypeBar.frame = CGRectMake(CGRectGetMaxX(_resetBtn.frame)+_margin, 0, CGRectGetMinX(_cropImageBtn.frame)-_margin-(CGRectGetMaxX(_resetBtn.frame)+_margin), CGRectGetHeight(_bottomBar.frame)-AdaptTabHeight);
    _cropTypeBar.itemWidth = round(CGRectGetWidth(_cropTypeBar.frame)/3);
    _mCropRatiosCollection.frame = CGRectMake(0, (CGRectGetHeight(_topContentBar.frame)-60)/2.0, CGRectGetWidth(self.topContentBar.frame), 60);
    _mCropShapeCollection.frame = CGRectMake(0, (CGRectGetHeight(_topContentBar.frame)-60)/2.0, CGRectGetWidth(self.topContentBar.frame), 60);
    _mRotateComponeCollectionView.frame = CGRectMake((CGRectGetWidth(self.topContentBar.frame)-80*2)/2.0, (CGRectGetHeight(_topContentBar.frame)-30)/2.0, 80*2, 30);
}

-(void)setUpViews{
    self.topContentBar = [[UIView alloc] initWithFrame:CGRectZero];
    _topContentBar.backgroundColor = [UIColor blackColor];
    [self addSubview:_topContentBar];
    
    self.bottomBar = [[UIView alloc] initWithFrame:CGRectZero];
    _bottomBar.backgroundColor = [UIColor blackColor];
    [self addSubview:_bottomBar];
    
    self.resetBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    _resetBtn.titleLabel.font = Bottom_Bar_Text_Font;
    [_resetBtn setTitle:@"Reset" forState:UIControlStateNormal];
    [_resetBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    [_resetBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _resetBtn.enabled = NO;
    [_resetBtn addTarget:self action:@selector(resetCropRotateView:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBar addSubview:_resetBtn];
    
    self.cropImageBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_cropImageBtn setTitle:@"Crop" forState:UIControlStateNormal];
    _cropImageBtn.titleLabel.font = Bottom_Bar_Text_Font;
    _cropImageBtn.enabled = NO;
    [_cropImageBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    [_cropImageBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_cropImageBtn addTarget:self action:@selector(cropImage:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBar addSubview:_cropImageBtn];
    
    self.cropTypeBar = [[CHWBottomBar alloc] initWithFrame:CGRectZero];
    NSArray* titles = @[@"Ratio",
                        @"Shape",
                        @"Rotate"
                        ];
    NSMutableArray* barItems = [NSMutableArray arrayWithCapacity:titles.count];
    for (int i = 0;i<titles.count;i++) {
        CHWBarItem* barItem = [[CHWBarItem alloc] initWithFrame:CGRectZero imageSize:CGSizeMake(49,49)];
        barItem.title = titles[i];
        barItem.titlePositionAdjustment = UIOffsetMake(0, -12);
        barItem.unselectedTitleAttributes = @{NSFontAttributeName:Bottom_Bar_Text_Font,
                                              NSForegroundColorAttributeName:Default_White_Color};
        barItem.selectedTitleAttributes = @{NSFontAttributeName:Bottom_Bar_Text_Font,
                                            NSForegroundColorAttributeName:Highlighted_Color};
        [barItems addObject:barItem];
    }
    _cropTypeBar.itemBeginX = 0;
    _cropTypeBar.itemWidth = round(CGRectGetWidth(_cropTypeBar.frame)/(titles.count));
    _cropTypeBar.barItems = barItems;
    _cropTypeBar.keepSelected = YES;
    _cropTypeBar.canSelectedSameBar = YES;
    _cropTypeBar.barDelegate = self;
    [_bottomBar addSubview:_cropTypeBar];
    
    self.mCropRatios = [NSMutableArray arrayWithObjects:
                        @"Origin",
                        @"FREE",
                        @"1:1",
                        @"3:4",
                        @"4:3",
                        @"5:7",
                        @"7:5",
                        @"9:16",
                        @"16:9",nil];
    
    self.mRotateIcons = [NSMutableArray array];
    
    NSDictionary* inforDoc = _currentBundle.infoDictionary;
    NSString* bundleName = inforDoc[@"CFBundleExecutable"];
    NSString* directoryName = [NSString stringWithFormat:@"%@.bundle",bundleName];
    int scale = 3;
    NSString* rotateLeftOff = [_currentBundle pathForResource:[NSString stringWithFormat:@"rotate_left_off@%dx.png",scale] ofType:nil inDirectory:directoryName];
    NSString* rotate_right_off = [_currentBundle pathForResource:[NSString stringWithFormat:@"rotate_right_off@%dx.png",scale] ofType:nil inDirectory:directoryName];
    NSString* rotate_left_on = [_currentBundle pathForResource:[NSString stringWithFormat:@"rotate_left_on@%dx.png",scale] ofType:nil inDirectory:directoryName];
    NSString* rotate_right_on = [_currentBundle pathForResource:[NSString stringWithFormat:@"rotate_right_on@%dx.png",scale] ofType:nil inDirectory:directoryName];
    [_mRotateIcons addObject:[[UIImage imageWithContentsOfFile:rotateLeftOff] tintImageWithColor:[UIColor whiteColor]]];
    [_mRotateIcons addObject:[[UIImage imageWithContentsOfFile:rotate_right_off] tintImageWithColor:[UIColor whiteColor]]];
//    [_mRotateIcons addObject:[[UIImage imageNamed:@"rotate_horizon_off"] tintImageWithColor:[UIColor whiteColor]]];
//    [_mRotateIcons addObject:[[UIImage imageNamed:@"rotate_vertical_off"] tintImageWithColor:[UIColor whiteColor]]];
    
    self.highLightColor = [UIColor colorWithRed:254/255.0 green:88/255.0 blue:77/255.0 alpha:1.0];
    
    self.mRotateHiglightIcons = [NSMutableArray array];
    [_mRotateHiglightIcons addObject:[[UIImage imageWithContentsOfFile:rotate_left_on] tintImageWithColor:_highLightColor]];
    [_mRotateHiglightIcons addObject:[[UIImage imageWithContentsOfFile:rotate_right_on] tintImageWithColor:_highLightColor]];
//    [_mRotateHiglightIcons addObject:[[UIImage imageNamed:@"rotate_horizon_on"] tintImageWithColor:_highLightColor]];
//    [_mRotateHiglightIcons addObject:[[UIImage imageNamed:@"rotate_vertical_on"] tintImageWithColor:_highLightColor]];
    
    if (_currentSelectedIndex == -1) {
        self.mCropRatiosCollection.hidden = YES;
        self.mCropShapeCollection.hidden = YES;
        self.mRotateComponeCollectionView.hidden = YES;
    }else{
        self.mCropRatiosCollection.hidden = _currentSelectedIndex == 0?NO:YES;
        self.mCropShapeCollection.hidden = _currentSelectedIndex == 1?NO:YES;;
        self.mRotateComponeCollectionView.hidden = _currentSelectedIndex == 2?NO:YES;;
    }
    
    [_topContentBar addSubview:self.mCropRatiosCollection];
    [_topContentBar addSubview:self.mCropShapeCollection];
    [_topContentBar addSubview:self.mRotateComponeCollectionView];
}

-(void)updateButtonsStatus:(BOOL)isEnable{
    self.resetBtn.enabled = isEnable;
    self.cropImageBtn.enabled = isEnable;
}

-(void)updateCropButtonsStatus:(BOOL)isEnable{
    self.cropImageBtn.enabled = isEnable;
}

-(void)resetCropRotateView:(id)sender{
    if (self.ResetCropRotateViewHandle) {
        self.ResetCropRotateViewHandle();
    }
}

-(void)cropImage:(id)sender{
    if (self.CropImageHandle) {
        self.CropImageHandle();
    }
    if (self.ChangeCropStyleHandle) {
        self.ChangeCropStyleHandle(RATIO_STYLE);
    }
}

#pragma mark  UICollectionView
-(UICollectionView*)mCropRatiosCollection{
    if (!_mCropRatiosCollection) {
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(80, 60);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing      = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.headerReferenceSize = CGSizeMake(22, 22);
        flowLayout.footerReferenceSize = CGSizeMake(22, 22);
        self.mCropRatiosCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _mCropRatiosCollection.backgroundColor = [UIColor blackColor];
        _mCropRatiosCollection.tag = CROP_RATIO_COLLECTIONVIEW_TAG;
        _mCropRatiosCollection.delegate = self;
        _mCropRatiosCollection.dataSource = self;
        _mCropRatiosCollection.showsVerticalScrollIndicator = NO;
        _mCropRatiosCollection.showsHorizontalScrollIndicator = NO;
        _mCropRatiosCollection.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_mCropRatiosCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIDId];
        [_mCropRatiosCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CollectionViewHeadViewId];
        [_mCropRatiosCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CollectionViewFootViewId];
    }
    return _mCropRatiosCollection;
}

#pragma mark  Shape collection
-(UICollectionView*)mCropShapeCollection{
    if (!_mCropShapeCollection) {
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(60, 60);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumInteritemSpacing = 14;
        flowLayout.minimumLineSpacing      = 14;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.headerReferenceSize = CGSizeMake(22, 22);
        flowLayout.footerReferenceSize = CGSizeMake(22, 22);
        self.mCropShapeCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _mCropShapeCollection.tag = CROP_SHAPE_COLLECTIONVIEW_TAG;
        _mCropShapeCollection.backgroundColor = [UIColor blackColor];
        _mCropShapeCollection.delegate = self;
        _mCropShapeCollection.dataSource = self;
        _mCropShapeCollection.showsVerticalScrollIndicator = NO;
        _mCropShapeCollection.showsHorizontalScrollIndicator = NO;
        _mCropShapeCollection.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_mCropShapeCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIDId];
        [_mCropShapeCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CollectionViewHeadViewId];
        [_mCropShapeCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CollectionViewFootViewId];
    }
    return _mCropShapeCollection;
}

-(UICollectionView*)mRotateComponeCollectionView{
    if (!_mRotateComponeCollectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(80, 30);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.headerReferenceSize = CGSizeZero;
        layout.footerReferenceSize = CGSizeZero;
        layout.minimumInteritemSpacing = 1;
        
        self.mRotateComponeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _mRotateComponeCollectionView.tag = ROTATE_PROPERTY_COLLECTIONVIEW_TAG;
        _mRotateComponeCollectionView.delegate = self;
        _mRotateComponeCollectionView.dataSource = self;
        _mRotateComponeCollectionView.showsHorizontalScrollIndicator = NO;
        _mRotateComponeCollectionView.showsVerticalScrollIndicator = NO;
        _mRotateComponeCollectionView.backgroundColor = [UIColor blackColor];
        [_mRotateComponeCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIDId];
        [_mRotateComponeCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CollectionViewHeadViewId];
        [_mRotateComponeCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CollectionViewFootViewId];
    }
    return _mRotateComponeCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == CROP_RATIO_COLLECTIONVIEW_TAG) {
        return self.mCropRatios.count;
    }else if (collectionView.tag == CROP_SHAPE_COLLECTIONVIEW_TAG){
        return 11;
    }else if (collectionView.tag == ROTATE_PROPERTY_COLLECTIONVIEW_TAG){
        return _mRotateIcons.count;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIDId forIndexPath:indexPath];
    if (collectionView.tag == CROP_RATIO_COLLECTIONVIEW_TAG) {
        if (cell) {
            cell.backgroundView = [[UILabel alloc] init];
            cell.selectedBackgroundView = [[UILabel alloc] init];
            [((UILabel*)(cell.selectedBackgroundView)) setTextColor:_highLightColor];
            [((UILabel*)(cell.backgroundView)) setTextColor:[UIColor whiteColor]];
        }
        ((UILabel*)(cell.backgroundView)).text = [self.mCropRatios objectAtIndex:indexPath.row];
        ((UILabel*)(cell.selectedBackgroundView)).text = [self.mCropRatios objectAtIndex:indexPath.row];
    }else if (collectionView.tag == CROP_SHAPE_COLLECTIONVIEW_TAG){
        if (cell) {
            if (indexPath.row == 0) {
                cell.backgroundView = [[CHWShapeView alloc] initWithShape:CIRCLE_SHAPE];
                cell.selectedBackgroundView = [[CHWShapeView alloc] initWithShape:CIRCLE_SHAPE];
            }else if(indexPath.row == 1){
                cell.backgroundView = [[CHWShapeView alloc] initWithShape:HALF_CIRCLE_SHAPE];
                cell.selectedBackgroundView = [[CHWShapeView alloc] initWithShape:HALF_CIRCLE_SHAPE];
            }else if(indexPath.row == 2){
                cell.backgroundView = [[CHWShapeView alloc] initWithShape:TRIANGLE_SHAPE];
                cell.selectedBackgroundView = [[CHWShapeView alloc] initWithShape:TRIANGLE_SHAPE];
            }else if(indexPath.row == 3){
                cell.backgroundView = [[CHWShapeView alloc] initWithShape:HEART_SHAPE];
                cell.selectedBackgroundView = [[CHWShapeView alloc] initWithShape:HEART_SHAPE];
            }else if(indexPath.row == 4){
                cell.backgroundView = [[CHWShapeView alloc] initWithShape:OVAL_SHAPE];
                cell.selectedBackgroundView = [[CHWShapeView alloc] initWithShape:OVAL_SHAPE];
            }else if(indexPath.row == 5){
                cell.backgroundView = [[CHWShapeView alloc] initWithShape:HEXAGON_SHAPE];
                cell.selectedBackgroundView = [[CHWShapeView alloc] initWithShape:HEXAGON_SHAPE];
            }else if(indexPath.row == 6){
                cell.backgroundView = [[CHWShapeView alloc] initWithShape:OCTAGON_SHAPE];
                cell.selectedBackgroundView = [[CHWShapeView alloc] initWithShape:OCTAGON_SHAPE];
            }else if(indexPath.row == 7){
                cell.backgroundView = [[CHWShapeView alloc] initWithShape:STAR_SHAPE];
                cell.selectedBackgroundView = [[CHWShapeView alloc] initWithShape:STAR_SHAPE];
            }else if(indexPath.row == 8){
                cell.backgroundView = [[CHWShapeView alloc] initWithShape:ARC_SHAPE];
                cell.selectedBackgroundView = [[CHWShapeView alloc] initWithShape:ARC_SHAPE];
            }else if(indexPath.row == 9){
                cell.backgroundView = [[CHWShapeView alloc] initWithShape:CROSS_SHAPE];
                cell.selectedBackgroundView = [[CHWShapeView alloc] initWithShape:CROSS_SHAPE];
            }else if(indexPath.row == 10){
                cell.backgroundView = [[CHWShapeView alloc] initWithShape:SECTOR_SHAPE];
                cell.selectedBackgroundView = [[CHWShapeView alloc] initWithShape:SECTOR_SHAPE];
            }
            [((CHWShapeView*)(cell.backgroundView)) setColor:[UIColor whiteColor]];
            [((CHWShapeView*)(cell.selectedBackgroundView)) setColor:Highlighted_Color];
        }
    }else if (collectionView.tag == ROTATE_PROPERTY_COLLECTIONVIEW_TAG){
        cell.backgroundView = [[UIImageView alloc] initWithImage:[_mRotateIcons objectAtIndex:indexPath.row]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[_mRotateHiglightIcons objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    if (collectionView.tag == CROP_RATIO_COLLECTIONVIEW_TAG){
        if (self.DidCropRatioHandle) {
            self.DidCropRatioHandle(indexPath.row);
        }
    }else if (collectionView.tag == CROP_SHAPE_COLLECTIONVIEW_TAG){
        if (self.DidCropShapeHandle) {
            ShapeType shapeMode = CIRCLE_SHAPE;
            switch (indexPath.row) {
                case 0:
                    shapeMode = CIRCLE_SHAPE;
                    break;
                case 1:
                    shapeMode = HALF_CIRCLE_SHAPE;
                    break;
                case 2:
                    shapeMode = TRIANGLE_SHAPE;
                    break;
                case 3:
                    shapeMode = HEART_SHAPE;
                    break;
                case 4:
                    shapeMode = OVAL_SHAPE;
                    break;
                case 5:
                    shapeMode = HEXAGON_SHAPE;
                    break;
                case 6:
                    shapeMode = OCTAGON_SHAPE;
                    break;
                case 7:
                    shapeMode = STAR_SHAPE;
                    break;
                case 8:
                    shapeMode = ARC_SHAPE;
                    break;
                case 9:
                    shapeMode = CROSS_SHAPE;
                    break;
                case 10:
                    shapeMode = SECTOR_SHAPE;
                    break;
                default:
                    break;
            }
            if (self.DidCropShapeHandle) {
                 self.DidCropShapeHandle(shapeMode);
            }
        }
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }else if (collectionView.tag == ROTATE_PROPERTY_COLLECTIONVIEW_TAG){
        if (indexPath.row == 0) {
            if (self.DidRotate90Handle) {
                self.DidRotate90Handle(YES);
            }
        }else if (indexPath.row == 1) {
            if (self.DidRotate90Handle) {
                self.DidRotate90Handle(NO);
            }
        }
//        else if (indexPath.row == 2) {
//            if (self.DidFlipHandle) {
//                self.DidFlipHandle(YES);
//            }
//        }else if (indexPath.row == 3) {
//            if (self.DidFlipHandle) {
//                self.DidFlipHandle(NO);
//            }
//        }
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
}

-(void)bottomBar:(CHWBottomBar*)bottomBar barDidSelectedItemAtIndex:(NSInteger)index{
    if (index == _currentSelectedIndex) {
        self.currentSelectedIndex = -1;
    }else{
        self.currentSelectedIndex = index;
    }
    if (index == 0) {
        self.mCropRatiosCollection.hidden = NO;
        self.mCropShapeCollection.hidden = YES;
        self.mRotateComponeCollectionView.hidden = YES;
        if (self.ChangeCropStyleHandle) {
            self.ChangeCropStyleHandle(RATIO_STYLE);
        }
    }else if (index == 1) {
        self.mCropRatiosCollection.hidden = YES;
        self.mCropShapeCollection.hidden = NO;
        self.mRotateComponeCollectionView.hidden = YES;
        if (self.ChangeCropStyleHandle) {
            self.ChangeCropStyleHandle(SHAPE_STYLE);
        }
    }else if (index == 2) {
        self.mCropRatiosCollection.hidden = YES;
        self.mCropShapeCollection.hidden = YES;
        self.mRotateComponeCollectionView.hidden = NO;
        if (self.ChangeCropStyleHandle) {
            self.ChangeCropStyleHandle(RATIO_STYLE);
        }
    }
    if (self.currentSelectedIndex == -1) {
        self.mCropRatiosCollection.hidden = YES;
        self.mCropShapeCollection.hidden = YES;
        self.mRotateComponeCollectionView.hidden = YES;
        bottomBar.selectedBarItem = nil;
    }
    [self layoutFrame];
}
@end
