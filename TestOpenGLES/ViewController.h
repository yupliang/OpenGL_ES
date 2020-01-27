//
//  ViewController.h
//  TestOpenGLES
//
//  Created by app-01 on 2019/12/20.
//  Copyright © 2019 Beta Technology. All rights reserved.
//

#define GLES_SILENCE_DEPRECATION

#import <GLKit/GLKit.h>
#import "SceneModel.h"

@interface ViewController : GLKViewController {
    GLuint vertexBufferID;
    
}

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) SceneModel *rinkModel;

@end

