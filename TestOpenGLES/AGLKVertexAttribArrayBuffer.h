//
//  AGLKVertexAttribArrayBuffer.h
//  TestOpenGLES
//
//  Created by Qiqiuzhe on 2019/12/24.
//  Copyright © 2019 Beta Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGLKVertexAttribArrayBuffer : NSObject
{
   GLsizeiptr   stride;
   GLsizeiptr   bufferSizeBytes;
   GLuint       name;
}

@property (nonatomic, readonly) GLuint
   name;
@property (nonatomic, readonly) GLsizeiptr
   bufferSizeBytes;
@property (nonatomic, readonly) GLsizeiptr
   stride;

- (id)initWithAttriStride:(GLsizeiptr)aStride
numberOfVertices:(GLsizei)count
             data:(const GLvoid *)dataPtr
                    usage:(GLenum)usage;
- (id)initWithAttribStride:(GLsizeiptr)aStride
numberOfVertices:(GLsizei)count
bytes:(const GLvoid *)dataPtr
                     usage:(GLenum)usage;
- (void)prepareToDrawWithAttrib:(GLuint)index
numberOfCoordinates:(GLint)count
attribOffset:(GLsizeiptr)offset
shouldEnable:(BOOL)shouldEnable;
+ (void)drawPreparedArraysWithMode:(GLenum)mode
startVertexIndex:(GLint)first
numberOfVertices:(GLsizei)count;
- (void)drawArrayWithMode:(GLenum)mode
startVertexIndex:(GLint)first
         numberOfVertices:(GLsizei)count;
- (void)reinitWithAttribStride:(GLsizeiptr)aStride
numberOfVertices:(GLsizei)count
                         bytes:(const GLvoid *)dataPtr;

@end

NS_ASSUME_NONNULL_END
