//
//  MyGLView.m
//  Study_GL_1
//
//  Created by gxs on 12-12-22.
//  Copyright (c) 2012年 gxs. All rights reserved.
//

#import "MyGLView.h"

@implementation MyGLView

@synthesize context = _context;
@synthesize defaultFrameBuffer = _defaultFrameBuffer;
@synthesize colorRenderBuffer = _colorRenderBuffer;
@synthesize backingHeight = _backingHeigt;
@synthesize backingWidth = _backingWidth;

@synthesize animationTimer = _animationTimer;
@synthesize timeInterval = _timeInterval;



+ (Class)layerClass
{
    return [CAEAGLLayer class];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CAEAGLLayer *eaglLayer = (CAEAGLLayer*)self.layer;
        eaglLayer.opaque = YES;
        
        //设置drawableProperties属性
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:FALSE],kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat, nil];
        
        EAGLRenderingAPI renderAPI = kEAGLRenderingAPIOpenGLES1;
        _context = [[EAGLContext alloc] initWithAPI:renderAPI];
        if(!_context || ![EAGLContext setCurrentContext:_context])
        {
            [self release];
            return nil;
        }
        
        [self setupFrameBuffer];
        [self setupRenderBuffer];
        [self setupOpenGLESLayer];
        [self loadTexture];
//        [self render];
        [self setTimeIntervalAndStartScene];
        
    }
    return self;
}

- (void)dealloc
{
    [_context release];
    [super dealloc];
}

//设置缓冲区
- (void)setupFrameBuffer
{
    //创建缓冲区，存储在defaultFrameBuffer
    glGenFramebuffersOES(1, &_defaultFrameBuffer);
    //绑定帧缓冲区
    glBindFramebuffer(GL_FRAMEBUFFER_OES, _defaultFrameBuffer);
}


/*设置渲染缓冲区*/
- (void)setupRenderBuffer
{
    glGenRenderbuffersOES(1, &_colorRenderBuffer); //创建渲染缓冲区，存储在colorRenderBuffer
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _colorRenderBuffer); //绑定渲染缓冲区
}



//设置OpenGL
- (void)setupOpenGLESLayer
{
    //绑定layer的可绘制对象到刚才创建的OpenGLES缓冲区
    [_context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    //GL_COLOR_ATTACHMENT0_OES 命令将缓冲区关联到帧缓冲区，使glFrameBufferRenderbufferOES命令将渲染缓冲区作为一个特殊的福建加到帧缓冲区
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, _defaultFrameBuffer);
    //从渲染缓冲区获取尺寸，存储在backongWidth中，下同
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &_backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES,GL_RENDERBUFFER_HEIGHT_OES, &_backingHeigt);
    
    //检验帧缓冲区是否编译正确
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
    {
        NSLog(@"Failed to malke complete framebuffer object!");
        [self release];
    }
    
    
}

//渲染方法
- (void)render
{
    
    static CGFloat spinnySquaerVertices[8] = {
        -0.5f,-0.5f,0.5f,-0.5f,-0.5f,0.5f,0.5f,0.5f
    };
    glClearColor(0.1f, 0.8, 1.0f, 1.0f);//设置清屏颜色
    static CGFloat spinnSquareColor[] = {
        255,155,0,155,
        0,255,255,255,
        0,0,0,0,
        255,0,255,255,255
        
    };
    const GLshort square[] = {
        0,0,
        1,0,
        0,1,
        1,1
    };
    
    glClear(GL_COLOR_BUFFER_BIT);//清屏
    glViewport(0, 0, _backingWidth, _backingHeigt);
    
    glColor4f(1.0f, 1.0f, 0.0f, 1.0f);//绘制颜色
    
//    glColorPointer(4, GL_FLOAT, 0, spinnSquareColor);
//    glEnableClientState(GL_COLOR_ARRAY);
    
    glVertexPointer(2, GL_FLOAT, 0, spinnySquaerVertices);//确定使用的顶点坐标数列的位置和尺寸
    glEnableClientState(GL_VERTEX_ARRAY);//启动独立的客户端功能，告诉OpenGL将会使用一个由glVertexPointer定义的定点数组
    
    glTexCoordPointer(2, GL_SHORT, 0, square);//纹理坐标
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    
    
    
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);//进行连续不断的渲染，在渲染缓冲区有了一个准备好的要渲染的图像
    static float rotation = 0;
    glRotatef(rotation, 0.0, 0.0, 1.0);//旋转
    
    static float x = 0.0;
    glTranslatef(x, 0, 0); //平移到指定位置
    x += 0.001;
    
//    glScalef()//缩放
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);//进行不间断的渲染，在渲染缓冲区有了一个准备渲染的图像
    rotation += 5;
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    [_context presentRenderbuffer:GL_RENDERBUFFER_OES];//将渲染缓冲区内容呈现在屏幕上 
}

- (void)setTimeIntervalAndStartScene
{
    _timeInterval = 1.0/60;
    [self startAnimation];
}

- (void)gameRunLoop
{
    [self render];
}

- (void)startAnimation
{
    _animationTimer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(gameRunLoop) userInfo:nil repeats:YES];
}


//载入纹理
- (void)loadTexture
{
    //通过CGImage获得被UIImage加载的底层为图图数据，存储在CGImageRef结构体中
    CGImageRef textureImage = [UIImage imageNamed:@"back1.png"].CGImage;
    if(!textureImage){//判断是否加载成功
        NSLog(@"Load the Image failed！");
        return;
    }
    
    NSInteger textImageWith = CGImageGetWidth(textureImage);//获取图片数据 宽度
    NSInteger textImageHeight = CGImageGetHeight(textureImage);
    
    GLubyte *imageData = (GLubyte*)malloc(textImageWith*textImageHeight*4);//分配空间，返回指向这块内存的指针，存储在GLubyte中
    
    CGContextRef textureContext = CGBitmapContextCreate(imageData, textImageWith, textImageHeight, 8, textImageWith*4, CGImageGetColorSpace(textureImage), kCGImageAlphaPremultipliedLast);//创建位图语境
    
    CGContextDrawImage(textureContext, CGRectMake(0, 0, textImageWith, textImageHeight), textureImage);//draw image in the rectangular area specified by rect in th contect 'c'.The image is scaled,if necessary,to fit into 'rect'
    
    CGContextRelease(textureContext);//释放创建的语境
    
    glGenTextures(1, &_texture[0]);//创建纹理名称，这里是创建一个纹理，也可以创建多个，第一个参数是纹理的个数
    glBindTexture(GL_TEXTURE_2D, _texture[0]);//绑定纹理，第一个参数为作用目标，在OpenGLES必须使用GL_TEXTURE_2D,因为OpenGLES只支持这个,第二个为需要绑定的纹理名称
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, textImageWith, textImageHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);//将图像数据家在到纹理中
    free(imageData);//释放内存
    
    //下面的为设置纹理相关参数，GL_LINEAR参数能呈现一个平滑的、消除了锯齿的外观
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glEnable(GL_TEXTURE_2D);//开启2d纹理贴图功能
    
}







/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
