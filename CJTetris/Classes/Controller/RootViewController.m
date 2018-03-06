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

// 一个方块的宽度
#define OneBlockWidth (20)

static RootViewController * instance;



@interface RootViewController()



/** 游戏区 数组 */
@property (nonatomic, strong) NSMutableArray *gameButtonArray;

/** 提示区 数组 */
@property (nonatomic, strong) NSMutableArray *promptButtonArray;



@property (nonatomic, strong) UIColor *randomColor;// 色块随机颜色
@property (nonatomic, assign) NSUInteger score;//得分_数值
@property (nonatomic, assign) NSUInteger level;//等级_数值
@property (nonatomic, assign) BOOL isNewCase;// 是否为新色块





@property (nonatomic, strong) UIButton *beginButton;//开始按钮

@property (nonatomic, strong) UIView *rootView;// rootVView

@property (nonatomic, strong) UILabel *scoreLabel;// 得分Label
@property (nonatomic, strong) UILabel *levelLabel;// 等级Label

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *downButton;
@property (nonatomic, strong) UIButton *rotateButton;

@property (nonatomic, strong) UIView *gameView;  // 游戏区域 View
@property (nonatomic, strong) UIView *promptView;// 提示区域 View

@property (nonatomic, strong) BaseSquareCase *gameSqureCase;  // 游戏区域 方块模型
@property (nonatomic, strong) BaseSquareCase *promptSqureCase;// 提示区域 方块模型



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





- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //1创建游戏视图
    [self createBaseView];
    
    //2.创建方块按钮
    [self createSquare];
    
    //3.开始按钮
    [self setupBeginButton];
    
    //    //4.时间控制
    //    [self initTimer];
    
    
}

