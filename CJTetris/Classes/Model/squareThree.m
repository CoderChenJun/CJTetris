//
//  squareThree.m
//  yyTetris
//
//  Created by 袁扬 on 16/6/8.
//  Copyright © 2016年 袁扬. All rights reserved.
//

#import "squareThree.h"

@implementation squareThree

- (instancetype)init
{
    self = [super init];
    if (self) {
        case1.x = 0;
        case1.y = 0;
        case2.x = 0;
        case2.y = 1;
        case3.x = 1;
        case3.y = 0;
        case4.x = 1;
        case4.y = 1;
        self.state = 1;
    }
    return self;
}

@end
