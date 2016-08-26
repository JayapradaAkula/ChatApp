//
//  UILabel+UILabel_Height_Lines.m
//  iBelong
//
//  Created by Jayaprada on 10/06/16.
//  Copyright © 2016 Jayaprada. All rights reserved.
//

#import "UILabel+UILabel_Height_Lines.h"

@implementation UILabel (UILabel_Height_Lines)


+ (CGFloat)heightForText:(NSString*)text font:(UIFont*)font withinWidth:(CGFloat)width
{
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    CGFloat area = size.height * size.width;
    CGFloat height = roundf(area / width);
    return ceilf(height / font.lineHeight) * font.lineHeight;
}

+ (int)numberOfLines:(NSString*)text font:(UIFont*)font withinWidth:(CGFloat)width
{
    CGFloat height = [self heightForText:text font:font withinWidth:width];
    return height/12.0f;
}
@end
