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

- (IBAction)button1Action:(id)sender{
    NSLog(@"button 1 clicked!");
}

- (IBAction)button2Action:(id)sender{
    NSLog(@"button 2 clicked!");
}

@end
