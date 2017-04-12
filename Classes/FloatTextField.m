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
    
    [self floating:self.text.length != 0 Focus:NO];
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
    
    [self floating:self.text.length != 0 Focus:NO];

    
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
    if (call_count % (self.scrollSpeed==0?10:self.scrollSpeed) == 0) {
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
    [self floating:self.text.length != 0 Focus:YES];
}

- (void)textFieldDidEndEditing:(NSNotification *)notification {
    [self floating:self.text.length != 0 Focus:NO];
}

- (void)textFieldTextDidChanged:(NSNotification *)notification {
    [self floating:self.text.length != 0 Focus:YES];
}

#pragma mark - Hidden/Show floating label
- (void)floating:(BOOL)floating Focus:(BOOL)focus {
    
    CGSize size = [self.floatLabel sizeThatFits:self.bounds.size];
    
    [UIView animateWithDuration:self.floatingDuration animations:^{
        
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
    if (!_floatFont) {
        _floatFont = [UIFont boldSystemFontOfSize:12];
    }
    return _floatFont;
}

- (UIColor *)floatNormalColor {
    if (!_floatNormalColor) {
        _floatNormalColor = [UIColor purpleColor];
    }
    return _floatNormalColor;
}

- (UIColor *)floatFocusColor {
    if (!_floatFocusColor) {
        _floatFocusColor = [UIColor greenColor];
    }
    return _floatFocusColor;
}

- (NSTimeInterval)floatingDuration {
    if (_floatingDuration == 0) {
        _floatingDuration = 0.5;
    }
    return _floatingDuration;
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
