#import <Cocoa/Cocoa.h>

@interface NSColor (HEX)

/*
 return color from hex value
 
 @param hex color hex value (e.g., 0xE41B17)
 @return color from specfic hex
 */
+ (NSColor *)colorFromHex:(uint32_t)hex;


/*
 return color from hex string
 @param hexString color hex string (e.g., "0xE41B17")
 @return color from specfic hex string
 */
+ (NSColor *)colorFromHexString:(NSString *)hexString;

@end
