//
//  FXScrollTextField.h
//  FXFlatMapView
//
//  Created by Zeacone on 16/9/27.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface FXScrollTextField : UITextField

/**
 *  浮动标签正常情况下的文字颜色，即处于非编辑状态下的颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *floatLabelNormalColor;

/**
 *  浮动标签在firstResponder情况下的文字颜色，即正在编辑状态下的颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *floatLabelFocusColor;

/**
 *  边框下划线的颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *bottomLineColor;

/**
 *  浮动标签的字体
 */
@property (nonatomic, strong) IBInspectable UIFont *floatLabelFont;

/**
 *  标签上浮或者隐藏的时间
 */
@property (nonatomic, assign) NSTimeInterval floatingDuration;

@end
