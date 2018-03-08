//
//  RootViewController.m
//  CJTetris
//
//  Created by CoderChenJun on 2018/3/6.
//  Copyright © 2018年 CoderDream. All rights reserved.
//

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "squareOne.h"
#import "squareTwo.h"
#import "squareThree.h"
#import "squareFour.h"
#import "squareFive.h"
#import "squareSix.h"
#import "squareSeven.h"


#define gameViewBackgroundColor   ([UIColor groupTableViewBackgroundColor])
#define promptViewBackgroundColor ([UIColor groupTableViewBackgroundColor])

static RootViewController * instance;



@interface RootViewController()<BaseSquareCaseDelegate>
@property (nonatomic, strong) UIButton *beginButton;/**< 开始按钮 */
@property (nonatomic, strong) UIView *rootView;/**< rootVView */



@property (nonatomic, strong) UILabel *scoreLabel;/**< 得分Label */
@property (nonatomic, strong) UILabel *levelLabel;/**< 等级Label */
@property (nonatomic, assign) NSUInteger score;/**< 得分_数值 */



@property (nonatomic, strong) UIView *gameView;  /**< 游戏区域 View */
@property (nonatomic, strong) UIView *promptView;/**< 提示区域 View */

@property (nonatomic, strong) BaseSquareCase *gameSqureCase;  /**< 游戏区域 方块模型 */
@property (nonatomic, strong) BaseSquareCase *promptSqureCase;/**< 提示区域 方块模型 */

@property (nonatomic, strong) NSMutableArray *gameButtonArray;  /**< 游戏区 数组 */
@property (nonatomic, strong) NSMutableArray *promptButtonArray;/**< 提示区 数组 */

@property (nonatomic, assign) CGFloat OneBlockWidth;/**< 一个方块的宽度 */
@property (nonatomic, assign) CGFloat gameViewNumX;/**< 游戏区横向格子数 */
@property (nonatomic, assign) CGFloat gameViewNumY;/**< 游戏区纵向格子数 */
@property (nonatomic, assign) CGFloat promptViewNumX;/**< 提示区横向格子数 */
@property (nonatomic, assign) CGFloat promptViewNumY;/**< 提示区纵向格子数 */

@property (nonatomic, assign) BOOL isNewCase;// 是否为新色块
@property (nonatomic, strong) UIColor *randomColor;// 色块随机颜色



@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *downButton;
@property (nonatomic, strong) UIButton *topButton;

@property (nonatomic, strong) UIButton *rotateButton;
@property (nonatomic, strong) UIButton *downStraightButton;


@property (nonatomic, strong) NSTimer *tetrisTimer;

@end







@implementation RootViewController


+ (instancetype)sharedRootViewController
{
    if (instance == nil) {
        instance = [[RootViewController alloc] init];
    }
    return instance;
}


- (NSMutableArray *)gameButtonArray
{
    if (_gameButtonArray == nil)
    {
        _gameButtonArray = [NSMutableArray array];
    }
    return _gameButtonArray;
}
- (NSMutableArray *)promptButtonArray
{
    if (_promptButtonArray == nil)
    {
        _promptButtonArray = [NSMutableArray array];
    }
    return _promptButtonArray;
}



- (void)setScore:(NSUInteger)score
{
    _score = score;
    self.scoreLabel.text = [NSString stringWithFormat:@"得分:%lu",(unsigned long)self.score];
    self.levelLabel.text = [NSString stringWithFormat:@"等级:%lu",(self.score/200)];
}







- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.gameViewNumX    = 10;
    self.gameViewNumY    = 20;
    self.promptViewNumX  = 3;
    self.promptViewNumY  = 4;
    self.OneBlockWidth = (UISCREEN_WIDTH - 70) / (2 * self.promptViewNumX + self.gameViewNumX);
    
    
    
    //1创建游戏视图
    [self createBaseView];
    
    //2.创建方块按钮
    [self createSquareButtons];
    
    //3.开始按钮
    [self setupBeginButton];
    
}











