//
//  ViewController.h
//  TestOpenGLES
//
//  Created by app-01 on 2019/12/20.
//  Copyright © 2019 Beta Technology. All rights reserved.
//

#define GLES_SILENCE_DEPRECATION

#import <GLKit/GLKit.h>

@interface ViewController : GLKViewController {
    GLuint vertexBufferID;
    GLuint _textureBufferID;
    GLuint _normalBufferID;
    GLfloat _rotateDegree;
    GLfloat _scaleX;
}

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (nonatomic) GLfloat centerVertexHeight;

@end

