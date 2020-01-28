//
//  ViewController.m
//  TestOpenGLES
//
//  Created by app-01 on 2019/12/20.
//  Copyright © 2019 Beta Technology. All rights reserved.
//

#import "ViewController.h"
#import <sys/kdebug_signpost.h>
#import "SceneRinkModel.h"
#import "SceneCarModel.h"
#import "SceneCar.h"

@interface ViewController ()
{
   NSMutableArray      *cars; // Cars to simulate
}
@property (strong, nonatomic) SceneModel *carModel;
@property (nonatomic, assign, readwrite) SceneAxisAllignedBoundingBox rinkBoundingBox;

@end

@implementation ViewController

@synthesize eyePosition;
@synthesize lookAtPosition;
@synthesize carModel;
@synthesize rinkBoundingBox;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View controller's view is not a GLKView");
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.rinkModel = [[SceneRinkModel alloc] init];
    
    // Remember the rink bounding box for future collision
    // detection with cars
    self.rinkBoundingBox = self.rinkModel.axisAlignedBoundingBox;
    NSAssert(0 < (self.rinkBoundingBox.max.x -
       self.rinkBoundingBox.min.x) &&
       0 < (self.rinkBoundingBox.max.z -
       self.rinkBoundingBox.min.z),
       @"Rink has no area");
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glEnable(GL_DEPTH_TEST);
    
    // Configure a light
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.ambientColor = GLKVector4Make(
       0.6f, // Red
       0.6f, // Green
       0.6f, // Blue
       1.0f);// Alpha
    self.baseEffect.light0.position = GLKVector4Make(
       1.0f,
       0.8f,
       0.4f,
       0.0f);
    
    // Set initial point of view to reasonable arbitrary values
    // These values make most of the simulated rink visible
    self.eyePosition = GLKVector3Make(10.5, 5.0, 0.0);
    self.lookAtPosition = GLKVector3Make(0.0, 0.5, 0.0);
    
    // Create an array to store cars
      cars = [[NSMutableArray alloc] init];
    // Load models used to draw the scene
    self.carModel = [[SceneCarModel alloc] init];
    // Create and add some cars to the simulation. The number of
    // cars, colors and velocities are arbitrary
    SceneCar   *newCar = [[SceneCar alloc]
       initWithModel:self.carModel
       position:GLKVector3Make(1.0, 0.0, 1.0)
       velocity:GLKVector3Make(1.5, 0.0, 1.5)
       color:GLKVector4Make(0.0, 0.5, 0.0, 1.0)];
    [cars addObject:newCar];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    //arg4 用于区分颜色， 0 Blue, 1 Green, 2 Purple, 3 Orange, 4 Red
    kdebug_signpost_start(10, 0, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
//     Make the light white
    self.baseEffect.light0.diffuseColor = GLKVector4Make(
       1.0f, // Red
       1.0f, // Green
       1.0f, // Blue
       1.0f);// Alpha
    
    // Calculate the aspect ratio for the scene and setup a
    // perspective projection
    const GLfloat  aspectRatio =
       (GLfloat)view.drawableWidth / (GLfloat)view.drawableHeight;

    self.baseEffect.transform.projectionMatrix =
       GLKMatrix4MakePerspective(
          GLKMathDegreesToRadians(35.0f),// Standard field of view
          aspectRatio,
          0.1f,   // Don't make near plane too close
          25.0f); // Far is aritrarily far enough to contain scene
    // Set the modelview matrix to match current eye and look-at
    // positions
    self.baseEffect.transform.modelviewMatrix =
       GLKMatrix4MakeLookAt(
          self.eyePosition.x,
          self.eyePosition.y,
          self.eyePosition.z,
          self.lookAtPosition.x,
          self.lookAtPosition.y,
          self.lookAtPosition.z,
          0, 1, 0);
    
    [self.baseEffect prepareToDraw];
    //draw the rink
    [self.rinkModel draw];
    // Draw the cars
    [cars makeObjectsPerformSelector:@selector(drawWithBaseEffect:)
       withObject:self.baseEffect];
    kdebug_signpost_end(10, 0, 0, 0, 1);

    #ifdef DEBUG
       {  // Report any errors
          GLenum error = glGetError();
          if(GL_NO_ERROR != error)
          {
             NSLog(@"GL Erroraa: 0x%x", error);
          }
       }
    #endif
}

/////////////////////////////////////////////////////////////////
// This method must be called at least once before the receiver
// is drawn. This method updates the "target" eye position and
// look-at position based on the user's chosen point of view.
- (void)updatePointOfView
{
   // Set the target point of view to arbitrary "third person"
   // perspective
   self.eyePosition = GLKVector3Make(10.5, 5.0, 0.0);
   self.lookAtPosition = GLKVector3Make(0.0, 0.5, 0.0);
}


//MARK: override
- (void)update {
    // Update the current eye and look-at positions with fast
    // filter so POV stays close to car orientation but still
    // has a little "bounce"
//    self.eyePosition = SceneVector3FastLowPassFilter(
//       self.timeSinceLastUpdate,
//       self.targetEyePosition,
//       self.eyePosition);
//    self.lookAtPosition = SceneVector3FastLowPassFilter(
//       self.timeSinceLastUpdate,
//       self.targetLookAtPosition,
//       self.lookAtPosition);

    // Update the cars
    [cars makeObjectsPerformSelector:
       @selector(updateWithController:) withObject:self];
    
    [self updatePointOfView];
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

/////////////////////////////////////////////////////////////////
// Implements required accessor method for cars property
- (NSArray *)cars
{
   return cars;
}

@end