//1创建游戏视图
-(void)createBaseView
{
    // 1.1 rootView
    self.rootView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.rootView];
    self.rootView.hidden = YES;
    
    
    //清零
    if (self.beginButton.isSelected == NO) {
        self.score = 0;
        self.level = 0;
        //        self.scoreLabel.text = [NSString stringWithFormat:@"得分:%d",0];
        //        self.levelLabel.text = [NSString stringWithFormat:@"等级:%d",0];
    }
    CGFloat labelWidth = (self.view.width - 3 * 30) / 2;
    self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10 + HEIGHT_STATUSBAR, labelWidth, 40)];
    self.scoreLabel.text = [NSString stringWithFormat:@"得分:%lu",(unsigned long)self.score];
    self.levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.scoreLabel.right + 30, 10 + HEIGHT_STATUSBAR, labelWidth, 40)];
    self.levelLabel.text = [NSString stringWithFormat:@"等级:%lu",(self.score/200)];
    [self.rootView addSubview:self.scoreLabel];
    [self.rootView addSubview:self.levelLabel];
    
    
    
    
    
    CGFloat gameViewW = 10*OneBlockWidth + 10;
    CGFloat gameViewH = 20*OneBlockWidth + 10;
    CGFloat gameViewX = (self.rootView.width - gameViewW) / 2;
    CGFloat gameViewY = 80 + HEIGHT_STATUSBAR;
    self.gameView = [[UIView alloc] initWithFrame:CGRectMake(gameViewX, gameViewY, gameViewW, gameViewH)];//上下左右与边框相隔5,一个按钮单位为1,具体长度为20
    [self.rootView addSubview:self.gameView];
    self.gameView.backgroundColor = CJColorWithalpha(0, 255, 231, 1);
    self.gameView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.gameView.layer.borderWidth = 2.0;
    
    
    
    CGFloat promptViewW = 3*OneBlockWidth + 10;
    CGFloat promptViewH = 4*OneBlockWidth + 10;
    CGFloat promptViewX = (gameViewX - promptViewW) / 2;
    CGFloat promptViewY = 80 + HEIGHT_STATUSBAR;
    self.promptView = [[UIView alloc] initWithFrame:CGRectMake(promptViewX, promptViewY, promptViewW, promptViewH)];
    [self.rootView addSubview:self.promptView];
    self.promptView.backgroundColor = CJColorWithalpha(0, 255, 231, 1);
    self.promptView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.promptView.layer.borderWidth = 2.0;
    
    
    
    
    
    
    
    
    
    
    CGFloat badgeX = 50;
    CGFloat badgeY = 30;
    self.downButton = [[UIButton alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH - 50) / 2, UISCREEN_HEIGHT - badgeY - 50, 50, 50)];
    [self.rootView addSubview:self.downButton];
    [self.downButton setTitle:@"下" forState:UIControlStateNormal];
    [self.downButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.downButton.backgroundColor = CJColor(200, 200, 200);
    self.downButton.layer.masksToBounds = YES;
    self.downButton.layer.cornerRadius  = 10;
    [self.downButton addTarget:self action:@selector(downClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rotateButton = [[UIButton alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH - 50) / 2, (UISCREEN_HEIGHT-badgeY-50) - badgeY - 50, 50, 50)];
    [self.rootView addSubview:self.rotateButton];
    [self.rotateButton setTitle:@"转" forState:UIControlStateNormal];
    [self.rotateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rotateButton.backgroundColor = CJColor(200, 200, 200);
    self.rotateButton.layer.masksToBounds = YES;
    self.rotateButton.layer.cornerRadius  = 10;
    [self.rotateButton addTarget:self action:@selector(rotateClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat twoY = (self.downButton.bottom + self.rotateButton.y) / 2 - 25;
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(self.downButton.x - badgeX - 50, twoY, 50, 50)];
    [self.rootView addSubview:self.leftButton];
    [self.leftButton setTitle:@"左" forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.backgroundColor = CJColor(200, 200, 200);
    self.leftButton.layer.masksToBounds = YES;
    self.leftButton.layer.cornerRadius  = 10;
    [self.leftButton addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.downButton.right + badgeX, twoY, 50, 50)];
    [self.rootView addSubview:self.rightButton];
    [self.rightButton setTitle:@"右" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rightButton.backgroundColor = CJColor(200, 200, 200);
    self.rightButton.layer.masksToBounds = YES;
    self.rightButton.layer.cornerRadius  = 10;
    [self.rightButton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}


//2.创建方块按钮
-(void)createSquare
{
    
    //200个游戏区按钮------宽度10*20，高度20*20，内边距为5
    for (int x = 0; x < 10; x++) {
        for (int y = 0; y < 20; y++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.gameButtonArray addObject:button];
            
            //100,77分别是游戏视图和手机边框所隔宽度,加上边框线条宽度,以及设置frame
            button.frame = CGRectMake(x*OneBlockWidth+5, y*OneBlockWidth+5, OneBlockWidth, OneBlockWidth);
            
            button.layer.cornerRadius = 4.0;
            button.layer.borderWidth = 1.0;
            button.layer.borderColor = [[UIColor blackColor] CGColor];
            
            //无法点击并且隐藏
            button.enabled = NO;
            button.hidden = YES;
            
            //设定tag,方便后面获取
            button.tag = x + y * 10 + 100;
            [self.gameView addSubview:button];
            
        }
    }
    
    //12个提示区按钮(不用边框)
    for (int x = 0; x < 3; x++) {
        for (int y = 0; y < 4; y++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.promptButtonArray addObject:button];
            
            button.frame = CGRectMake(x*OneBlockWidth+5, y*OneBlockWidth+5, OneBlockWidth, OneBlockWidth);
            
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












//3.开始按钮
-(void)setupBeginButton
{
    self.beginButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width - 200) / 2, (self.view.height - 50) / 2, 200, 50)];
    [self.view addSubview:self.beginButton];
    [self.beginButton setTitle:@"开始游戏" forState:UIControlStateNormal];
    [self.beginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.beginButton.backgroundColor = CJColor(200, 200, 200);
    self.beginButton.layer.masksToBounds = YES;
    self.beginButton.layer.cornerRadius  = 10;
    [self.beginButton addTarget:self action:@selector(beginButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

//3.1点击开始按钮
-(void)beginButtonClick
{
    self.score = 0;
    self.level = 0;
    
    for (int x = 0; x < 10; x++) {
        for (int y = 0; y < 20; y++) {
            UIButton * button = (UIButton *)[self.gameView viewWithTag:x + y * 10 + 100];
            if (button) {
                //不隐藏直接显示2000,因为全部满行消除,直接2000
                button.hidden = YES;
            }
        }
    }
    
    //3.1.2创建随机按钮组合
    [self createCase];
    //把提示区的按钮赋值给游戏区
    self.gameSqureCase = self.promptSqureCase;
    // 重新随机出,此时不用再隐藏开始按钮
    [self createCase];
    
    
    self.rootView.hidden = NO;
    self.beginButton.hidden  = YES;
    
    
    
    
    // 启动定时器
    [self addTetrisTimer];
    
    
}



//3.1.2创建随机按钮组合,刚刚出来的时候按钮形状,正方形和直线只有一种,另外两种各自两种情况
-(void)createCase
{
    //得到秒,根据秒来出随机形状,刚开始没有值,获取当前时间
    static NSUInteger seconds;
    if (!seconds) {
        
        //3.1.2.1得到当前时间
        seconds = [self getCurrentTime];
        srand(seconds);
    }
    
    //除以6的余数,rand()是整形
    switch (rand()%6) {
        case 0:
            self.promptSqureCase = [[squareOne alloc] init];
            for (UIButton *btn in self.promptButtonArray) {
                btn.backgroundColor = [UIColor redColor];
            }
            
            self.gameSqureCase.caseColor = self.randomColor;
            self.randomColor = [UIColor redColor];
            
            
            break;
        case 1:
            self.promptSqureCase = [[squareTwo alloc] init];
            for (UIButton *btn in self.promptButtonArray) {
                btn.backgroundColor = [UIColor orangeColor];
            }
            
            self.gameSqureCase.caseColor = self.randomColor;
            self.randomColor = [UIColor orangeColor];
            
            break;
        case 2:
            self.promptSqureCase = [[squareThree alloc] init];
            for (UIButton *btn in self.promptButtonArray) {
                btn.backgroundColor = [UIColor yellowColor];
            }
            
            self.gameSqureCase.caseColor = self.randomColor;
            self.randomColor = [UIColor yellowColor];
            
            break;
        case 3:
            self.promptSqureCase = [[squareFour alloc] init];
            for (UIButton *btn in self.promptButtonArray) {
                btn.backgroundColor = [UIColor greenColor];
            }
            
            self.gameSqureCase.caseColor = self.randomColor;
            self.randomColor = [UIColor greenColor];
            
            break;
        case 4:
            self.promptSqureCase = [[squareFive alloc] init];
            for (UIButton *btn in self.promptButtonArray) {
                btn.backgroundColor = [UIColor blueColor];
            }
            
            self.gameSqureCase.caseColor = self.randomColor;
            self.randomColor = [UIColor blueColor];
            
            break;
        case 5:
            self.promptSqureCase = [[squareSix alloc] init];
            for (UIButton *btn in self.promptButtonArray) {
                btn.backgroundColor = [UIColor purpleColor];
            }
            
            self.gameSqureCase.caseColor = self.randomColor;
            self.randomColor = [UIColor purpleColor];
            
            break;
        default:
            break;
    }
    
    //3.1.2.2把提示区可能出现的6种情况都调用方法给提示区按钮
    [self remindSquare:self.promptSqureCase];
    self.promptSqureCase.delegate = self;
    
}

//3.1.2.1得到当前时间
-(NSUInteger)getCurrentTime
{
    
    //设置时间数据
    NSDate * startDate = [[NSDate alloc] init];
    
    //设置日历
    NSCalendar * chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    //方便拿出来直接调用
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    //取到秒
    NSDateComponents * cps = [chineseCalendar components:unitFlags fromDate:startDate];
    NSUInteger second = [cps second];
    return second;
    
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














#pragma mark ========================================= 方块落下方法 =========================================
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
    
    //新赋值
    self.gameSqureCase = self.promptSqureCase;
    
    //5.2判断按钮状态
    if ([self checkGameState]) {
        self.beginButton.hidden  = NO;
        [self removeTetrisTimer];
        return;
    }
    
    //新按钮
    [self createCase];
}

//5.1消除一行满了的按钮
-(void)deleteButton
{
    BOOL flage;
    for (int y = 19; y >= 0; y--) {
        flage = NO;
        for (int x = 0; x < 10; x++) {
            
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

//5.1.1以布尔值显示按钮状态：隐藏or显示
-(BOOL)getButtonShowStateX:(NSInteger)x Y:(NSInteger)y
{
    UIButton * button = (UIButton *)[self.gameView viewWithTag:x + y*10 + 100];
    if (button && button.hidden == NO) {
        return YES;
    } else
        return NO;
}

//5.1.2根据y值设置按钮显示状态(消除满行时调用方法)
-(void)setButtonShowState:(NSInteger)y
{
    for (int i = 0; i < 10; i++) {
        UIButton * button = (UIButton *)[self.gameView viewWithTag:y*10 + i + 100];
        if (button) {
            button.hidden = YES;
        }
    }
}

//5.1.3消除一行后的上一行下移
-(void)resetButtonPoint:(NSInteger)y
{
    
    //重置标签,有得分后标签显示这个
    self.score += 100;
    self.scoreLabel.text = [NSString stringWithFormat:@"得分:%lu",(unsigned long)self.score];
    self.levelLabel.text = [NSString stringWithFormat:@"等级:%d",(int)(self.score/200)];
    
    //如y=19消除,y-1=18
    for (NSInteger j = y; j >= 0; j--) {
        for (NSInteger i = 0; i < 10; i++) {
            UIButton * button = (UIButton *)[self.gameView viewWithTag:j*10 + i + 100];
            if (button && button.hidden == NO) {
                
                //让消除了的这行的上一行的按钮隐藏
                button.hidden = YES;
                
                button = (UIButton *)[self.gameView viewWithTag:(j+1)*10 + i + 100];
                
                //让18行显示到19行上
                button.hidden = NO;
                
            }
        }
    }
    
}

//5.2判断按钮状态
-(BOOL)checkGameState
{
    
    //5.2.1根据所传参数判断是否越界
    if ([self.gameSqureCase beyondBoundsX:self.gameSqureCase.case1.x Y:self.gameSqureCase.case1.y]
        || [self.gameSqureCase beyondBoundsX:self.gameSqureCase.case2.x Y:self.gameSqureCase.case2.y]
        || [self.gameSqureCase beyondBoundsX:self.gameSqureCase.case3.x Y:self.gameSqureCase.case3.y]
        || [self.gameSqureCase beyondBoundsX:self.gameSqureCase.case4.x Y:self.gameSqureCase.case4.y]) {
        return YES;
    }
    return NO;
    
}
#pragma mark ========================================= 方块落下方法 =========================================













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
    while (self.isNewCase == NO) {
        [self.gameSqureCase squareMoveDown];
    }
}

- (void)rotateClick:(UIButton *)rotateButton
{
    [self.gameSqureCase squareRound];
}
















#pragma mark - 对定时器的操作方法
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





@end

