#import "NSColor+HEX.h"

@implementation NSColor (HEX)

+ (NSColor *)colorFromHex:(uint32_t)color {
    uint8_t rmd = 0xFF;
    uint8_t mask = 0xFF;
    
    uint8_t step = 8;
    uint8_t length = 3;
    CGFloat r, g, b;
    r = g = b = 0;
    for (int i = 0; i < length; i++) {
        NSUInteger offSet = step * i;
        CGFloat percent = (color >> offSet & mask) / (double)rmd;
        switch (i) {
            case 0: {
                b = percent;
                break;
            }
            case 1: {
                g = percent;
                break;
            }
            case 2: {
                r = percent;
            }
        }
    }
    
    return [NSColor colorWithRed:r green:g blue:b alpha:1.0];
}

+ (NSColor *)colorFromHexString:(NSString *)hexString {
    unsigned int colorHex = 0;
    
    [[NSScanner scannerWithString:hexString] scanHexInt:&colorHex];
    
    return [NSColor colorFromHex:colorHex];
}

@end
