//
//  UIImage+UIImage_FontAwesome.h
//
//  Created by CoderChenJun on 2017/7/5.
//  Copyright © 2017年 zwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FontAwesome)
/**
 *	This method generates an UIImage with a given FontAwesomeIcon and format parameters
 *
 *	@param	identifier	NSString that identifies the icon
 *	@param	bgColor     UIColor for background image Color
 *	@param	iconColor   UIColor for icon color
 *	@param	size        Size of the image to be generated
 *
 *	@return	Image to be used wherever you want
 */

//*    @param    scale       Scale factor between the image size and the icon size
+(UIImage*)imageWithIcon:(NSString*)identifier backgroundColor:(UIColor*)bgColor iconColor:(UIColor*)iconColor andSize:(CGSize)size;
/**
 *	This method generates an UIImage with a given FontAwesomeIcon and format parameters
 *
 *	@param	identifier	NSString that identifies the icon
 *	@param	bgColor     UIColor for background image Color
 *	@param	iconColor	UIColor for icon color
 *	@param	fontSize	Font size used to be generate the image
 *
 *	@return	Image to be used wherever you want
 */
//*    @param    scale       Scale factor between the image size and the icon size
+(UIImage*)imageWithIcon:(NSString*)identifier backgroundColor:(UIColor*)bgColor iconColor:(UIColor*)iconColor fontSize:(int)fontSize;
@end
