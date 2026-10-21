___FILEHEADER___

#import "___FILEBASENAME___.h"
#import "GameScene.h"

@implementation ___FILEBASENAME___

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load the SKScene from 'GameScene.sks'
    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    
    // Set the scale mode to scale to fit the window
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    SKView *skView = (SKView *)self.view;
    
    // Present the scene
    [skView presentScene:scene];
    
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
}

@end
