//
//  CJToolkit.h
//  CJTetris
//
//  Created by CoderChenJun on 2018/3/7.
//  Copyright © 2018年 CoderDream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJToolkit : NSObject

/**
 * 生成随机浮点数
 
 @param num1 最小值，可等于
 @param num2 最大值，可等于
 @return 随机浮点数，保留一位小数
 */
+ (CGFloat)randomFloatBetween:(CGFloat)num1 andLargerFloat:(CGFloat)num2;

/**
 * 生成随机整数
 
 @param num1 最小值，可等于
 @param num2 最大值，可等于
 @return 随机整数
 */
+ (NSInteger)randomIntegerBetween:(NSInteger)num1 andLargerInteger:(NSInteger)num2;

@end
