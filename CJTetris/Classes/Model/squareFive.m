//
//  squareFive.m
//  CJTetris
//
//  Created by CoderChenJun on 2018/3/6.
//  Copyright © 2016年 袁扬. All rights reserved.
//

#import "squareFive.h"

@implementation squareFive

- (void)promptToGame
{
    case1.y -= 3;
    case2.y -= 3;
    case3.y -= 3;
    case4.y -= 3;
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
        case4.x = 1;
        case4.y = 2;
        self.state = 1;
    }
    return self;
}

- (void)squareRound
{
    if (self.state == 1) {
        [self setButtonState:YES];
        if ([self beyondBoundsX:case1.x+2 Y:case1.y+1]
         || [self beyondBoundsX:case4.x Y:case4.y-1]) {
            [self setButtonState:NO];
            return;
        }
        self.state = 2;
        case1.x += 2;
        case1.y += 1;
        case4.y -= 1;
        [self setButtonState:NO];
        return;
    } else if (self.state == 2) {
        [self setButtonState:YES];
        if ([self beyondBoundsX:case1.x-1 Y:case1.y-1]
         || [self beyondBoundsX:case2.x   Y:case3.y-1]
         || [self beyondBoundsX:case3.x+1 Y:case3.y]) {
            [self setButtonState:NO];
            return;
        }
        self.state = 3;
        case1.x -= 1;
        case1.y -= 1;
        case2.y -= 1;
        case3.x += 1;
        [self setButtonState:NO];
        return;
    } else if (self.state == 3) {
        [self setButtonState:YES];
        if ([self beyondBoundsX:case1.x+1 Y:case1.y+1]
         || [self beyondBoundsX:case2.x Y:case2.y+2]
         || [self beyondBoundsX:case4.x+1 Y:case4.y+1]) {
            [self setButtonState:NO];
            return;
        }
        self.state = 4;
        case1.x += 1;
        case1.y += 1;
        case2.y += 2;
        case4.x += 1;
        case4.y += 1;
        [self setButtonState:NO];
        return;
    } else if (self.state == 4) {
        [self setButtonState:YES];
        if ([self beyondBoundsX:case1.x-2 Y:case1.y-1]
         || [self beyondBoundsX:case2.x Y:case2.y-1]
         || [self beyondBoundsX:case3.x-1 Y:case3.y]
         || [self beyondBoundsX:case4.x-1 Y:case3.y]) {
            [self setButtonState:NO];
            return;
        }
        self.state = 1;
        case1.x -= 2;
        case1.y -= 1;
        case2.y -= 1;
        case3.x -= 1;
        case4.x -= 1;
        [self setButtonState:NO];
        return;
    }
}

@end
