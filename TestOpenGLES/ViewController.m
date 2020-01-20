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

/////////////////////////////////////////////////////////////////
// Forward declaration
static GLKMatrix4 SceneMatrixForTransform(
   SceneTransformationSelector type,
   SceneTransformationAxisSelector axis,
   float value);

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
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    //arg4 用于区分颜色， 0 Blue, 1 Green, 2 Purple, 3 Orange, 4 Red
    kdebug_signpost_start(10, 0, 0, 0, 1);
    
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
    
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 3*sizeof(GLfloat), NULL+0);
    
    glBindBuffer(GL_ARRAY_BUFFER, normalBufferID);
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 3*sizeof(GLfloat), NULL+0);
    
    // Save the current Modelview matrix
    GLKMatrix4 savedModelviewMatrix =
       self.baseEffect.transform.modelviewMatrix;
    
    // Combine all of the user chosen transforms in order
    GLKMatrix4 newModelviewMatrix =
       GLKMatrix4Multiply(savedModelviewMatrix,
       SceneMatrixForTransform(
          transform1Type,
          transform1Axis,
          transform1Value));
    newModelviewMatrix =
       GLKMatrix4Multiply(newModelviewMatrix,
       SceneMatrixForTransform(
          transform2Type,
          transform2Axis,
          transform2Value));
    newModelviewMatrix =
       GLKMatrix4Multiply(newModelviewMatrix,
       SceneMatrixForTransform(
          transform3Type,
          transform3Axis,
          transform3Value));

    // Set the Modelview matrix for drawing
    self.baseEffect.transform.modelviewMatrix = newModelviewMatrix;
    
    // Make the light white
    self.baseEffect.light0.diffuseColor = GLKVector4Make(
       1.0f, // Red
       1.0f, // Green
       1.0f, // Blue
       1.0f);// Alpha
    [self.baseEffect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, lowPolyAxesAndModels2NumVerts);
    
    self.baseEffect.transform.modelviewMatrix = savedModelviewMatrix;
    // Change the light color
    self.baseEffect.light0.diffuseColor = GLKVector4Make(
       1.0f, // Red
       1.0f, // Green
       0.0f, // Blue
       0.3f);// Alpha 
    [self.baseEffect prepareToDraw];
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

/////////////////////////////////////////////////////////////////
// Reset all user transforms to identity values
- (IBAction)takeTransform1TypeFrom:(UISegmentedControl *)aControl
{
   transform1Type = [aControl selectedSegmentIndex];
}

/////////////////////////////////////////////////////////////////
// Update variables with user transform information and redraw
- (IBAction)takeTransform1AxisFrom:(UISegmentedControl *)aControl
{
   transform1Axis = [aControl selectedSegmentIndex];
}

/////////////////////////////////////////////////////////////////
// Update variables with user transform information and redraw
- (IBAction)takeTransform1ValueFrom:(UISlider *)aControl
{
   transform1Value = [aControl value];
}

/////////////////////////////////////////////////////////////////
// Reset all user transforms to identity values
- (IBAction)takeTransform2TypeFrom:(UISegmentedControl *)aControl
{
   transform2Type = [aControl selectedSegmentIndex];
}

/////////////////////////////////////////////////////////////////
// Update variables with user transform information and redraw
- (IBAction)takeTransform2AxisFrom:(UISegmentedControl *)aControl
{
   transform2Axis = [aControl selectedSegmentIndex];
}

- (IBAction)takeTransform2ValueFrom:(UISlider *)aControl
{
   transform2Value = [aControl value];
}

/////////////////////////////////////////////////////////////////
// Reset all user transforms to identity values
- (IBAction)takeTransform3TypeFrom:(UISegmentedControl *)aControl
{
   transform3Type = [aControl selectedSegmentIndex];
}

/////////////////////////////////////////////////////////////////
// Update variables with user transform information and redraw
- (IBAction)takeTransform3AxisFrom:(UISegmentedControl *)aControl
{
   transform3Axis = [aControl selectedSegmentIndex];
}

- (IBAction)takeTransform3ValueFrom:(UISlider *)aControl
{
   transform3Value = [aControl value];
}

/////////////////////////////////////////////////////////////////
// Reset all user transforms to identity values
- (IBAction)resetIdentity:(id)dummy
{
   [_transform1ValueSlider setValue:0.0];
   [_transform2ValueSlider setValue:0.0];
   [_transform3ValueSlider setValue:0.0];
   transform1Value = 0.0;
   transform2Value = 0.0;
   transform3Value = 0.0;
}

/////////////////////////////////////////////////////////////////
// Transform the current coordinate system according to the users
// selections stored in global variables, transform1Type,
// transform1Axis, and transform1Value.
static GLKMatrix4 SceneMatrixForTransform(
   SceneTransformationSelector type,
   SceneTransformationAxisSelector axis,
   float value)
{
   GLKMatrix4 result = GLKMatrix4Identity;
   
   switch (type) {
      case SceneRotate:
         switch (axis) {
            case SceneXAxis:
               result = GLKMatrix4MakeRotation(
                  GLKMathDegreesToRadians(180.0 * value),
                  1.0,
                  0.0,
                  0.0);
               break;
            case SceneYAxis:
               result = GLKMatrix4MakeRotation(
                  GLKMathDegreesToRadians(180.0 * value),
                  0.0,
                  1.0,
                  0.0);
               break;
            case SceneZAxis:
            default:
               result = GLKMatrix4MakeRotation(
                  GLKMathDegreesToRadians(180.0 * value),
                  0.0,
                  0.0,
                  1.0);
               break;
         }
         break;
      case SceneScale:
         switch (axis) {
            case SceneXAxis:
               result = GLKMatrix4MakeScale(
                  1.0 + value,
                  1.0,
                  1.0);
               break;
            case SceneYAxis:
               result = GLKMatrix4MakeScale(
                  1.0,
                  1.0 + value,
                  1.0);
               break;
            case SceneZAxis:
            default:
               result = GLKMatrix4MakeScale(
                  1.0,
                  1.0,
                  1.0 + value);
               break;
         }
         break;
      default:
         switch (axis) {
            case SceneXAxis:
               result = GLKMatrix4MakeTranslation(
                  0.3 * value,
                  0.0,
                  0.0);
               break;
            case SceneYAxis:
               result = GLKMatrix4MakeTranslation(
                  0.0,
                  0.3 * value,
                  0.0);
               break;
            case SceneZAxis:
            default:
               result = GLKMatrix4MakeTranslation(
                  0.0,
                  0.0,
                  0.3 * value);
               break;
         }
         break;
   }
   
   return result;
}
@end
