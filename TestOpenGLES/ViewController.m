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

/////////////////////////////////////////////////////////////////
// Constants
static const GLfloat  SceneEarthAxialTiltDeg = 23.5f;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.modelviewMatrixStack = GLKMatrixStackCreate(kCFAllocatorDefault);

    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View controller's view is not a GLKView");
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    
    glGenBuffers(1, &vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(sphereVerts), sphereVerts, GL_STATIC_DRAW);
    
    glGenBuffers(1, &earthTextureBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, earthTextureBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(sphereTexCoords), sphereTexCoords, GL_STATIC_DRAW);
    
    glGenBuffers(1, &earthNormalBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, earthNormalBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(sphereNormals), sphereNormals, GL_STATIC_DRAW);
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
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
    
    // Set a reasonable initial projection
    self.baseEffect.transform.projectionMatrix =
       GLKMatrix4MakeOrtho(
       -1.0 * 4.0 / 3.0,
       1.0 * 4.0 / 3.0,
       -1.0,
       1.0,
       1.0,
       120.0);
    

    // Position scene with Earth near center of viewing volume
    self.baseEffect.transform.modelviewMatrix =
       GLKMatrix4MakeTranslation(0.0f, 0.0f, -5.0);
    
    // Initialize the matrix stack
    GLKMatrixStackLoadMatrix4(
       self.modelviewMatrixStack,
       self.baseEffect.transform.modelviewMatrix);

}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    //arg4 用于区分颜色， 0 Blue, 1 Green, 2 Purple, 3 Orange, 4 Red
    kdebug_signpost_start(10, 0, 0, 0, 1);
    
    // Update the angles every frame to animate
    // (one day every 60 display updates)
    self.earthRotationAngleDegrees += 360.0f / 60.0f;
    
    [self.baseEffect prepareToDraw];
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GL_FLOAT)*3, NULL+0);
    
    glBindBuffer(GL_ARRAY_BUFFER, earthTextureBufferID);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*2, NULL+0);
    
    glBindBuffer(GL_ARRAY_BUFFER, earthNormalBufferID);
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*3, NULL+0);
    
    [self drawEarth];
    
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
// Draw the Earth
- (void)drawEarth
{
   self.baseEffect.texture2d0.name = earthTextureInfo.name;
   self.baseEffect.texture2d0.target = earthTextureInfo.target;
      
   GLKMatrixStackPush(self.modelviewMatrixStack);
   
      GLKMatrixStackRotate(   // Rotate (tilt Earth's axis)
         self.modelviewMatrixStack,
         GLKMathDegreesToRadians(SceneEarthAxialTiltDeg),
         0.0, 0.0, 1.0);
      GLKMatrixStackRotate(   // Rotate about Earth's axis
         self.modelviewMatrixStack,
         GLKMathDegreesToRadians(self.earthRotationAngleDegrees),
         0.0, 1.0, 0.0);
      
      self.baseEffect.transform.modelviewMatrix =
         GLKMatrixStackGetMatrix4(self.modelviewMatrixStack);
    
      [self.baseEffect prepareToDraw];

      // Draw triangles using vertices in the prepared vertex
      // buffers
      glDrawArrays(GL_TRIANGLES, 0, sphereNumVerts);
         
   GLKMatrixStackPop(self.modelviewMatrixStack);
   
   self.baseEffect.transform.modelviewMatrix =
         GLKMatrixStackGetMatrix4(self.modelviewMatrixStack);
}
@end
