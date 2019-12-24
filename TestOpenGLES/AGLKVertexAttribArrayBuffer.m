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

@end
