#import "HPSPlainView.h"

@interface HPSPlainView (){
}

@end

@implementation HPSPlainView

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent{
    return YES;
}

- (instancetype)initWithFrame:(NSRect)rect{
    self = [super initWithFrame:rect];
    if(self){
        [self setUp];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if(self){
        [self setUp];
    }
    
    return self;
}

- (void)setUp{
    _cornerRadius =
    _borderWidth = 0;
    _backgroundColor = [NSColor clearColor];
    _borderColor = [NSColor clearColor];
}

- (instancetype)initWithColor:(NSColor*)color{
    self = [super initWithFrame:CGRectZero];
    if(self){
        _backgroundColor = color;
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    NSUInteger outerCornerRadius = _cornerRadius;
    NSUInteger innerCornerRadius = _cornerRadius - _borderWidth;
    
    if(_cornerRadius<_borderWidth){
        innerCornerRadius = 0;
    }
    
    // draw border with empty inner part
    NSRect outterRect = NSMakeRect(0, 0, dirtyRect.size.width, dirtyRect.size.height);
    NSBezierPath *borderPath = [NSBezierPath bezierPath];
    
    [borderPath setWindingRule:NSEvenOddWindingRule];
    
    NSRect innerRect = NSInsetRect(outterRect, _borderWidth, _borderWidth);
    [borderPath appendBezierPathWithRoundedRect:dirtyRect xRadius:outerCornerRadius yRadius:outerCornerRadius];
    [borderPath appendBezierPathWithRoundedRect:innerRect xRadius:innerCornerRadius yRadius:innerCornerRadius];
    
    [_borderColor setFill];
    [borderPath fill];
    
    // fill inner part
    NSBezierPath* innterPath = [NSBezierPath bezierPathWithRoundedRect:innerRect xRadius:innerCornerRadius yRadius:innerCornerRadius];
    
    [_backgroundColor setFill];
    [innterPath fill];
}

#pragma mark - Getter and Setter

- (void)setBackgroundColor:(NSColor*)color{
    _backgroundColor = color;
    self.needsDisplay = YES;
}

- (void)setBorderColor:(NSColor*)color{
    _borderColor = color;
    self.needsDisplay = YES;
}

- (void)setBorderWidth:(NSUInteger)width{
    _borderWidth = width;
    self.needsDisplay = YES;
}

- (void)setCornerRadius:(NSUInteger)radius{
    _cornerRadius = radius;
    self.needsDisplay = YES;
}

- (void)dealloc{
}

@end
