//
//  FXTextField.m
//  FXTextField
//
//  Created by Zeacone on 16/9/27.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import "FXTextField.h"

@interface FXTextField ()

@property (nonatomic, strong) UILabel *floatLabel;

@end

@implementation FXTextField

#pragma mark - default initialize methods
- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self buildDefaultAppearance];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildDefaultAppearance];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self buildDefaultAppearance];
    }
    return self;
}

#pragma mark - overrides default placeholder setter
- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    self.floatLabel.text = placeholder;
}

- (void)buildDefaultAppearance {
    
    self.borderStyle = UITextBorderStyleNone;
    // Keep the text on the bottom
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    self.floatLabel = [UILabel new];
    self.floatLabel.font = self.floatLabelFont ? :[UIFont systemFontOfSize:12];
    self.floatLabel.textColor = [UIColor greenColor];
    self.floatLabel.text = self.placeholder;
    self.floatLabel.alpha = 0;
    [self addSubview:self.floatLabel];
    
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
                                             selector:@selector(textFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self];
}

#pragma mark - notification of textfield action
- (void)textFieldDidBeginEditing:(NSNotification *)notification {
    self.floatLabel.textColor = self.floatLabelFocusColor?:[UIColor colorWithRed:0.000 green:0.502 blue:0.251 alpha:1.000];
}
- (void)textFieldDidEndEditing:(NSNotification *)notification {
    self.floatLabel.textColor = self.floatLabelNormalColor?:[UIColor lightGrayColor];
}
- (void)textFieldTextDidChange:(NSNotification *)notification {
    
}

#pragma mark - Hidden/Show floating label
- (void)floatingPlaceHolder {
    
    CGSize size = [self.floatLabel sizeThatFits:self.bounds.size];
    
    [UIView animateWithDuration:self.floatingDuration!=0?:0.5 animations:^{
        
        if (self.text.length == 0 && self.floatLabel.frame.origin.y != CGRectGetMidY(self.bounds)) {
            self.floatLabel.frame = CGRectMake(0, CGRectGetMidY(self.bounds), size.width, size.height);
            self.floatLabel.alpha = 0;
        } else if (self.text.length != 0 || self.floatLabel.frame.origin.y != 0) {
            
            if (!self.isFirstResponder) {
                self.floatLabel.textColor = self.floatLabelNormalColor;
            }
            self.floatLabel.frame = CGRectMake(0, 0, size.width, size.height);
            self.floatLabel.alpha = 1.0;
        }
    }];
}

#pragma mark - system call
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self floatingPlaceHolder];
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
