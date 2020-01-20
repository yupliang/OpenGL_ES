//
//  ViewController.h
//  TestOpenGLES
//
//  Created by app-01 on 2019/12/20.
//  Copyright © 2019 Beta Technology. All rights reserved.
//

#define GLES_SILENCE_DEPRECATION

#import <GLKit/GLKit.h>

@class AGLKTextureTransformBaseEffect;

@interface ViewController : GLKViewController {
    GLuint vertexBufferID;
}

@property (strong, nonatomic) AGLKTextureTransformBaseEffect *baseEffect;
@property (nonatomic) GLKMatrixStackRef textureMatrixStack;

@property (nonatomic) float textureScaleFactor;
@property (nonatomic) float textureAngle;

@end

