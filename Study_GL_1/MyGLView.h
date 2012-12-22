//
//  MyGLView.h
//  Study_GL_1
//
//  Created by gxs on 12-12-22.
//  Copyright (c) 2012年 gxs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>

@interface MyGLView : UIView
{
    EAGLContext *_context;
    
    GLuint _defaultFrameBuffer;
    GLuint _colorRenderBuffer;
    GLint _backingHeigt;
    GLint _backingWidth;
    
    NSTimer *_animationTimer;
    NSTimeInterval _timeInterval;
    
    GLuint _texture[1];
    
}

@property (retain, nonatomic) EAGLContext *context;

@property (assign, nonatomic) GLuint defaultFrameBuffer;
@property (assign, nonatomic) GLuint colorRenderBuffer;
@property (assign, nonatomic) GLint backingHeight;
@property (assign, nonatomic) GLint backingWidth;

@property (retain, nonatomic) NSTimer *animationTimer;
@property (assign, nonatomic) NSTimeInterval timeInterval;

@end
