//
//  ViewController.m
//  TestOpenGLES
//
//  Created by app-01 on 2019/12/20.
//  Copyright © 2019 Beta Technology. All rights reserved.
//

#import "ViewController.h"
#import <sys/kdebug_signpost.h>


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View controller's view is not GLKView");
    
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [EAGLContext setCurrentContext:view.context];
    
    // Create a base effect that provides standard OpenGL ES 2.0
    // shading language programs and set constants to be used for
    // all subsequent rendering
    self.baseEffect = [[GLKBaseEffect alloc] init];

    // Configure a light to simulate the Sun
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.diffuseColor = GLKVector4Make(
       0.7f, // Red
       0.7f, // Green
       0.7f, // Blue
       1.0f);// Alpha
    self.baseEffect.light0.ambientColor = GLKVector4Make(
       0.2f, // Red
       0.2f, // Green
       0.2f, // Blue
       1.0f);// Alpha
    self.baseEffect.light0.position = GLKVector4Make(
       1.0f,
       0.0f,
      -0.8f,
       0.0f);

    // Setup texture
    CGImageRef imageRef = [[UIImage imageNamed:@"Earth512x256.jpg"] CGImage];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:nil error:NULL];
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
    glClearColor(0, 0, 0, 1);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    //arg4 用于区分颜色， 0 Blue, 1 Green, 2 Purple, 3 Orange, 4 Red
    kdebug_signpost_start(10, 0, 0, 0, 1);
    [self.baseEffect prepareToDraw];
    glClear(GL_COLOR_BUFFER_BIT);
    kdebug_signpost_end(10, 0, 0, 0, 1);
    
}

@end
