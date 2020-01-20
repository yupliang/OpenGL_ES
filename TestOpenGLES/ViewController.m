//
//  ViewController.m
//  TestOpenGLES
//
//  Created by app-01 on 2019/12/20.
//  Copyright © 2019 Beta Technology. All rights reserved.
//

#import "ViewController.h"
#import <sys/kdebug_signpost.h>
#import "AGLKContext.h"
#import "AGLKTextureTransformBaseEffect.h"

@implementation ViewController

@synthesize textureScaleFactor;
@synthesize textureAngle;

/////////////////////////////////////////////////////////////////
// This data type is used to store information for each vertex
typedef struct {
   GLKVector3  positionCoords;
   GLKVector2  textureCoords;
}
SceneVertex;


/////////////////////////////////////////////////////////////////
// Define vertex data for triangles to use in example
static const SceneVertex vertices[] =
{
   {{-1.0f, -0.67f, 0.0f}, {0.0f, 0.0f}},  // first triangle
   {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},
   {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
   {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},  // second triangle
   {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
   {{ 1.0f,  0.67f, 0.0f}, {1.0f, 1.0f}},
};


- (void)viewDidLoad {
    [super viewDidLoad];
    textureScaleFactor = 1.5f;
    textureAngle = 90.0f;
    self.textureMatrixStack = GLKMatrixStackCreate(kCFAllocatorDefault);
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View controller's view is not a GLKView");
    
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    glGenBuffers(1, &vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    self.baseEffect = [[AGLKTextureTransformBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    
    
    // Setup texture0
    CGImageRef imageRef0 =
       [[UIImage imageNamed:@"leaves.gif"] CGImage];
       
    GLKTextureInfo *textureInfo0 = [GLKTextureLoader
       textureWithCGImage:imageRef0
       options:[NSDictionary dictionaryWithObjectsAndKeys:
          [NSNumber numberWithBool:YES],
          GLKTextureLoaderOriginBottomLeft, nil]
       error:NULL];
       
    self.baseEffect.texture2d0.name = textureInfo0.name;
    self.baseEffect.texture2d0.target = textureInfo0.target;
    self.baseEffect.texture2d0.enabled = GL_TRUE;
    
    glClearColor(1.0f, 1.0f, 0.0f, 1.0f);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    //arg4 用于区分颜色， 0 Blue, 1 Green, 2 Purple, 3 Orange, 4 Red
    kdebug_signpost_start(10, 0, 0, 0, 1);
    
    [self.baseEffect prepareToDraw];
    glClear(GL_COLOR_BUFFER_BIT);
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 3*sizeof(GLfloat), NULL+0);
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 2*sizeof(GLfloat), NULL+offsetof(SceneVertex, textureCoords));
    
    GLKMatrixStackPush(self.textureMatrixStack);
     
        // Scale and rotate about the center of the texture
        GLKMatrixStackTranslate(
           self.textureMatrixStack,
           0.5, 0.5, 0.0);
        GLKMatrixStackScale(
           self.textureMatrixStack,
           textureScaleFactor, textureScaleFactor, 1.0);
        GLKMatrixStackRotate(   // Rotate about Z axis
           self.textureMatrixStack,
           GLKMathDegreesToRadians(textureAngle),
           0.0, 0.0, 1.0);
        GLKMatrixStackTranslate(
           self.textureMatrixStack,
           -0.5, -0.5, 0.0);
        
        self.baseEffect.textureMatrix2d0 =
           GLKMatrixStackGetMatrix4(self.textureMatrixStack);
    
    glDrawArrays(GL_TRIANGLES, 0, sizeof(vertices)/sizeof(SceneVertex));
    
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

@end
