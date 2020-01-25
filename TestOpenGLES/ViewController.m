//
//  ViewController.m
//  TestOpenGLES
//
//  Created by app-01 on 2019/12/20.
//  Copyright © 2019 Beta Technology. All rights reserved.
//

#import "ViewController.h"
#import <sys/kdebug_signpost.h>
#import "sphere.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textureMatrixStack = GLKMatrixStackCreate(kCFAllocatorDefault);

    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View controller's view is not a GLKView");
    
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    
    glGenBuffers(1, &vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(sphereVerts), sphereVerts, GL_STATIC_DRAW);
    
    glGenBuffers(1, &earthTextureBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, earthTextureBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(sphereTexCoords), sphereTexCoords, GL_STATIC_DRAW);
    
    glClearColor(1.0f, 0.0f, 0.0f, 1.0f);
    
    // Setup Earth texture
    CGImageRef earthImageRef =
       [[UIImage imageNamed:@"Earth512x256.jpg"] CGImage];
       
    earthTextureInfo = [GLKTextureLoader
       textureWithCGImage:earthImageRef
       options:[NSDictionary dictionaryWithObjectsAndKeys:
          [NSNumber numberWithBool:YES],
          GLKTextureLoaderOriginBottomLeft, nil]
       error:NULL];
    self.baseEffect.texture2d0.enabled = true;
    self.baseEffect.texture2d0.target = earthTextureInfo.target;
    self.baseEffect.texture2d0.name = earthTextureInfo.name;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    //arg4 用于区分颜色， 0 Blue, 1 Green, 2 Purple, 3 Orange, 4 Red
    kdebug_signpost_start(10, 0, 0, 0, 1);
    [self.baseEffect prepareToDraw];
    glClear(GL_COLOR_BUFFER_BIT);
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GL_FLOAT)*3, NULL+0);
    
    glBindBuffer(GL_ARRAY_BUFFER, earthTextureBufferID);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*2, NULL+0);
    
    glDrawArrays(GL_TRIANGLES, 0, sphereNumVerts);
    
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
@end
