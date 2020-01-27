//
//  ViewController.m
//  TestOpenGLES
//
//  Created by app-01 on 2019/12/20.
//  Copyright © 2019 Beta Technology. All rights reserved.
//

#import "ViewController.h"
#import <sys/kdebug_signpost.h>
#import "SceneRinkModel.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View controller's view is not a GLKView");
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    
    glGenBuffers(1, &vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    
    self.rinkModel = [[SceneRinkModel alloc] init];
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glEnable(GL_DEPTH_TEST);
    
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.diffuseColor = GLKVector4Make(//漫反射
       1.0f, // Red
       1.0f, // Green
       1.0f, // Blue
       1.0f);// Alpha
    self.baseEffect.light0.position = GLKVector4Make(
       1.0f,
       0.0f,
       0.8f,
       0.0f);
    self.baseEffect.light0.ambientColor = GLKVector4Make(//环境光
       0.2f, // Red
       0.2f, // Green
       0.2f, // Blue
       1.0f);// Alpha
    
    
    

}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    //arg4 用于区分颜色， 0 Blue, 1 Green, 2 Purple, 3 Orange, 4 Red
    kdebug_signpost_start(10, 0, 0, 0, 1);
    
    [self.baseEffect prepareToDraw];

    
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    [self.rinkModel draw];
    
    kdebug_signpost_end(10, 0, 0, 0, 1);

//    #ifdef DEBUG
       {  // Report any errors
          GLenum error = glGetError();
          if(GL_NO_ERROR != error)
          {
             NSLog(@"GL Erroraa: 0x%x", error);
          }
       }
//    #endif
}

//MARK: actions
/////////////////////////////////////////////////////////////////
// This method is called by a user interface object configured
// in Interface Builder and updates the value of a global
// variable that a texture coordinate system scale factor.
- (IBAction)takeTextureScaleFactorFrom:(UISlider *)aControl
{
}


/////////////////////////////////////////////////////////////////
// This method is called by a user interface object configured
// in Interface Builder and updates the value of a global
// variable that a texture coordinate system rotation angle.
- (IBAction)takeTextureAngleFrom:(UISlider *)aControl
{

}
//MARK: private methods



@end
