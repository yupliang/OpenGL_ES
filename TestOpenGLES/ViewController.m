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
SceneVertex vertexE = {{0.0,0.0,0},{0.0,0.0,1.0}};
SceneVertex vertexF = {{0.0,-0.5,-0.5},{0.0,0.0,1.0}};
SceneVertex vertexG = {{0.5,0.5,-0.5},{0.0,0.0,1.0}};
SceneVertex vertexH = {{0.5,0,-0.5},{0.0,0.0,1.0}};
SceneVertex vertexI = {{0.5,-0.5,-0.5},{0.0,0.0,1.0}};

#define NUM_FACES (8)

typedef struct {
    SceneVertex vertices[3];
} SceneTriangle;


// Forward function declarations
static SceneTriangle SceneTriangleMake(
   const SceneVertex vertexA,
   const SceneVertex vertexB,
   const SceneVertex vertexC);

static  GLKVector3 SceneVector3UnitNormal(
const GLKVector3 vectorA,
const GLKVector3 vectorB);

static void SceneTrianglesUpdateFaceNormals(
SceneTriangle someTriangles[NUM_FACES]);

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
    

    {  // Comment out this block to render the scene top down
       GLKMatrix4 modelViewMatrix = GLKMatrix4MakeRotation(
          GLKMathDegreesToRadians(-60.0f), 1.0f, 0.0f, 0.0f);
       modelViewMatrix = GLKMatrix4Rotate(
          modelViewMatrix,
          GLKMathDegreesToRadians(-30.0f), 0.0f, 0.0f, 1.0f);
       modelViewMatrix = GLKMatrix4Translate(
          modelViewMatrix,
          0.0f, 0.0f, 0.25f);

       self.baseEffect.transform.modelviewMatrix = modelViewMatrix;
//       self.extraEffect.transform.modelviewMatrix = modelViewMatrix;
    }
    
    triangles[0] = SceneTriangleMake(vertexA, vertexB, vertexD);
    triangles[1] = SceneTriangleMake(vertexB, vertexC, vertexF);
    triangles[2] = SceneTriangleMake(vertexD, vertexB, vertexE);
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
    NSLog(@"size of sizeof(triangles)/sizeof(SceneVertex) %lu", sizeof(triangles)/sizeof(SceneVertex));


    glBufferData(GL_ARRAY_BUFFER, sizeof(triangles), triangles, GL_DYNAMIC_DRAW);//3
    
    self.centerVertexHeight = 0.0;
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
    
    glEnableVertexAttribArray(GLKVertexAttribNormal);//4
    glVertexAttribPointer(GLKVertexAttribNormal,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(SceneVertex),
                          NULL+offsetof(SceneVertex, normalVectors));//5
    
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

/////////////////////////////////////////////////////////////////
// This method sets the value of centerVertexHeight and updates
// vertex normals
- (void)setCenterVertexHeight:(GLfloat)aValue
{
    NSLog(@"value changed from %f to %f", _centerVertexHeight, aValue);
   _centerVertexHeight = aValue;
   
    
    
    SceneVertex newVertexE = vertexE;
    newVertexE.positionCoords.z = self.centerVertexHeight;
    triangles[2] = SceneTriangleMake(vertexD, vertexB, newVertexE);
    triangles[3] = SceneTriangleMake(vertexB, vertexF, newVertexE);
    triangles[4] = SceneTriangleMake(vertexD, newVertexE, vertexH);
    triangles[5] = SceneTriangleMake(newVertexE, vertexF, vertexH);
    
    SceneTrianglesUpdateFaceNormals(triangles);
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(triangles), triangles, GL_DYNAMIC_DRAW);//3
    
    
}

/////////////////////////////////////////////////////////////////
// This method sets the value of the center vertex height to the
// value obtained from sender
- (IBAction)takeCenterVertexHeightFrom:(UISlider *)sender;
{
   self.centerVertexHeight = sender.value;
}


@end

static SceneTriangle SceneTriangleMake(const SceneVertex vertexA, const SceneVertex vertexB, const SceneVertex vertexC) {
    SceneTriangle result;
    
    result.vertices[0] = vertexA;
    result.vertices[1] = vertexB;
    result.vertices[2] = vertexC;
    
    return result;
}

/////////////////////////////////////////////////////////////////
// This function returns the face normal vector for triangle.
static GLKVector3 SceneTriangleFaceNormal(
   const SceneTriangle triangle)
{
   GLKVector3 vectorA = GLKVector3Subtract(
      triangle.vertices[1].positionCoords,
      triangle.vertices[0].positionCoords);
   GLKVector3 vectorB = GLKVector3Subtract(
      triangle.vertices[2].positionCoords,
      triangle.vertices[0].positionCoords);
      
   return SceneVector3UnitNormal(
      vectorA,
      vectorB);
}


/////////////////////////////////////////////////////////////////
// Calculates the face normal vectors for 8 triangles and then
// update the normal vectors for each vertex of each triangle
// using the triangle's face normal for all three for the
// triangle's vertices
static void SceneTrianglesUpdateFaceNormals(
   SceneTriangle someTriangles[NUM_FACES])
{
   int                i;
   
   for (i=0; i<NUM_FACES; i++)
   {
      GLKVector3 faceNormal = SceneTriangleFaceNormal(
         someTriangles[i]);
      someTriangles[i].vertices[0].normalVectors = faceNormal;
      someTriangles[i].vertices[1].normalVectors = faceNormal;
      someTriangles[i].vertices[2].normalVectors = faceNormal;
   }
}

#pragma mark - Utility GLKVector3 functions

/////////////////////////////////////////////////////////////////
// Returns a unit vector in the same direction as the cross
// product of vectorA and VectorB
GLKVector3 SceneVector3UnitNormal(
   const GLKVector3 vectorA,
   const GLKVector3 vectorB)
{
   return GLKVector3Normalize(
      GLKVector3CrossProduct(vectorA, vectorB));
}
