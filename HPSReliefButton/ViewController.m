#import "ViewController.h"
#import "HPSReliefButton.h"

@interface ViewController(){
    
}

@property (nonatomic, weak) IBOutlet HPSReliefButton *button;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _button.text = @"Button without autolayout";
    
    [_button sizeToFit];
    
    
    _button.font = [NSFont userFontOfSize:40];
    _button.xPadding = 10;
    _button.yPadding = 10;
}

@end
