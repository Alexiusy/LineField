//
//  FloatTextField.m
//  FloatTextField
//
//  Created by Zeacone on 16/9/27.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import "FloatTextField.h"

@interface FloatTextField ()

@property (nonatomic, strong) UILabel *floatLabel;

@end

@implementation FloatTextField

#pragma mark - default initialize methods
- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self defaultAppearance];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self defaultAppearance];
    }
    return self;
}

#pragma mark - overrides default placeholder setter
- (void)setPlaceholder:(NSString *)placeholder {
    if (placeholder) {
        self.floatLabel.text = placeholder;
    } else {
        [super setPlaceholder:placeholder];
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    // 初始化float label位置
    [self floating:self.text.length != 0 Focus:NO Initialize:YES];
}

- (void)defaultAppearance {
    
    self.borderStyle = UITextBorderStyleNone;
    // Keep the text on the bottom
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    self.floatLabel = [UILabel new];
    self.floatLabel.font = self.floatFont;
    self.floatLabel.text = self.placeholder;
    [self addSubview:self.floatLabel];
    
    self.placeholder = nil;
    
    // 初始化float label位置
    [self floating:self.text.length != 0 Focus:NO Initialize:YES];
    
    [self addPanGestureForScroll];
    [self addNotification];
}

- (void)addPanGestureForScroll {
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(scrollCursor:)];
    [self addGestureRecognizer:pan];
    
    self.selectedTextRange = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.beginningOfDocument];
}

#pragma mark - Move the cursor
- (void)scrollCursor:(UIPanGestureRecognizer *)pan {
    
    static NSInteger call_count = 0;
    call_count++;
    
    [self becomeFirstResponder];
    UITextRange *selectedRange = self.selectedTextRange;
    
    UITextPosition *newPosition;
    CGPoint translation = [pan translationInView:pan.view];
    
    // Control speed of text when scrolling.
    if (call_count % 30 == 0) {
        if (translation.x < 0) {
            newPosition = [self positionFromPosition:selectedRange.start inDirection:UITextLayoutDirectionRight offset:1];
        } else {
            newPosition = [self positionFromPosition:selectedRange.start inDirection:UITextLayoutDirectionLeft offset:1];
        }
        self.selectedTextRange = [self textRangeFromPosition:newPosition toPosition:newPosition];
    }
    
    [pan setTranslation:CGPointZero inView:pan.view];
}

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidBeginEditing:)
                                                 name:UITextFieldTextDidBeginEditingNotification
                                               object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidEndEditing:)
                                                 name:UITextFieldTextDidEndEditingNotification
                                               object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self];
}

#pragma mark - notification of textfield action
- (void)textFieldDidBeginEditing:(NSNotification *)notification {
    if (self.focusToFloat) {
        [self floating:YES Focus:YES Initialize:NO];
    } else {
        [self floating:self.text.length != 0 Focus:YES Initialize:NO];
    }
}

- (void)textFieldDidEndEditing:(NSNotification *)notification {
    [self floating:self.text.length != 0 Focus:NO Initialize:NO];
}

- (void)textFieldTextDidChanged:(NSNotification *)notification {
    if (self.focusToFloat) {
        return;
    }
    [self floating:self.text.length != 0 Focus:YES Initialize:NO];
}

#pragma mark - Hidden/Show floating label
- (void)floating:(BOOL)floating Focus:(BOOL)focus Initialize:(BOOL)initialize {
    
    CGSize size = CGSizeMake(self.bounds.size.width, self.floatFont.lineHeight);
    
    [UIView animateWithDuration:initialize ? 0 : .5 animations:^{
        
        self.floatLabel.textColor = focus ? self.floatFocusColor : self.floatNormalColor;
        
        if (floating) {
            self.floatLabel.frame = CGRectMake(0, -size.height/2, size.width, size.height);
        } else {
            self.floatLabel.frame = CGRectMake(0, self.bounds.size.height-size.height, size.width, size.height);
        }
    }];
}

#pragma mark - some default settings
- (UIFont *)floatFont {
    return _floatFont ? _floatFont : [UIFont boldSystemFontOfSize:12];
}

- (UIColor *)floatNormalColor {
    return _floatNormalColor ? _floatNormalColor : [UIColor grayColor];
}

- (UIColor *)floatFocusColor {
    return _floatFocusColor ? _floatFocusColor : [UIColor purpleColor];
}

- (UIColor *)bottomLineColor {
    return _bottomLineColor ? _bottomLineColor : [UIColor greenColor];
}

#pragma mark - Custom draw line
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1);
    
    CGContextSetStrokeColorWithColor(context, self.bottomLineColor.CGColor);
    
    CGPoint aPoints[2];
    aPoints[0] = CGPointMake(0, CGRectGetMaxY(self.bounds));
    aPoints[1] = CGPointMake(CGRectGetWidth(self.bounds), CGRectGetMaxY(self.bounds));
    CGContextAddLines(context, aPoints, 2);
    CGContextDrawPath(context, kCGPathStroke);
    
    [super drawRect:rect];
}

@end
