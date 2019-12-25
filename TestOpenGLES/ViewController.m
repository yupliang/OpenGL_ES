//
//  ViewController.m
//  TestOpenGLES
//
//  Created by app-01 on 2019/12/20.
//  Copyright © 2019 Beta Technology. All rights reserved.
//

#import "ViewController.h"

typedef struct {
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
} SceneVertex;

static const SceneVertex vertices[] = {
    {{-0.5f,-0.5f,0.0},{0.0f,0.0f}},
    {{0.5f,-0.5f,0.0},{2.0f,0.0f}},
    {{-0.5f,0.5f,0.0},{0.0f,3.0f}}
};

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View controller's view is not a GLKView");
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    /*
     - (id)initWithAttriStride:(GLSizeptr)aStride
             numberOfVertices:(GLSize)count
                          data:(const GLvoid *)dataPtr
                        usage:(GLenum)usage {
        stride = aStride;
        bufferSizeBytes = stride * count;
        glGenBuffers(1,&glName);//1
        glBindBuffer(GL_ARRAY_BUFFER,self.glName);//2
        glBufferData(GL_ARRAY_BUFFER,
                     bufferSizeBytes,
                     dataPtr,
                     usage);//3
    }*/
    
    glGenBuffers(1, &vertexBufferID);//1
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);//2
    NSLog(@"sizeof float %d", sizeof(float));
    NSLog(@"sizeof vertices %d", sizeof(vertices));
    NSLog(@"sizeof SceneVertex %d", sizeof(SceneVertex));
    NSLog(@"offsetof(SceneVertex, textureCoords) %d", offsetof(SceneVertex, textureCoords));
    NSLog(@"offsetof(SceneVertex, positionCoords) %d", offsetof(SceneVertex, positionCoords));
    NSLog(@"sizeof(vertices)/sizeof(SceneVertex) %d", sizeof(vertices)/sizeof(SceneVertex));
//    NSLog(@"GLKVector3 %d", sizeof(GLKVector3));
//    NSLog(@"GLKVector2 %d", sizeof(GLKVector2));
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);//3
    
    //Setup texture
    CGImageRef imageref = [[UIImage imageNamed:@"Common_Icon_Insightflower.png"] CGImage];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageref options:nil error:NULL];
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
    NSLog(@"textureInfo name %d", textureInfo.name);
}

/*
 - (void)preparetoDrawWithAttrib:(GLuint)index
             numberOfCoordinates:(GLint)count
                    attribOffset:(GLsizeptr)offset
                    shouldEnable:(BOOL)shouldEnable {
     glVertexAttribPointer(index,count,GL_FlOAT,GL_FALSE,stride,NULL+offset);
 }
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [self.baseEffect prepareToDraw];
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);//4
    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(SceneVertex),
                          NULL+offsetof(SceneVertex, positionCoords));//5
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
  glVertexAttribPointer(GLKVertexAttribTexCoord0,2,GL_FLOAT,GL_FALSE,sizeof(SceneVertex),NULL+offsetof(SceneVertex, textureCoords));
    
    glDrawArrays(GL_TRIANGLES, 0, 3);//6
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    
    if (0 != vertexBufferID) {
        glDeleteBuffers(1, &vertexBufferID);//7
        vertexBufferID = 0;
    }
    
    view.context = nil;
    [EAGLContext setCurrentContext:nil];
}

@end
