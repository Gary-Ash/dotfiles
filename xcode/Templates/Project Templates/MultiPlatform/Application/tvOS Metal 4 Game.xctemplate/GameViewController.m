___FILEHEADER___

#import "GameViewController.h"
#import "Renderer.h"

@implementation GameViewController
{
    MTKView *_view;

    Renderer *_renderer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _view = (MTKView *)self.view;

    _view.device = MTLCreateSystemDefaultDevice();
    _view.backgroundColor = UIColor.blackColor;

#if TARGET_OS_SIMULATOR
    
    NSLog(@"Metal 4 is not supported on the simulator");
    self.view = [[UIView alloc] initWithFrame:self.view.frame];
    
#else
    
    if(!_view.device || ![_view.device supportsFamily:MTLGPUFamilyMetal4])
    {
        NSLog(@"Metal 4 is not supported on this device");
        self.view = [[UIView alloc] initWithFrame:self.view.frame];
        return;
    }

    _renderer = [[Renderer alloc] initWithMetalKitView:_view];

    [_renderer mtkView:_view drawableSizeWillChange:_view.drawableSize];

    _view.delegate = _renderer;
    
#endif
}

@end
