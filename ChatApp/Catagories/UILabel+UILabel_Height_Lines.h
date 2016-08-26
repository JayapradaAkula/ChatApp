//
//  UILabel+UILabel_Height_Lines.h
//  iBelong
//
//  Created by Jayaprada on 10/06/16.
//  Copyright © 2016 Jayaprada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (UILabel_Height_Lines)

+ (CGFloat)heightForText:(NSString*)text font:(UIFont*)font withinWidth:(CGFloat)width;
+ (int)numberOfLines:(NSString*)text font:(UIFont*)font withinWidth:(CGFloat)width;

@end
