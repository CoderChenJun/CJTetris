//
//  squareOne.m
//  CJTetris
//
//  Created by CoderChenJun on 2018/3/6.
//  Copyright © 2016年 袁扬. All rights reserved.
//

#import "squareOne.h"

@implementation squareOne

- (void)promptToGame
{
    case1.y -= 2;
    case2.y -= 2;
    case3.y -= 2;
    case4.y -= 2;
}

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

