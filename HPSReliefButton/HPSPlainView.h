#import <Cocoa/Cocoa.h>

IB_DESIGNABLE

@interface HPSPlainView : NSView

@property (nonatomic) IBInspectable NSColor *backgroundColor;
@property (nonatomic) IBInspectable NSColor *borderColor;

@property (nonatomic) IBInspectable NSUInteger borderWidth;
@property (nonatomic) IBInspectable NSUInteger cornerRadius;

- (instancetype)initWithColor:(NSColor*)color;

@end
