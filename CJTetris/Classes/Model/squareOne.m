//
//  squareOne.m
//  yyTetris
//
//  Created by 袁扬 on 16/6/8.
//  Copyright © 2016年 袁扬. All rights reserved.
//

#import "squareOne.h"

@implementation squareOne

//初始情况下第一种情况
- (instancetype)init
{
    self = [super init];
    if (self) {
        case1.x = 0;
        case1.y = 0;
        case2.x = 0;
        case2.y = 1;
        case3.x = 1;
        case3.y = 1;
        case4.x = 1;
        case4.y = 2;
        self.state = 1;
    }
    return self;
}

//形状变换
- (void)squareRound
{
    if (self.state == 1) {
        [self setButtonState:YES];
        if ([self beyondBoundsX:case1.x+1 Y:case1.y]
         || [self beyondBoundsX:case4.x+1 Y:case4.y-2]) {
            [self setButtonState:NO];
            return;
        }
        
        //进行旋转，形状变化
        self.state = 2;
        ++case1.x;
        ++case4.x;
        case4.y -= 2;
        [self setButtonState:NO];
        return;
    }
    
    //第二种
    else if (self.state == 2) {
        [self setButtonState:YES];
        
        //在前面移动后的基础上
        if ([self beyondBoundsX:case1.x-1 Y:case1.y]
         || [self beyondBoundsX:case4.x-1 Y:case4.y+2]) {
            [self setButtonState:NO];
            return;
        }
        
        //回复原样
        self.state = 1;
        --case1.x;
        case4.y += 2;
        --case4.x;
        [self setButtonState:NO];
        return;
    }
}

@end

