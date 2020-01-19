//
//  ViewController.m
//  TestOpenGLES
//
//  Created by app-01 on 2019/12/20.
//  Copyright © 2019 Beta Technology. All rights reserved.
//

#import "ViewController.h"
#import <sys/kdebug_signpost.h>
#import "lowPolyAxesAndModels2.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View controller's view is not a GLKView");
    
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    glClearColor(0.5f, 0.0f, 0.0f, 1.0f);
    
    glGenBuffers(1, &vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(lowPolyAxesAndModels2Verts), lowPolyAxesAndModels2Verts, GL_STATIC_DRAW);
    
    glGenBuffers(1, &normalBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, normalBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(lowPolyAxesAndModels2Normals), lowPolyAxesAndModels2Normals, GL_STATIC_DRAW);
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    
    GLKMatrix4 modelviewMatrix = GLKMatrix4MakeRotation(
       GLKMathDegreesToRadians(30.0f),
       1.0,  // Rotate about X axis
       0.0,
       0.0);
    modelviewMatrix = GLKMatrix4Rotate(
       modelviewMatrix,
       GLKMathDegreesToRadians(-30.0f),
       0.0,
       1.0,  // Rotate about Y axis
       0.0);
    modelviewMatrix = GLKMatrix4Translate(
       modelviewMatrix,
       -0.25,
       0.0,
       -0.20);
       
    self.baseEffect.transform.modelviewMatrix = modelviewMatrix;
    // Configure a light to simulate the Sun
     self.baseEffect.light0.enabled = GL_TRUE;
     self.baseEffect.light0.ambientColor = GLKVector4Make(
        0.4f, // Red
        0.4f, // Green
        0.4f, // Blue
        1.0f);// Alpha
     self.baseEffect.light0.position = GLKVector4Make(
        1.0f,
        0.8f,
        0.4f,
        0.0f);
    glEnable(GL_DEPTH_TEST);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    //arg4 用于区分颜色， 0 Blue, 1 Green, 2 Purple, 3 Orange, 4 Red
    kdebug_signpost_start(10, 0, 0, 0, 1);
    [self.baseEffect prepareToDraw];
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 3*sizeof(GLfloat), NULL+0);
    
    glBindBuffer(GL_ARRAY_BUFFER, normalBufferID);
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 3*sizeof(GLfloat), NULL+0);
    
    const GLfloat  aspectRatio =
       (GLfloat)view.drawableWidth / (GLfloat)view.drawableHeight;
       
    self.baseEffect.transform.projectionMatrix =
       GLKMatrix4MakeOrtho(
          -0.5 * aspectRatio,
          0.5 * aspectRatio,
          -0.5,
          0.5,
          -5.0,
          5.0);
    
    glDrawArrays(GL_TRIANGLES, 0, lowPolyAxesAndModels2NumVerts);
    
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

//MARK: Actions


@end
