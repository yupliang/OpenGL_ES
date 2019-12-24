//
//  AGLKVertexAttribArrayBuffer.m
//  TestOpenGLES
//
//  Created by Qiqiuzhe on 2019/12/24.
//  Copyright © 2019 Beta Technology. All rights reserved.
//

#import "AGLKVertexAttribArrayBuffer.h"

@implementation AGLKVertexAttribArrayBuffer

- (void)preparetoDrawWithAttrib:(GLuint)index
            numberOfCoordinates:(GLint)count
                   attribOffset:(GLsizeptr)offset
                   shouldEnable:(BOOL)shouldEnable {
    glVertexAttribPointer(index,count,GL_FlOAT,GL_FALSE,stride,NULL+offset);
}

@end
