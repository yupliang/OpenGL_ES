//
//  AGLKVertexAttribArrayBuffer.m
//  TestOpenGLES
//
//  Created by Qiqiuzhe on 2019/12/24.
//  Copyright © 2019 Beta Technology. All rights reserved.
//

#import "AGLKVertexAttribArrayBuffer.h"

@interface AGLKVertexAttribArrayBuffer ()

@property (nonatomic, assign) GLsizeiptr
   bufferSizeBytes;

@property (nonatomic, assign) GLsizeiptr
   stride;

@end

@implementation AGLKVertexAttribArrayBuffer

/////////////////////////////////////////////////////////////////
// This method creates a vertex attribute array buffer in
// the current OpenGL ES context for the thread upon which this
// method is called.
- (id)initWithAttribStride:(GLsizeiptr)aStride
   numberOfVertices:(GLsizei)count
   bytes:(const GLvoid *)dataPtr
   usage:(GLenum)usage
{
   NSParameterAssert(0 < aStride);
   NSAssert((0 < count && NULL != dataPtr) ||
      (0 == count && NULL == dataPtr),
      @"data must not be NULL or count > 0");
      
   if(nil != (self = [super init]))
   {
      stride = aStride;
      bufferSizeBytes = stride * count;
      
      glGenBuffers(1,                // STEP 1
         &name);
      glBindBuffer(GL_ARRAY_BUFFER,  // STEP 2
         self.name);
      glBufferData(                  // STEP 3
         GL_ARRAY_BUFFER,  // Initialize buffer contents
         bufferSizeBytes,  // Number of bytes to copy
         dataPtr,          // Address of bytes to copy
         usage);           // Hint: cache in GPU memory
         
      NSAssert(0 != name, @"Failed to generate name");
   }
   
   return self;
}

/////////////////////////////////////////////////////////////////
// A vertex attribute array buffer must be prepared when your
// application wants to use the buffer to render any geometry.
// When your application prepares an buffer, some OpenGL ES state
// is altered to allow bind the buffer and configure pointers.
- (void)prepareToDrawWithAttrib:(GLuint)index
   numberOfCoordinates:(GLint)count
   attribOffset:(GLsizeiptr)offset
   shouldEnable:(BOOL)shouldEnable
{
   NSParameterAssert((0 < count) && (count < 4));
   NSParameterAssert(offset < self.stride);
   NSAssert(0 != name, @"Invalid name");

   glBindBuffer(GL_ARRAY_BUFFER,     // STEP 2
      self.name);

   if(shouldEnable)
   {
      glEnableVertexAttribArray(     // Step 4
         index);
   }

   glVertexAttribPointer(            // Step 5
      index,               // Identifies the attribute to use
      count,               // number of coordinates for attribute
      GL_FLOAT,            // data is floating point
      GL_FALSE,            // no fixed point scaling
      self.stride,         // total num bytes stored per vertex
      NULL + offset);      // offset from start of each vertex to
                           // first coord for attribute
#ifdef DEBUG
   {  // Report any errors
      GLenum error = glGetError();
      if(GL_NO_ERROR != error)
      {
         NSLog(@"GL Error: 0x%x", error);
      }
   }
#endif
}

- (void)preparetoDrawWithAttrib:(GLuint)index
            numberOfCoordinates:(GLint)count
                   attribOffset:(GLsizeiptr)offset
                   shouldEnable:(BOOL)shouldEnable {
    glVertexAttribPointer(index,count,GL_FLOAT,GL_FALSE,stride,NULL+offset);
}

- (id)initWithAttriStride:(GLsizeiptr)aStride
         numberOfVertices:(GLsizei)count
                      data:(const GLvoid *)dataPtr
                    usage:(GLenum)usage {
    NSParameterAssert(0 < aStride);
    NSAssert((0 < count && NULL != dataPtr) ||
       (0 == count && NULL == dataPtr),
       @"data must not be NULL or count > 0");
       
    if(nil != (self = [super init]))
    {
       stride = aStride;
       bufferSizeBytes = stride * count;
       
       glGenBuffers(1,                // STEP 1
          &name);
       glBindBuffer(GL_ARRAY_BUFFER,  // STEP 2
          self.name);
       glBufferData(                  // STEP 3
          GL_ARRAY_BUFFER,  // Initialize buffer contents
          bufferSizeBytes,  // Number of bytes to copy
          dataPtr,          // Address of bytes to copy
          usage);           // Hint: cache in GPU memory
          
       NSAssert(0 != name, @"Failed to generate name");
    }
    
    return self;
}

- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLint)first
         numberOfVertices:(GLsizei)count {
    glDrawArrays(mode, first, count);
}

/////////////////////////////////////////////////////////////////
// Submits the drawing command identified by mode and instructs
// OpenGL ES to use count vertices from previously prepared
// buffers starting from the vertex at index first in the
// prepared buffers
+ (void)drawPreparedArraysWithMode:(GLenum)mode
   startVertexIndex:(GLint)first
   numberOfVertices:(GLsizei)count;
{
   glDrawArrays(mode, first, count); // Step 6
}

/////////////////////////////////////////////////////////////////
// This method loads the data stored by the receiver.
- (void)reinitWithAttribStride:(GLsizeiptr)aStride
   numberOfVertices:(GLsizei)count
   bytes:(const GLvoid *)dataPtr
{
   NSParameterAssert(0 < aStride);
   NSParameterAssert(0 < count);
   NSParameterAssert(NULL != dataPtr);
   NSAssert(0 != name, @"Invalid name");

   self.stride = aStride;
   self.bufferSizeBytes = aStride * count;
   
   glBindBuffer(GL_ARRAY_BUFFER,  // STEP 2
      self.name);
   glBufferData(                  // STEP 3
      GL_ARRAY_BUFFER,  // Initialize buffer contents
      bufferSizeBytes,  // Number of bytes to copy
      dataPtr,          // Address of bytes to copy
      GL_DYNAMIC_DRAW);
}


@end
