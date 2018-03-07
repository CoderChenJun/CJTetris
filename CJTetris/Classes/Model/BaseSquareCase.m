//
//  BaseSquareCase.m
//  CJTetris
//
//  Created by CoderChenJun on 2018/3/6.
//  Copyright © 2018年 CoderDream. All rights reserved.
//

#import "BaseSquareCase.h"
#import "RootViewController.h"


@implementation BaseSquareCase

@synthesize case1, case2,case3,case4;


//1.squareMoveDown方法回调
- (void)squareMoveDown;
{
    
    //1.1设置按钮状态.原来的按钮还是显示,触屏后到移动点之间的方块(过程)则隐藏,此时传值到上面方法的点是触屏点
    [self setButtonState:YES];
    
    //1.2根据所传参数判断是否越界.只要四个小方块下边任意一个位置属于越界,那么判定为越界
    if ([self beyondBoundsX:case1.x Y:case1.y+1]
        || [self beyondBoundsX:case2.x Y:case2.y+1]
        || [self beyondBoundsX:case3.x Y:case3.y+1]
        || [self beyondBoundsX:case4.x Y:case4.y+1]) {
        
        //判断后显示原来的按钮,不然原来的按钮也隐藏.(越界后的按钮无法显示)
        [self setButtonState:NO];
        
        //否则第一块落下以后没有方块从上落下,回调
        if ([self.delegate respondsToSelector:@selector(squareDownToEnd)]) {
            [self.delegate squareDownToEnd];
        }
        return;
        
    }
    
    //else,如果没有越界,则自加下移
    ++case1.y;
    ++case2.y;
    ++case3.y;
    ++case4.y;
    
    //显示下移自加后重新创建的按钮,此时传值到上面方法的点是自加后的点
    [self setButtonState:NO];
    return;
    
}

//右移
-(void)squareMoveRight
{
    
    //原来的按钮还是显示,触屏后到移动点之间的方块(过程)则隐藏,此时传值到上面方法的点是触屏点
    [self setButtonState:YES];
    
    //判断有无越界,只要四个小方块右边任意一个位置属于越界,那么判定为越界
    if ([self beyondBoundsX:case1.x+1 Y:case1.y]
        || [self beyondBoundsX:case2.x+1 Y:case2.y]
        || [self beyondBoundsX:case3.x+1 Y:case3.y]
        || [self beyondBoundsX:case4.x+1 Y:case4.y]) {
        
        //判断后显示原来的按钮,不然原来的按钮也隐藏.(越界后的按钮无法显示)
        [self setButtonState:NO];
        return;
        
    }
    
    //else,如果没有越界,则自加右移
    ++case1.x;
    ++case2.x;
    ++case3.x;
    ++case4.x;
    
    //显示右移自加后重新创建的按钮,此时传值到上面方法的点是自加后的点
    [self setButtonState:NO];
    return;
    
}

//左移
-(void)squareMoveLeft
{
    
    //原来的按钮还是显示,触屏后到移动点之间的方块(过程)则隐藏,此时传值到上面方法的点是触屏点
    [self setButtonState:YES];
    
    //判断有无越界,只要四个小方块左边任意一个位置属于越界,那么判定为越界
    if ([self beyondBoundsX:case1.x-1 Y:case1.y]
        || [self beyondBoundsX:case2.x-1 Y:case2.y]
        || [self beyondBoundsX:case3.x-1 Y:case3.y]
        || [self beyondBoundsX:case4.x-1 Y:case4.y]) {
        
        //判断后显示原来的按钮,不然原来的按钮也隐藏.(越界后的按钮无法显示)
        [self setButtonState:NO];
        return;
        
    }
    
    //else,如果没有越界,则自减左移
    --case1.x;
    --case2.x;
    --case3.x;
    --case4.x;
    
    //显示左移自减后重新创建的按钮,此时传值到上面方法的点是自减后的点
    [self setButtonState:NO];
    return;
    
}







//1.1设置按钮状态
-(void)setButtonState:(BOOL)states
{
    //1.1.1根据所传参数设置按钮状态,分别设置四个方块按钮是否显示
    [self setButtonTag:case1.x + case1.y * 10 + 100 states:states];
    [self setButtonTag:case2.x + case2.y * 10 + 100 states:states];
    [self setButtonTag:case3.x + case3.y * 10 + 100 states:states];
    [self setButtonTag:case4.x + case4.y * 10 + 100 states:states];
    
}

//1.1.1根据所传参数设置按钮状态,
-(void)setButtonTag:(NSInteger)tag states:(BOOL)states
{
    RootViewController * rvc = [RootViewController sharedRootViewController];
    UIButton * button = (UIButton *)[rvc.view viewWithTag:tag];
    
    //根据下面的方法-(void)setButtonState:(BOOL)states来设置显示状态.tag是返回视图的特定的标签,就是根据tag获取view.比如在view里添加了一个button,然后设置他的tag为101,然后(UIButton *)[当前view viewWithTag:101]就可以去到添加的button
    if (button) {
        button.hidden = states;
        button.backgroundColor = self.caseColor;// 游戏区方块的颜色
    }
}











//1.2根据所传参数判断是否越界.整个游戏界面布局为x=10,y=20(指单位,不指具体长度),按钮刚刚下落时只有左上方一条边,0=<x<10,0=<y=<20(按钮往下落,所以可以取到20).![self getButtonShowStateX:x Y:y]==如果创建了按钮,隐藏后再取反,返回no,如果没有创建,则最后返回yes.返回yes的条件是：没有创建按钮==在上面的方法-(BOOL)getButtonShowStateX:(NSInteger)x Y:(NSInteger)y中,按钮就已经越界.
-(BOOL)beyondBoundsX:(NSInteger)x Y:(NSInteger)y
{
    
    //1.2.1根据所传参数设置按钮显示状态：显示or隐藏.隐藏取反为NO,只要满足一个条件
    if (x < 0 || x >= 10 || y > 20 || ![self getButtonShowStateX:x Y:y]) {
        return YES;
    }
    else
        return NO;
    
}

//1.2.1根据所传参数设置按钮显示状态：显示or隐藏
-(BOOL)getButtonShowStateX:(NSInteger)x Y:(NSInteger)y
{
    RootViewController * rvc = [RootViewController sharedRootViewController];
    
#pragma mark - 保证方块从最顶部开始出现
    if (y < 0) {
        return YES;
    }
    
    //以tag获得view并添加button,可以把*10+100看做是标签,根据坐标值x和y来获取button
    UIButton * button = (UIButton *)[rvc.view viewWithTag:x + y * 10 + 100];
    
    //只要创建了按钮,就隐藏
    if (button) {
        return button.hidden;
    } else {
        //如果 YES,最底下一行消失
        return NO;
    }
}









//形状变换
- (void)squareRound
{
    
}

// 开始出现时的随机横向位置
- (void)randomPosition:(NSInteger)positionX
{
    NSLog(@"随机位置 %d", positionX);
    for (NSInteger i = 0; i < positionX; i++) {
        [self squareMoveRight];
    }
}


@end

