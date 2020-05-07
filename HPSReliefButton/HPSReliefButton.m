#import "HPSReliefButton.h"
#import "HPSPlainView.h"
#import "NSColor+HEX.h"

@interface HPSReliefButton(){
    BOOL                _isUp;
    BOOL                _userInteractionEnabled;   // to avoid repeating mouse click
    NSTrackingArea      *_trackingArea;
    
    NSString            *_text;
    NSColor             *_normalTextColor;
    NSColor             *_overTextColor;
    NSColor             *_pressedTextColor;
    NSColor             *_disabledTextColor;
    
    NSColor             *_backNormalColor;
    NSColor             *_backOverColor;
    NSColor             *_backPressedColor;
    
    NSImage             *_normalIcon;
    NSImage             *_overIcon;
    
    HPSPlainView        *_backView;
    NSTextField         *_textLabel;
    NSImageView         *_iconView;
}

@end

@implementation HPSReliefButton

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (!self) return nil;
    
    [self _setUp];
    
    return self;
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self _setUp];
    
    return self;
}

- (void)_setUp {
    _userInteractionEnabled = YES;
    self.enabled = YES;
    
    _xPadding = 3;
    _yPadding = 3;
    
    _normalTextColor = NSColor.controlTextColor;
    _overTextColor = NSColor.whiteColor;
    _pressedTextColor = NSColor.whiteColor;
    _disabledTextColor = NSColor.disabledControlTextColor;
    _backNormalColor = NSColor.clearColor;
    
    if(@available(macOS 10.13, *)) {
        _backOverColor = [NSColor colorNamed:@"back_color"];
        _backPressedColor = [NSColor colorNamed:@"back_press_color"];
    } else {
        _backOverColor = [NSColor colorFromHexString:@"636567"];
        _backPressedColor = [NSColor colorFromHexString:@"A2A3A4"];
    }

    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(onThemeModeChanged:)
                                                            name:@"AppleInterfaceThemeChangedNotification"
                                                          object:nil];
    
    [self _setUpViews];
}

- (void)onThemeModeChanged:(NSNotification *)notification{
    if(@available(macOS 10.13, *)) {
        _backOverColor = [NSColor colorNamed:@"back_color"];
        _backPressedColor = [NSColor colorNamed:@"back_press_color"];
    } else {
        _backOverColor = [NSColor colorFromHexString:@"b2b2b2"];
        _backPressedColor = [NSColor colorFromHexString:@"767676"];
    }
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent{
    return YES;
}

- (NSTextField *)createTextLabel:(NSString*)text fontSize:(int)size color:(NSColor*)textColor{
    NSTextField *label = [[NSTextField alloc] init];
    label.drawsBackground = YES;
    label.backgroundColor = [NSColor clearColor];
    
    label.stringValue = text;
    label.textColor = textColor;
    label.editable = NO;
    label.selectable = NO;
    label.bordered = NO;
    
    label.focusRingType = NSFocusRingTypeNone;
    
    [label sizeToFit];
    
    return label;
}

- (void)updateTrackingAreas{
    [super updateTrackingAreas];
    
    [self removeTrackingArea:_trackingArea];
    
    _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                 options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect)
                                                   owner:self
                                                userInfo:nil];
    
    [self addTrackingArea:_trackingArea];
    
    NSPoint mouseLocation = [[self window] mouseLocationOutsideOfEventStream];
    mouseLocation = [self convertPoint: mouseLocation
                              fromView: nil];
    
    if (NSPointInRect(mouseLocation, self.bounds)){
        [self mouseEntered: [NSEvent new]];
    }else{
        [self mouseExited: [NSEvent new]];
    }
}

- (void)_setUpViews {
    _isUp = YES;
    
    _text = @"Button Text";
    
    _backView = [[HPSPlainView alloc] initWithFrame:self.bounds];
    _backView.backgroundColor = _backNormalColor;
    
    _textLabel = [self createTextLabel:_text fontSize:12 color:_normalTextColor];
    
    _normalIcon = [NSImage imageNamed:@"icon_arrow_normal"];
    
    _overIcon = [NSImage imageNamed:@"icon_arrow_over"];
    _iconView = [[NSImageView alloc] init];
    _iconView.imageScaling = NSImageScaleAxesIndependently;
    _iconView.bounds = NSMakeRect(0, 0, _normalIcon.size.width, _normalIcon.size.height);
    
    _iconView.image = _normalIcon;
    
    [self addSubview:_backView];
    [self addSubview:_iconView];
    [self addSubview:_textLabel];
    
    [self arrangeView];
}

- (void)arrangeView {
    [self invalidateIntrinsicContentSize];
    
    self.bounds = NSMakeRect(0, 0, self.intrinsicContentSize.width, self.intrinsicContentSize.height);
    
    CGFloat textSize = round(_textLabel.intrinsicContentSize.height);
    
    _iconView.frame = NSMakeRect(_xPadding,
                                 round((self.bounds.size.height - textSize)/2),
                                 textSize,
                                 textSize);
    
    _textLabel.frame = NSMakeRect(NSMaxX(_iconView.frame),
                                  round((self.bounds.size.height - _textLabel.intrinsicContentSize.height)/2),
                                  _textLabel.intrinsicContentSize.width,
                                  _textLabel.intrinsicContentSize.height);
    _backView.frame = self.bounds;
    
    _backView.cornerRadius = round(NSHeight(self.bounds)/2);
}

