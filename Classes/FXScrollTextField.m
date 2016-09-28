//
//  FXScrollTextField.m
//  FXFlatMapView
//
//  Created by Zeacone on 16/9/27.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import "FXScrollTextField.h"


@interface FXScrollTextField ()

@property (nonatomic, strong) UILabel *floatLabel;

@end

@implementation FXScrollTextField

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self buildDefaultAppearance];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildDefaultAppearance];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSAssert(NO, @"Don't support this. Please use initWithFrame or storyboard or xib.");
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    self.floatLabel.text = placeholder;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self floatingPlaceHolder];
}

- (void)buildDefaultAppearance {
    
    self.borderStyle = UITextBorderStyleNone;
    
    self.floatLabel = [UILabel new];
    self.floatLabel.font = [UIFont systemFontOfSize:9];
    self.floatLabel.textColor = [UIColor greenColor];
    self.floatLabel.text = self.placeholder;
    self.floatLabel.alpha = 0;
    [self addSubview:self.floatLabel];
    
    self.floatLabel.frame = CGRectMake(0, CGRectGetMidY(self.bounds), CGRectGetWidth(self.bounds), 8);
    
    [self addPanGestureForScroll];
    [self addNotification];
}

- (void)addPanGestureForScroll {
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(scrollCursor:)];
    [self addGestureRecognizer:pan];
    
    self.selectedTextRange = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.beginningOfDocument];
}

#pragma mark - 移动光标
- (void)scrollCursor:(UIPanGestureRecognizer *)pan {
    
    static NSInteger call_count = 0;
    call_count++;
    
    [self becomeFirstResponder];
    UITextRange *selectedRange = self.selectedTextRange;
    
    UITextPosition *newPosition;
    CGPoint translation = [pan translationInView:pan.view];
    
    if (call_count % 3 == 0) {
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
                                             selector:@selector(textFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self];
}

#pragma mark - notification of textfield action
- (void)textFieldDidBeginEditing:(NSNotification *)notification {
    self.floatLabel.textColor = self.floatLabelFocusColor;
}
- (void)textFieldDidEndEditing:(NSNotification *)notification {
    self.floatLabel.textColor = self.floatLabelNormalColor;
}
- (void)textFieldTextDidChange:(NSNotification *)notification {
    [self floatingPlaceHolder];
}

- (void)floatingPlaceHolder {
    CGFloat offset = 0;
    CGFloat alpha = 0;
    
    if (self.text.length == 0) {
        offset = self.floatLabel.frame.origin.y == CGRectGetMidY(self.bounds) ? 0 : CGRectGetMidY(self.bounds);
        alpha = 0;
    } else {
        offset = self.floatLabel.frame.origin.y == 0 ? 0 : -CGRectGetMidY(self.bounds);
        alpha = 1.0;
    }
    
    [UIView animateWithDuration:self.floatingDuration!=0?:0.5 animations:^{
        self.floatLabel.frame = CGRectOffset(self.floatLabel.frame, 0, offset);
        self.floatLabel.alpha = alpha;
    }];
}

#pragma mark - system call
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.frame;
    frame.size.height = 30;
    self.frame = frame;
}

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
