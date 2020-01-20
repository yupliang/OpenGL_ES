//
//  ViewController.h
//  TestOpenGLES
//
//  Created by app-01 on 2019/12/20.
//  Copyright © 2019 Beta Technology. All rights reserved.
//

#define GLES_SILENCE_DEPRECATION

#import <GLKit/GLKit.h>

/////////////////////////////////////////////////////////////////
// Constants identify user selected transformations
typedef enum
{
    SceneTranslate = 0,
    SceneRotate,
    SceneScale,
} SceneTransformationSelector;


/////////////////////////////////////////////////////////////////
// Constants identify user selected axis for transformation
typedef enum
{
    SceneXAxis = 0,
    SceneYAxis,
    SceneZAxis,
} SceneTransformationAxisSelector;

@interface ViewController : GLKViewController {
    GLuint vertexBufferID;
    GLuint normalBufferID;
    
    SceneTransformationSelector      transform1Type;
    SceneTransformationAxisSelector  transform1Axis;
    float                            transform1Value;
    
    SceneTransformationSelector      transform2Type;
    SceneTransformationAxisSelector  transform2Axis;
    float                            transform2Value;
    
    SceneTransformationSelector      transform3Type;
    SceneTransformationAxisSelector  transform3Axis;
    float                            transform3Value;
}

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) IBOutlet UISlider *transform1ValueSlider;
@property (strong, nonatomic) IBOutlet UISlider *transform2ValueSlider;
@property (strong, nonatomic) IBOutlet UISlider *transform3ValueSlider;

@end