- (void)setFrame:(NSRect)frame{
    [super setFrame:frame];
    [self arrangeView];
}

- (CGSize)intrinsicContentSize{
    CGFloat textSize = round(_textLabel.intrinsicContentSize.height);
    
    CGSize size = CGSizeMake(textSize + round(_textLabel.intrinsicContentSize.width) + 2 * _xPadding,
                             round(_textLabel.intrinsicContentSize.height) + 2 * _yPadding);
    return size;
}

- (void)sizeToFit{
    self.frame = NSMakeRect(self.frame.origin.x, self.frame.origin.y, self.intrinsicContentSize.width, self.intrinsicContentSize.height);
}

#pragma mark - property setter

- (void)setNormalTextColor:(NSColor*)color{
    _normalTextColor = color;
    
    _textLabel.textColor = color;
}

#pragma mark - event handling

- (void)mouseEntered:(NSEvent *)theEvent{
    [super mouseEntered:theEvent];
    
    if (!self.enabled) {
        return;
    }
    
    if([NSApp modalWindow] && self.window != [NSApp modalWindow]){
        return ;
    }
    
    if(_isUp){
        _iconView.image = _overIcon;
        _textLabel.textColor = _overTextColor;
        _backView.backgroundColor = _backOverColor;
    }else{
        _iconView.image = _normalIcon;
        _textLabel.textColor = _pressedTextColor;
        _backView.backgroundColor = _backPressedColor;
    }
}

- (void)mouseDragged:(NSEvent *)theEvent{
    if (!self.enabled) {
        return;
    }
    
    NSPoint mouseLocation = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    if(NSPointInRect(mouseLocation, [self bounds])){
        if(_isUp){
            _iconView.image = _overIcon;
            _textLabel.textColor = _overTextColor;
            _backView.backgroundColor = _backOverColor;
        }else{
            _iconView.image = _overIcon;
            _textLabel.textColor = _pressedTextColor;
            _backView.backgroundColor = _backPressedColor;
        }
    }else{
        if(_isUp){
            _iconView.image = _overIcon;
            _textLabel.textColor = _overTextColor;
            _backView.backgroundColor = _backOverColor;
        }else{
            _iconView.image = _normalIcon;
            _textLabel.textColor = _normalTextColor;
            _backView.backgroundColor = _backNormalColor;
        }
    }
}

- (void)mouseExited:(NSEvent *)theEvent{
    if (!self.enabled) {
        return;
    }
    
    _iconView.image = _normalIcon;
    _textLabel.textColor = _normalTextColor;
    _backView.backgroundColor = _backNormalColor;
}

- (void)mouseDown:(NSEvent *)theEvent{
    if (!self.enabled || !_userInteractionEnabled) {
        return;
    }
    
    _isUp = NO;
    
    [super mouseDown:theEvent];
    
    _textLabel.textColor = _pressedTextColor;
    _backView.backgroundColor = _backPressedColor;
}

- (void)mouseUp:(NSEvent *)theEvent{
    if (!self.enabled || !_userInteractionEnabled) {
        return;
    }
    
    _isUp =YES;
    
    [super mouseUp:theEvent];
    
    NSPoint mouseLocation = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    if(NSPointInRect(mouseLocation, [self bounds])){
        _textLabel.textColor = _overTextColor;
        _backView.backgroundColor = _backOverColor;
        [self _invokeTargetAction];
    }else{
        _textLabel.textColor = _normalTextColor;
        _backView.backgroundColor = _backNormalColor;
    }
}

- (void)_invokeTargetAction {
    if (self.action){
        _userInteractionEnabled = NO;
        
        [NSApp sendAction:self.action to:self.target from:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(200 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            self->_userInteractionEnabled = YES;
        });
    }
}

#pragma mark - state property

- (void)setFont:(NSFont *)font{
    _textLabel.font = font;
    
    [_textLabel sizeToFit];
    [self sizeToFit];
    [self arrangeView];
}

- (void)setXPadding:(int)textXPadding {
    _xPadding = textXPadding;
    [self sizeToFit];
    [self arrangeView];
}

- (void)setYPadding:(int)textYPadding {
    _yPadding = textYPadding;
    [self sizeToFit];
    [self arrangeView];
}

- (void)setText:(NSString *)text{
    _text = text;
    _textLabel.stringValue = text;
    
    [_textLabel sizeToFit];
    
    [self arrangeView];
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    
    if(enabled){
        _textLabel.textColor = _normalTextColor;
    }else{
        _textLabel.textColor = _disabledTextColor;
    }
}

- (void)dealloc{
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
}

@end
