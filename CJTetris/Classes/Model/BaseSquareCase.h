//
//  BaseSquareCase.h
//  CJTetris
//
//  Created by CoderChenJun on 2018/3/6.
//  Copyright © 2018年 CoderDream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


////结构体类型
//typedef struct Square {
//    //四个小按钮的坐标
//    NSInteger x;
//    NSInteger y;
//}Square;

//结构体类型
struct Square{
    //四个小按钮的坐标
    NSInteger x;
    NSInteger y;
};
typedef struct Square Square;// 第一个是定义的名字（上面），第二个是类的名字（下面）




@class BaseSquareCase;
@protocol BaseSquareCaseDelegate <NSObject>
@optional
//方块下落到最底下
- (void)squareDownToEnd;
@end





@interface BaseSquareCase : NSObject
{
    Square case1, case2,case3,case4;
}


@property (nonatomic, weak) id<BaseSquareCaseDelegate> delegate;



@property (nonatomic, assign) NSUInteger state;

@property (nonatomic, assign) Square case1;
@property (nonatomic, assign) Square case2;
@property (nonatomic, assign) Square case3;
@property (nonatomic, assign) Square case4;
@property (nonatomic, strong) UIColor *caseColor;



- (void)squareMoveLeft;
- (void)squareMoveRight;
- (void)squareMoveDown;






//根据所传参数判断是否越界
- (BOOL)beyondBoundsX:(NSInteger)x Y:(NSInteger)y;

//根据所传布尔值设置按钮状态
- (void)setButtonState:(BOOL)state;

//形状变换
- (void)squareRound;



@end




