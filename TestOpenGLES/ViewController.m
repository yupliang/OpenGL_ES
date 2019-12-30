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
    GLKVector3 normalVectors;
} SceneVertex;

SceneVertex vertexA = {{-0.5,0.5,-0.5},{0.0,0.0,1.0}};
SceneVertex vertexB = {{-0.5,0.0,-0.5},{0.0,0.0,1.0}};
SceneVertex vertexC = {{-0.5,-0.5,-0.5},{0.0,0.0,1.0}};
SceneVertex vertexD = {{0.0,0.5,-0.5},{0.0,0.0,1.0}};
SceneVertex vertexE = {{0.0,0.0,0.0},{0.0,0.0,1.0}};
SceneVertex vertexF = {{0.0,-0.5,-0.5},{0.0,0.0,1.0}};
SceneVertex vertexG = {{0.5,0.5,-0.5},{0.0,0.0,1.0}};
SceneVertex vertexH = {{0.5,0,-0.5},{0.0,0.0,1.0}};
SceneVertex vertexI = {{-0.5,-0.5,-0.5},{0.0,0.0,1.0}};

typedef struct {
    SceneVertex vertices[3];
} SceneTriangle;


// Forward function declarations
static SceneTriangle SceneTriangleMake(
   const SceneVertex vertexA,
   const SceneVertex vertexB,
   const SceneVertex vertexC);

@interface ViewController ()
{
    SceneTriangle triangles[8];
}
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    if (CheckForExtension(@"GL_IMG_texture_compression_pvrtc")) {
//        NSLog(@"GL_IMG_texture_compression_pvrtc available");
//    }
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View controller's view is not a GLKView");
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.diffuseColor = GLKVector4Make(0.7f, 0.7f, 0.7f, 1.0f);
    self.baseEffect.light0.position = GLKVector4Make(1.0f, 1.0f, 0.5f, 0.0f);//第4个元素是0，表明是一个指向无限远的光源的方向
    
    triangles[0] = SceneTriangleMake(vertexA, vertexB, vertexD);
    triangles[1] = SceneTriangleMake(vertexB, vertexC, vertexF);
    triangles[2] = SceneTriangleMake(vertexB, vertexE, vertexD);
    triangles[3] = SceneTriangleMake(vertexB, vertexF, vertexE);
    triangles[4] = SceneTriangleMake(vertexD, vertexE, vertexH);
    triangles[5] = SceneTriangleMake(vertexE, vertexF, vertexH);
    triangles[6] = SceneTriangleMake(vertexD, vertexH, vertexG);
    triangles[7] = SceneTriangleMake(vertexH, vertexF, vertexI);
    
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


    glBufferData(GL_ARRAY_BUFFER, sizeof(triangles), triangles, GL_DYNAMIC_DRAW);//3
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
    [self.baseEffect prepareToDraw];
    glClear(GL_COLOR_BUFFER_BIT);
//    glDrawArrays(GL_TRIANGLES, 0, 6);//6
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);//4
    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(SceneVertex),
                          NULL+offsetof(SceneVertex, positionCoords));//5
    
    glDrawArrays(GL_TRIANGLES, 0, sizeof(triangles)/sizeof(SceneVertex));//6
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

static SceneTriangle SceneTriangleMake(const SceneVertex vertexA, const SceneVertex vertexB, const SceneVertex vertexC) {
    SceneTriangle result;
    
    result.vertices[0] = vertexA;
    result.vertices[1] = vertexB;
    result.vertices[2] = vertexC;
    
    return result;
}