#pragma mark ================================================= 创建 - 游戏视图 =================================================
#pragma mark ================================================= 创建 - 游戏视图 =================================================
#pragma mark ================================================= 创建 - 游戏视图 =================================================
//1创建游戏视图
-(void)createBaseView
{
    // 1.1 rootView
    self.rootView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.rootView];
    self.rootView.hidden = YES;
    
    CGFloat labelWidth = (self.view.width - 3 * 30) / 2;
    self.scoreLabel = [[UILabel alloc] init];
    [self.rootView addSubview:self.scoreLabel];
    self.scoreLabel.x      = 30;
    self.scoreLabel.y      = HEIGHT_STATUSBAR + 10;
    self.scoreLabel.width  = labelWidth;
    self.scoreLabel.height = 30;
    
    self.levelLabel = [[UILabel alloc] init];
    [self.rootView addSubview:self.levelLabel];
    self.levelLabel.x      = self.scoreLabel.right + 30;
    self.levelLabel.y      = HEIGHT_STATUSBAR + 10;
    self.levelLabel.width  = labelWidth;
    self.levelLabel.height = 30;
    //清零
    if (self.beginButton.isSelected == NO) {
        self.score = 0;
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    self.gameView = [[UIView alloc] init];//上下左右与边框相隔5,一个按钮单位为1,具体长度为20
    [self.rootView addSubview:self.gameView];
    self.gameView.backgroundColor = gameViewBackgroundColor;
    self.gameView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.gameView.layer.borderWidth = 2.0;
    self.gameView.width  = self.gameViewNumX * self.OneBlockWidth + 10;
    self.gameView.height = self.gameViewNumY * self.OneBlockWidth + 10;
    self.gameView.x      = (self.rootView.width - self.gameView.width) / 2;
    self.gameView.y      = self.scoreLabel.bottom + 10;
    
    
    self.promptView = [[UIView alloc] init];
    [self.rootView addSubview:self.promptView];
    self.promptView.backgroundColor = promptViewBackgroundColor;
    self.promptView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.promptView.layer.borderWidth = 2.0;
    self.promptView.width  = self.promptViewNumX * self.OneBlockWidth + 10;
    self.promptView.height = self.promptViewNumY * self.OneBlockWidth + 10;
    self.promptView.x      = (self.gameView.x - self.promptView.width) / 2;
    self.promptView.y      = self.scoreLabel.bottom + 10;
    
    
    
    
    
    
    
//    CGFloat badgeX = 50;
//    CGFloat badgeY = 30;
//
//    self.downButton = [[UIButton alloc] init];
//    [self.rootView addSubview:self.downButton];
//    [self.downButton addTarget:self action:@selector(downClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.downButton setTitle:@"下" forState:UIControlStateNormal];
//    [self.downButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.downButton.backgroundColor = CJColor(200, 200, 200);
//    self.downButton.layer.masksToBounds = YES;
//    self.downButton.layer.cornerRadius  = 10;
//    self.downButton.width  = 50;
//    self.downButton.height = 50;
//    self.downButton.x      = (UISCREEN_WIDTH - self.downButton.width) / 2;
//    self.downButton.y      = UISCREEN_HEIGHT - self.downButton.height - 10;
//
//    self.rotateButton = [[UIButton alloc] init];
//    [self.rootView addSubview:self.rotateButton];
//    [self.rotateButton addTarget:self action:@selector(rotateClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.rotateButton setTitle:@"转" forState:UIControlStateNormal];
//    [self.rotateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.rotateButton.backgroundColor = CJColor(200, 200, 200);
//    self.rotateButton.layer.masksToBounds = YES;
//    self.rotateButton.layer.cornerRadius  = 10;
//    self.rotateButton.width  = 50;
//    self.rotateButton.height = 50;
//    self.rotateButton.x      = (UISCREEN_WIDTH - self.rotateButton.width) / 2;
//    self.rotateButton.y      = self.downButton.y - 2*self.rotateButton.height;
//
//    CGFloat twoY = (self.downButton.bottom + self.rotateButton.y) / 2 - 25;
//    self.leftButton = [[UIButton alloc] init];
//    [self.rootView addSubview:self.leftButton];
//    [self.leftButton addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.leftButton setTitle:@"左" forState:UIControlStateNormal];
//    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.leftButton.backgroundColor = CJColor(200, 200, 200);
//    self.leftButton.layer.masksToBounds = YES;
//    self.leftButton.layer.cornerRadius  = 10;
//    self.leftButton.width  = 50;
//    self.leftButton.height = 50;
//    self.leftButton.x      = self.downButton.x - self.leftButton.width;
//    self.leftButton.y      = twoY;
//
//    self.rightButton = [[UIButton alloc] init];
//    [self.rootView addSubview:self.rightButton];
//    [self.rightButton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.rightButton setTitle:@"右" forState:UIControlStateNormal];
//    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.rightButton.backgroundColor = CJColor(200, 200, 200);
//    self.rightButton.layer.masksToBounds = YES;
//    self.rightButton.layer.cornerRadius  = 10;
//    self.rightButton.width  = 50;
//    self.rightButton.height = 50;
//    self.rightButton.x      = self.downButton.right;
//    self.rightButton.y      = twoY;
    
    
    // 左
    self.leftButton = [[UIButton alloc] init];
    [self.rootView addSubview:self.leftButton];
    [self.leftButton addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton setTitle:@"左" forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.backgroundColor = CJColor(200, 200, 200);
    self.leftButton.layer.masksToBounds = YES;
    self.leftButton.layer.cornerRadius  = 10;
    self.leftButton.width  = 50;
    self.leftButton.height = 50;
    self.leftButton.x      = 10;
    self.leftButton.y      = UISCREEN_HEIGHT - 2*self.leftButton.height - 10;
    // 右
    self.rightButton = [[UIButton alloc] init];
    [self.rootView addSubview:self.rightButton];
    [self.rightButton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitle:@"右" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rightButton.backgroundColor = CJColor(200, 200, 200);
    self.rightButton.layer.masksToBounds = YES;
    self.rightButton.layer.cornerRadius  = 10;
    self.rightButton.width  = 50;
    self.rightButton.height = 50;
    self.rightButton.x      = self.leftButton.right + self.leftButton.width;
    self.rightButton.y      = self.leftButton.y;
    // 下
    self.downButton = [[UIButton alloc] init];
    [self.rootView addSubview:self.downButton];
    [self.downButton addTarget:self action:@selector(downClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.downButton setTitle:@"下" forState:UIControlStateNormal];
    [self.downButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.downButton.backgroundColor = CJColor(200, 200, 200);
    self.downButton.layer.masksToBounds = YES;
    self.downButton.layer.cornerRadius  = 10;
    self.downButton.width  = 50;
    self.downButton.height = 50;
    self.downButton.x      = self.leftButton.right;
    self.downButton.y      = self.leftButton.bottom;
    // 上
    self.topButton = [[UIButton alloc] init];
    [self.rootView addSubview:self.topButton];
    [self.topButton addTarget:self action:@selector(rotateClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topButton setTitle:@"上" forState:UIControlStateNormal];
    [self.topButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.topButton.backgroundColor = CJColor(200, 200, 200);
    self.topButton.layer.masksToBounds = YES;
    self.topButton.layer.cornerRadius  = 10;
    self.topButton.width  = 50;
    self.topButton.height = 50;
    self.topButton.x      = self.leftButton.right;
    self.topButton.y      = self.leftButton.y - self.leftButton.height;
    // 转
    self.rotateButton = [[UIButton alloc] init];
    [self.rootView addSubview:self.rotateButton];
    [self.rotateButton addTarget:self action:@selector(rotateClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rotateButton setTitle:@"转" forState:UIControlStateNormal];
    [self.rotateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rotateButton.backgroundColor = CJColor(200, 200, 200);
    self.rotateButton.layer.masksToBounds = YES;
    self.rotateButton.layer.cornerRadius  = 10;
    self.rotateButton.width  = 50;
    self.rotateButton.height = 50;
    self.rotateButton.x      = UISCREEN_WIDTH - self.leftButton.width - self.leftButton.right;
    self.rotateButton.y      = self.leftButton.y - self.leftButton.height;
    // 降
    self.downStraightButton = [[UIButton alloc] init];
    [self.rootView addSubview:self.downStraightButton];
    [self.downStraightButton addTarget:self action:@selector(downStraightClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.downStraightButton setTitle:@"降" forState:UIControlStateNormal];
    [self.downStraightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.downStraightButton.backgroundColor = CJColor(200, 200, 200);
    self.downStraightButton.layer.masksToBounds = YES;
    self.downStraightButton.layer.cornerRadius  = 10;
    self.downStraightButton.width  = 50;
    self.downStraightButton.height = 50;
    self.downStraightButton.x      = UISCREEN_WIDTH - self.leftButton.width - self.leftButton.right;
    self.downStraightButton.y      = self.leftButton.bottom;
    
    
    
}

- (void)leftClick:(UIButton *)leftButton
{
    [self.gameSqureCase squareMoveLeft];
}
- (void)rightClick:(UIButton *)rightButton
{
    [self.gameSqureCase squareMoveRight];
}
- (void)downClick:(UIButton *)downButton
{
    [self.gameSqureCase squareMoveDown];
}
- (void)rotateClick:(UIButton *)rotateButton
{
    [self.gameSqureCase squareRound];
}
- (void)downStraightClick:(UIButton *)downButton
{
    while (self.isNewCase == NO) {
        [self.gameSqureCase squareMoveDown];
    }
}
#pragma mark ================================================= 创建 - 游戏视图 =================================================
#pragma mark ================================================= 创建 - 游戏视图 =================================================
#pragma mark ================================================= 创建 - 游戏视图 =================================================





#pragma mark ================================================= 创建 - 方块按钮 =================================================
#pragma mark ================================================= 创建 - 方块按钮 =================================================
#pragma mark ================================================= 创建 - 方块按钮 =================================================
/**
 * 2.创建方块按钮
 */
-(void)createSquareButtons
{
    //200个游戏区按钮------宽度10*20，高度20*20，内边距为5
    for (int x = 0; x < self.gameViewNumX; x++) {
        for (int y = 0; y < self.gameViewNumY; y++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.gameButtonArray addObject:button];
            
            //100,77分别是游戏视图和手机边框所隔宽度,加上边框线条宽度,以及设置frame
            button.frame = CGRectMake(x*self.OneBlockWidth+5, y*self.OneBlockWidth+5, self.OneBlockWidth, self.OneBlockWidth);
            
            button.layer.cornerRadius = 4.0;
            button.layer.borderWidth = 1.0;
            button.layer.borderColor = [[UIColor blackColor] CGColor];
            
            //无法点击并且隐藏
            button.enabled = NO;
            button.hidden = YES;
            
            //设定tag,方便后面获取
            button.tag = x + y * 100 + 10000;
            [self.gameView addSubview:button];
            
        }
    }
    //12个提示区按钮(不用边框)
    for (int x = 0; x < self.promptViewNumX; x++) {
        for (int y = 0; y < self.promptViewNumY; y++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.promptButtonArray addObject:button];
            
            button.frame = CGRectMake(x*self.OneBlockWidth+5, y*self.OneBlockWidth+5, self.OneBlockWidth, self.OneBlockWidth);
            
            button.layer.cornerRadius = 4.0;
            button.layer.borderWidth  = 1.0;
            button.layer.borderColor  = [[UIColor blackColor] CGColor];
            
            button.enabled = NO;
            button.hidden  = YES;
            
            //tag
            button.tag = x + y * 3 + 500;
            [self.promptView addSubview:button];
        }
    }
}
#pragma mark ================================================= 创建 - 方块按钮 =================================================
#pragma mark ================================================= 创建 - 方块按钮 =================================================
#pragma mark ================================================= 创建 - 方块按钮 =================================================















#pragma mark ================================================= 方块 - 落下方法 =================================================
#pragma mark ================================================= 方块 - 落下方法 =================================================
#pragma mark ================================================= 方块 - 落下方法 =================================================
//4.1.1调用下移方法
-(void)doMainSquareMoveDown
{
    self.isNewCase = NO;
    //4.1.1.1按钮下移
    [self.gameSqureCase squareMoveDown];
    
}

//5.squareMoveDown方法回调
-(void)squareDownToEnd
{
    self.isNewCase = YES;
    
    //5.1消除一行满了的按钮
    [self deleteButton];
    
    //5.2判断按钮状态，判断游戏结束
    if ([self checkGameState]) {
        self.beginButton.hidden  = NO;
        [self stopButtonClick];
        return;
    }
    
    //新赋值 //把提示区的按钮赋值给游戏区
    [self promptSqureCaseToGameSqureCase];
}

/**
 * 5.1消除一行满了的按钮
 */
-(void)deleteButton
{
    BOOL flage;
    for (int y = (self.gameViewNumY-1); y >= 0; y--) {
        flage = NO;
        for (int x = 0; x < self.gameViewNumX; x++) {
            //5.1.1以布尔值显示按钮状态：隐藏or显示.(0,19)处有按钮时,不满足条件,不进行判断,直接进行自加;一行加完后执行下一个if;如果没有按钮,这一行就不可能满,就不用再判断这一行,break.
            if (![self getButtonShowStateX:x Y:y]) {
                flage = YES;
                printf("x: %d, y: %d\n", x, y);
                break;
            }
        }
        
        //当判断完y=19这一行都有按钮时
        if (!flage) {
            //5.1.2根据y值设置按钮显示状态(消除满行时调用方法),隐藏y=19这一行
            [self setButtonShowState:y];
            //5.1.3消除一行后的上一行下移,将y=18这一行的按钮隐藏,显示到y=19这行上
            [self resetButtonPoint:y-1];
            //消除一行后,还是从这行开始,自加后再循环中自减
            ++y;
        }

    }
}


/**
 * 5.1.1以布尔值显示按钮状态：判断 x y 这一格按钮显示状态
 * @return YES：按钮存在并且显示；NO：按钮不存在或隐藏
 */
- (BOOL)getButtonShowStateX:(NSInteger)x Y:(NSInteger)y
{
    UIButton *button = (UIButton *)[self.gameView viewWithTag:(x + y * 100 + 10000)];
    if (button && button.hidden == NO) {
        return YES;
    } else
        return NO;
}

/**
 * 5.1.2根据y值设置按钮显示状态(消除满行时调用方法)
 */
-(void)setButtonShowState:(NSInteger)y
{
    for (int i = 0; i < self.gameViewNumX; i++) {
        UIButton * button = (UIButton *)[self.gameView viewWithTag:(y * 100 + i + 10000)];
        if (button) {
            button.hidden = YES;
        }
    }
}

/**
 * 5.1.3消除一行后的上一行下移
 */
-(void)resetButtonPoint:(NSInteger)y
{
    //重置标签,有得分后标签显示这个
    self.score += 100;
    
    //如y=19消除,y-1=18
    for (NSInteger j = y; j >= 0; j--) {
        for (NSInteger i = 0; i < self.gameViewNumX; i++) {
            UIButton * button = (UIButton *)[self.gameView viewWithTag:(j * 100 + i + 10000)];
            if (button && button.hidden == NO) {
                //让消除了的这行的上一行的按钮隐藏
                button.hidden = YES;
                button = (UIButton *)[self.gameView viewWithTag:((j+1) * 100 + i + 10000)];
                //让18行显示到19行上
                button.hidden = NO;
                
            }
        }
    }
    
}

/**
 * 5.2 检查游戏状态
 * @return YES：结束；NO：未结束
 */
- (BOOL)checkGameState
{
    for (int x = 0; x < self.gameViewNumX; x++) {
        if ([self getButtonShowStateX:x Y:0]) {
            return YES;
        }
    }
    return NO;
}
#pragma mark ================================================= 方块 - 落下方法 =================================================
#pragma mark ================================================= 方块 - 落下方法 =================================================
#pragma mark ================================================= 方块 - 落下方法 =================================================











//3.开始按钮
-(void)setupBeginButton
{
    self.beginButton = [[UIButton alloc] init];
    [self.view addSubview:self.beginButton];
    [self.beginButton addTarget:self action:@selector(beginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.beginButton setTitle:@"开始游戏" forState:UIControlStateNormal];
    [self.beginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.beginButton.backgroundColor = CJColor(200, 200, 200);
    self.beginButton.layer.masksToBounds = YES;
    self.beginButton.layer.cornerRadius  = 10;
    self.beginButton.width  = 200;
    self.beginButton.height = 50;
    self.beginButton.x      = (self.view.width - self.beginButton.width) / 2;
    self.beginButton.y      = (self.view.height - self.beginButton.height) / 2;
    
    
}

//3.1点击开始按钮
-(void)beginButtonClick
{
    self.score = 0;
    
    for (int x = 0; x < self.gameViewNumX; x++) {
        for (int y = 0; y < self.gameViewNumY; y++) {
            UIButton * button = (UIButton *)[self.gameView viewWithTag:(x + y * 100 + 10000)];
            if (button) {
                //不隐藏直接显示2000,因为全部满行消除,直接2000
                button.hidden = YES;
            }
        }
    }
    
    //3.1.2创建随机按钮组合
    [self createPromptSqureCase];
    
    //把提示区的按钮赋值给游戏区
    [self promptSqureCaseToGameSqureCase];
    
    self.rootView.userInteractionEnabled = YES;
    self.rootView.hidden                 = NO;
    self.beginButton.hidden  = YES;
    
    [self addTetrisTimer];
    
}
- (void)stopButtonClick
{
    self.rootView.userInteractionEnabled = NO;
    [self removeTetrisTimer];
}

/**
 * 方块：提示区->游戏区
 *
 * 1、游戏区，区域宽高赋值
 * 2、游戏区，方块初始默认上移几格
 * 3、游戏区，方块初始横向随机出现
 * 4、提示区，重新生成随机方块
 */
- (void)promptSqureCaseToGameSqureCase
{
    // 1、游戏区，区域宽高赋值
    self.promptSqureCase.gameViewNumX = self.gameViewNumX;
    self.promptSqureCase.gameViewNumY = self.gameViewNumY;
    self.gameSqureCase = self.promptSqureCase;
    
    // 2、游戏区，方块初始默认上移几格
    [self.gameSqureCase promptToGame];
    
#warning - 方块横向随机位置出现
    // 3、游戏区，方块初始横向随机出现
    [self.gameSqureCase randomPosition:[CJToolkit randomIntegerBetween:0 andLargerInteger:(self.gameViewNumX - self.promptViewNumX)]];
    
    // 4、提示区，重新生成随机方块
    [self createPromptSqureCase];
    
}
















#pragma mark ================================================= 提示区 - 创建随机方块 =================================================
#pragma mark ================================================= 提示区 - 创建随机方块 =================================================
#pragma mark ================================================= 提示区 - 创建随机方块 =================================================
/**
 * 3.1.2提示区 - 创建随机方块
 */
-(void)createPromptSqureCase
{
    NSInteger randomInteger = [CJToolkit randomIntegerBetween:0 andLargerInteger:6];
    switch (randomInteger) {
        case 0:// 红
            self.promptSqureCase = [[squareOne alloc] init];
            for (UIButton *btn in self.promptButtonArray) {
                btn.backgroundColor = CJColor(255, 0, 0);
            }
            self.gameSqureCase.caseColor = self.randomColor;
            self.randomColor = CJColor(255, 0, 0);
            break;
            
        case 1:// 橙
            self.promptSqureCase = [[squareTwo alloc] init];
            for (UIButton *btn in self.promptButtonArray) {
                btn.backgroundColor = CJColor(255, 125, 0);
            }
            self.gameSqureCase.caseColor = self.randomColor;
            self.randomColor = CJColor(255, 125, 0);
            break;
            
        case 2:// 黄
            self.promptSqureCase = [[squareThree alloc] init];
            for (UIButton *btn in self.promptButtonArray) {
                btn.backgroundColor = CJColor(255, 255, 0);
            }
            self.gameSqureCase.caseColor = self.randomColor;
            self.randomColor = CJColor(255, 255, 0);
            break;
            
        case 3:// 绿
            self.promptSqureCase = [[squareFour alloc] init];
            for (UIButton *btn in self.promptButtonArray) {
                btn.backgroundColor = CJColor(0, 255, 0);
            }
            self.gameSqureCase.caseColor = self.randomColor;
            self.randomColor = CJColor(0, 255, 0);
            break;
            
        case 4:// 蓝
            self.promptSqureCase = [[squareFive alloc] init];
            for (UIButton *btn in self.promptButtonArray) {
                btn.backgroundColor = CJColor(0, 0, 255);
            }
            self.gameSqureCase.caseColor = self.randomColor;
            self.randomColor = CJColor(0, 0, 255);
            break;
            
        case 5:// 靛
            self.promptSqureCase = [[squareSix alloc] init];
            for (UIButton *btn in self.promptButtonArray) {
                btn.backgroundColor = CJColor(0, 255, 255);
            }
            self.gameSqureCase.caseColor = self.randomColor;
            self.randomColor = CJColor(0, 255, 255);
            break;
            
        case 6:// 紫
            self.promptSqureCase = [[squareSeven alloc] init];
            for (UIButton *btn in self.promptButtonArray) {
                btn.backgroundColor = CJColor(255, 0, 255);
            }
            self.gameSqureCase.caseColor = self.randomColor;
            self.randomColor = CJColor(255, 0, 255);
            break;
            
            
        default:
            break;
    }
    
    //3.1.2.2把提示区可能出现的6种情况都调用方法给提示区按钮
    [self remindSquare:self.promptSqureCase];
    self.promptSqureCase.delegate = self;
    
}

//3.1.2.2把提示区可能出现的6种情况都调用方法给提示区按钮
- (void)remindSquare:(BaseSquareCase *)square
{
    UIButton * button;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 4; j++) {
            //定值要改全部改
            button = (UIButton *)[self.promptView viewWithTag:(i + j*3 + 500)];
            //隐藏游戏界面的提示区
            button.hidden = YES;
        }
    }
    
    //提示区四个按钮创建并且显示
    button = (UIButton *)[self.promptView viewWithTag:(square.case1.x + square.case1.y * 3 +500)];
    button.hidden = NO;
    button = (UIButton *)[self.promptView viewWithTag:(square.case2.x + square.case2.y * 3 +500)];
    button.hidden = NO;
    button = (UIButton *)[self.promptView viewWithTag:(square.case3.x + square.case3.y * 3 +500)];
    button.hidden = NO;
    button = (UIButton *)[self.promptView viewWithTag:(square.case4.x + square.case4.y * 3 +500)];
    button.hidden = NO;
    
}
#pragma mark ================================================= 提示区 - 创建随机方块 =================================================
#pragma mark ================================================= 提示区 - 创建随机方块 =================================================
#pragma mark ================================================= 提示区 - 创建随机方块 =================================================









#pragma mark ================================================= 定时器 - 操作方法 =================================================
#pragma mark ================================================= 定时器 - 操作方法 =================================================
#pragma mark ================================================= 定时器 - 操作方法 =================================================
- (void)addTetrisTimer
{
    // 1.创建定时器
    self.tetrisTimer = [NSTimer timerWithTimeInterval:(1.0 - (self.score/200) * 0.05)
                                               target:self
                                             selector:@selector(timerFunction)
                                             userInfo:nil
                                              repeats:YES];
    // 2.添加到运行时中,并循环
    NSRunLoop *looper = [NSRunLoop mainRunLoop] ;
    [looper addTimer:self.tetrisTimer forMode:NSRunLoopCommonModes];
    
    NSLog(@"启动定时器");
    
}

- (void)removeTetrisTimer
{
    // 1.从运行循环中移除
    [self.tetrisTimer invalidate];
    // 2.清空定时器
    self.tetrisTimer = nil;
    NSLog(@"销毁定时器");
}

- (void)timerFunction
{
    NSLog(@"进到定时方法");
    NSTimeInterval nowInterval = self.tetrisTimer.timeInterval;
    if (nowInterval == (1.0 - (self.score/200) * 0.05)) {
        [self doMainSquareMoveDown];
    }
    else {
        [self removeTetrisTimer];
        [self addTetrisTimer];
    }
}
#pragma mark ================================================= 定时器 - 操作方法 =================================================
#pragma mark ================================================= 定时器 - 操作方法 =================================================
#pragma mark ================================================= 定时器 - 操作方法 =================================================





@end

