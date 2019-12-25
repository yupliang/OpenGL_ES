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
    {{0.5f,-0.5f,0.0},{1.0f,0.0f}},
    {{-0.5f,0.5f,0.0},{0.0f,1.0f}},
    
    {{0.5f,-0.5f,0.0},{1.0f,0.0f}},
    {{-0.5f,0.5f,0.0},{0.0f,1.0f}},
    {{0.5f,0.5f,0.0},{1.0f,1.0f}},
};

@interface ViewController ()
@property (nonatomic,strong) GLKTextureInfo* textureInfo0;
@property (nonatomic,strong) GLKTextureInfo* textureInfo1;
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
    
    glClearColor(1.f, 1.0f, 1.f, 1.0f);
    
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
//    NSLog(@"sizeof SceneVertex %d", sizeof(SceneVertex));
//    NSLog(@"offsetof(SceneVertex, textureCoords) %d", offsetof(SceneVertex, textureCoords));
//    NSLog(@"offsetof(SceneVertex, positionCoords) %d", offsetof(SceneVertex, positionCoords));
//    NSLog(@"sizeof(vertices)/sizeof(SceneVertex) %d", sizeof(vertices)/sizeof(SceneVertex));
//    NSLog(@"GLKVector3 %d", sizeof(GLKVector3));
//    NSLog(@"GLKVector2 %d", sizeof(GLKVector2));
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);//3
    
    //Setup texture
    CGImageRef imageref = [[UIImage imageNamed:@"leaves.gif"] CGImage];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageref options:@{GLKTextureLoaderOriginBottomLeft:@(true)} error:NULL];
    self.textureInfo0 = textureInfo;
    
    CGImageRef imageRef1 = [[UIImage imageNamed:@"beetle.png"] CGImage];
    self.textureInfo1 = [GLKTextureLoader textureWithCGImage:imageRef1 options:@{GLKTextureLoaderOriginBottomLeft:@(YES)} error:nil];
    
//    glEnable(GL_BLEND);
//    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    self.baseEffect.texture2d0.name = self.textureInfo0.name;
    self.baseEffect.texture2d0.target = self.textureInfo0.target;
    self.baseEffect.texture2d1.name = self.textureInfo1.name;
    self.baseEffect.texture2d1.target = self.textureInfo1.target;
    self.baseEffect.texture2d1.envMode = GLKTextureEnvModeDecal;
    
    
}

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
 }
 - (void)preparetoDrawWithAttrib:(GLuint)index
             numberOfCoordinates:(GLint)count
                    attribOffset:(GLsizeptr)offset
                    shouldEnable:(BOOL)shouldEnable {
     if(shouldEnable)
     {
        glEnableVertexAttribArray(     // Step 4
           index);
     }
     glVertexAttribPointer(index,count,GL_FlOAT,GL_FALSE,stride,NULL+offset);
 }
 - (void)drawArrayWithMode:(GLenum)mode
          startVertexIndex:(GLint)first
          numberOfVertices:(GLsizei)count {
     glDrawArrays(mode, first, count);
 }
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClear(GL_COLOR_BUFFER_BIT);
    

//    [self.baseEffect prepareToDraw];
//    glDrawArrays(GL_TRIANGLES, 0, 6);//6
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);//4
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord1);
    
    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(SceneVertex),
                          NULL+offsetof(SceneVertex, positionCoords));//5
    
    glVertexAttribPointer(GLKVertexAttribTexCoord0,2,GL_FLOAT,GL_FALSE,sizeof(SceneVertex),NULL+offsetof(SceneVertex, textureCoords));
    
    glVertexAttribPointer(GLKVertexAttribTexCoord1,2,GL_FLOAT,GL_FALSE,sizeof(SceneVertex),NULL+offsetof(SceneVertex, textureCoords));
    
    [self.baseEffect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, 6);//6
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
