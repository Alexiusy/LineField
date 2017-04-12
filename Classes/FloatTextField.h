//
//  FloatTextField.h
//  FloatTextField
//
//  Created by Zeacone on 16/9/27.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface FloatTextField : UITextField

/**
 *  浮动标签的字体
 */
@property (nonatomic, strong) IBInspectable UIFont *floatFont;

/**
 *  浮动标签正常情况下的文字颜色，即处于非编辑状态下的颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *floatNormalColor;

/**
 *  浮动标签在firstResponder情况下的文字颜色，即正在编辑状态下的颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *floatFocusColor;

/**
 *  边框下划线的颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *bottomLineColor;



/**
 *  标签上浮或者隐藏的时间
 */
@property (nonatomic, assign) IBInspectable NSTimeInterval floatingDuration;

/**
 *  textfield文字滑动的速度，值越大，滑动速度越慢，默认为10
 */
@property (nonatomic, assign) IBInspectable NSInteger scrollSpeed;

@end
