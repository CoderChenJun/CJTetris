//
//  squareTwo.m
//  yyTetris
//
//  Created by 袁扬 on 16/6/8.
//  Copyright © 2016年 袁扬. All rights reserved.
//

#import "squareTwo.h"

@implementation squareTwo

- (instancetype)init
{
    self = [super init];
    if (self) {
        case1.x = 1;
        case1.y = 0;
        case2.x = 1;
        case2.y = 1;
        case3.x = 0;
        case3.y = 1;
        case4.x = 0;
        case4.y = 2;
        self.state = 1;
    }
    return self;
}

-(void)squareRound
{
    if (self.state == 1) {
        [self setButtonState:YES];
        if ([self beyondBoundsX:case1.x+1 Y:case1.y+2]
         || [self beyondBoundsX:case4.x+1 Y:case4.y]) {
            [self setButtonState:NO];
            return;
        }
        self.state = 2;
        ++case1.x;
        case1.y += 2;
        ++case4.x;
        [self setButtonState:NO];
        return;
    } else if (self.state == 2) {
        [self setButtonState:YES];
        if ([self beyondBoundsX:case1.x-1 Y:case1.y-2]
         || [self beyondBoundsX:case4.x-1 Y:case4.y]) {
            [self setButtonState:NO];
            return;
        }
        self.state = 1;
        --case1.x;
        case1.y -= 2;
        --case4.x;
        [self setButtonState:NO];
        return;
    }
}

@end

