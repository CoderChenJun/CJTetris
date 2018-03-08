//
//  UIFont+FontAwesome.m
//
//  Created by CoderChenJun on 2017/7/5.
//  Copyright © 2017年 zwu. All rights reserved.
//

#import "UIFont+FontAwesome.h"
#import "NSString+FontAwesome.h"

@implementation UIFont (FontAwesome)

#pragma mark - Public API
+ (UIFont*)fontAwesomeFontOfSize:(CGFloat)size {
	UIFont *font = [UIFont fontWithName:kFontAwesomeFamilyName size:size];
    NSAssert(font!=nil, @"%@ couldn't be loaded",kFontAwesomeFamilyName);
    return font;
}

@end
