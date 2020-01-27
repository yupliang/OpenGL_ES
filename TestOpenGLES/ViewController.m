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

@synthesize eyePosition;
@synthesize lookAtPosition;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View controller's view is not a GLKView");
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.rinkModel = [[SceneRinkModel alloc] init];
    
    glClearColor(1.0f, 0.0f, 0.0f, 1.0f);
    glEnable(GL_DEPTH_TEST);
    
    // Set initial point of view to reasonable arbitrary values
    // These values make most of the simulated rink visible
    self.eyePosition = GLKVector3Make(10.5, 5.0, 0.0);
    self.lookAtPosition = GLKVector3Make(0.0, 0.5, 0.0);
    
    // Configure a light
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.ambientColor = GLKVector4Make(
       0.6f, // Red
       0.6f, // Green
       0.6f, // Blue
       1.0f);// Alpha
    self.baseEffect.light0.position = GLKVector4Make(
       1.0f,
       0.8f,
       0.4f,
       0.0f);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    //arg4 用于区分颜色， 0 Blue, 1 Green, 2 Purple, 3 Orange, 4 Red
    kdebug_signpost_start(10, 0, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    // Calculate the aspect ratio for the scene and setup a
    // perspective projection
    const GLfloat  aspectRatio =
       (GLfloat)view.drawableWidth / (GLfloat)view.drawableHeight;

    self.baseEffect.transform.projectionMatrix =
       GLKMatrix4MakePerspective(
          GLKMathDegreesToRadians(35.0f),// Standard field of view
          aspectRatio,
          0.1f,   // Don't make near plane too close
          25.0f); // Far is aritrarily far enough to contain scene
    // Set the modelview matrix to match current eye and look-at
    // positions
    self.baseEffect.transform.modelviewMatrix =
       GLKMatrix4MakeLookAt(
          self.eyePosition.x,
          self.eyePosition.y,
          self.eyePosition.z,
          self.lookAtPosition.x,
          self.lookAtPosition.y,
          self.lookAtPosition.z,
          0, 1, 0);
    
    [self.baseEffect prepareToDraw];
    //draw the rink
    [self.rinkModel draw];
    
    kdebug_signpost_end(10, 0, 0, 0, 1);

    #ifdef DEBUG
       {  // Report any errors
          GLenum error = glGetError();
          if(GL_NO_ERROR != error)
          {
             NSLog(@"GL Erroraa: 0x%x", error);
          }
       }
    #endif
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
