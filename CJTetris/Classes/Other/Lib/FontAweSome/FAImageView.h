//
//  FAImageView.h
//
//  Created by CoderChenJun on 2017/7/5.
//  Copyright © 2017年 zwu. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "NSString+FontAwesome.h"

@interface FAImageView : UIImageView

/* The background color for the default view displayed when the image is missing */
@property (nonatomic, strong) UIColor *defaultIconColor UI_APPEARANCE_SELECTOR;

/* Set the icon using the fontawesome icon's identifier */
@property (nonatomic, strong) NSString *defaultIconIdentifier;

/* Set the icon using the icon enumerations */
@property (nonatomic, assign) FAIcon defaultIcon;

/* The view that is displayed when the image is set to nil */
@property (nonatomic, strong) UILabel *defaultView;

@end
