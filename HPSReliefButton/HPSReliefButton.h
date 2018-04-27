#import <Cocoa/Cocoa.h>

@interface HPSReliefButton : NSControl

@property (nonatomic) IBInspectable NSString *text;

@property (nonatomic) IBInspectable int xPadding;
@property (nonatomic) IBInspectable int yPadding;

@property (nonatomic) NSFont *font;

@end
