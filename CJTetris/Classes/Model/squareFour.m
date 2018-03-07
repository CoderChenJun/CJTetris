//
//  squareFour.m
//  CJTetris
//
//  Created by CoderChenJun on 2018/3/6.
//  Copyright © 2016年 袁扬. All rights reserved.
//

#import "squareFour.h"

@implementation squareFour

- (void)promptToGame
{
    case1.y -= 4;
    case2.y -= 4;
    case3.y -= 4;
    case4.y -= 4;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        case1.x = 0;
        case1.y = 0;
        case2.x = 0;
        case2.y = 1;
        case3.x = 0;
        case3.y = 2;
        case4.x = 0;
        case4.y = 3;
        self.state = 1;
    }
    return self;
}

- (void)squareRound
{
    if (self.state == 1) {
        [self setButtonState:YES];
        if ([self beyondBoundsX:case1.x-1 Y:case1.y+1] ||
            [self beyondBoundsX:case3.x+1 Y:case3.y-1] ||
            [self beyondBoundsX:case4.x+2 Y:case4.y-2]) {
            [self setButtonState:NO];
            return;
        }
        self.state = 2;
        --case1.x;
        ++case1.y;
        case3.x += 1;
        case3.y -= 1;
        case4.x += 2;
        case4.y -= 2;
        [self setButtonState:NO];
        return;
    } else if (self.state == 2) {
        [self setButtonState:YES];
        if ([self beyondBoundsX:case1.x+1 Y:case1.y-1]
         || [self beyondBoundsX:case3.x-1 Y:case3.y+1]
         || [self beyondBoundsX:case4.x-2 Y:case4.y+2]) {
            [self setButtonState:NO];
            return;
        }
        self.state = 1;
        ++case1.x;
        --case1.y;
        case3.x -= 1;
        case3.y += 1;
        case4.x -= 2;
        case4.y += 2;
        [self setButtonState:NO];
        return;
    }
}

@end

