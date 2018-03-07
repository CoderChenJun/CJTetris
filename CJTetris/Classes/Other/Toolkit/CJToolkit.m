//
//  CJToolkit.m
//  CJTetris
//
//  Created by CoderChenJun on 2018/3/7.
//  Copyright © 2018年 CoderDream. All rights reserved.
//

#import "CJToolkit.h"

@implementation CJToolkit


/**
 * 生成随机浮点数
 
 @param num1 最小值，可等于
 @param num2 最大值，可等于
 @return 随机浮点数，保留一位小数
 */
+ (CGFloat)randomFloatBetween:(CGFloat)num1 andLargerFloat:(CGFloat)num2
{
    NSInteger startVal = num1*10000;
    NSInteger endVal   = num2*10000;
    
    NSInteger randomValue = startVal +(arc4random()%(endVal - startVal));
    CGFloat a = randomValue;
    
    return(a /10000.0);
}

/**
 * 生成随机整数
 
 @param num1 最小值，可等于
 @param num2 最大值，可等于
 @return 随机整数
 */
+ (NSInteger)randomIntegerBetween:(NSInteger)num1 andLargerInteger:(NSInteger)num2
{
    NSInteger startVal = num1;
    NSInteger endVal   = num2;
    
    NSInteger randomValue = startVal +(arc4random()%(endVal - startVal));
    
    return randomValue;
}


@end


