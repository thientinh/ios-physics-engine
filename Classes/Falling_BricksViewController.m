//
//  Falling_BricksViewController.m
//  Falling Bricks
//
//  Created by eLdwin on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Falling_BricksViewController.h"

#import "World.h"
#import "Shape.h"
#import "Circle.h"
#import "Rectangle.h"
#import "Vector2D.h"
#import "GameObject.h"

#define GRAVITY (-98.1)

@implementation Falling_BricksViewController

const float FPS = 20.0;

- (void)createWallWithPosition:(CGPoint)p Size:(CGSize)s {
  Rectangle* rect = [world createShape:kRectangleShape];
  [rect setWidth:s.width];
  [rect setHeight:s.height];
  [rect setPosition:[Vector2D vectorWith:p.x y:p.y]];
  
  [rect setCanMove:NO];
  [rect setMass:MAXFLOAT];
  [rect setFriction:0.7];
  [world addShape:rect];
}

- (void)addBrickWithPosition:(CGPoint)p Size:(CGSize)s AngularVelocity:(double)av Color:(UIColor*)c {
  Rectangle* rect = [world createShape:kRectangleShape];
  [rect setWidth:s.width];
  [rect setHeight:s.height];
  [rect setPosition:[Vector2D vectorWith:p.x y:p.y]];
  
  [rect setAngularVelocity:av];
  [rect setMass:s.width * s.height];
  [rect setFriction:0.5];
  [world addShape:rect];
  
  GameObject* o = [[GameObject alloc] initWithShape:rect color:c];
  [gameObjects addObject:o];
  
  [self.view addSubview:o.view];
  [o release];
}

- (void)addCircleWithPosition:(CGPoint)p Radius:(double)r AngularVelocity:(double)av Color:(UIColor*)c {
  Circle* circ = [world createShape:kCircleShape];
  [circ setRadius:r];
  [circ setPosition:[Vector2D vectorWith:p.x y:p.y]];
  
  [circ setAngularVelocity:av];
  [circ setMass:(r * r * M_PI)];
  [circ setFriction:0.5];
  [world addShape:circ];
  
  GameObject* o = [[GameObject alloc] initWithShape:circ color:c];
  [gameObjects addObject:o];
  
  [self.view addSubview:o.view];
  [o release];
}

- (void)test {
  NSLog(@"YAHY");
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  gameObjects = [[NSMutableArray array] retain];
  
  // init world object
  world = [[World alloc] init];
  //[[NSNotificationCenter defaultCenter] addObserver:self selector:(@selector(test)) name:@"ShapeAdded" object:world];
  
  
  // create walls on 4 sides
  
  [self createWallWithPosition:CGPointMake(0, 1004) Size:CGSizeMake(768, 500)];
  [self createWallWithPosition:CGPointMake(0, -500) Size:CGSizeMake(768, 500)];
  [self createWallWithPosition:CGPointMake(-500, 0) Size:CGSizeMake(500, 1004)];
  [self createWallWithPosition:CGPointMake(768, 0) Size:CGSizeMake(500, 1004)];
  
  
  // add falling bricks
  [self addBrickWithPosition:CGPointMake(500, 700) Size:CGSizeMake(50, 50) AngularVelocity:1.3 Color:[UIColor brownColor]];
  [self addBrickWithPosition:CGPointMake(100, 700) Size:CGSizeMake(250, 100) AngularVelocity:1.3 Color:[UIColor orangeColor]];
  [self addBrickWithPosition:CGPointMake(200, 500) Size:CGSizeMake(100, 100) AngularVelocity:0.5 Color:[UIColor greenColor]];
  [self addBrickWithPosition:CGPointMake(300, 500) Size:CGSizeMake(150, 75) AngularVelocity:4.8 Color:[UIColor redColor]];
  [self addBrickWithPosition:CGPointMake(100, 300) Size:CGSizeMake(300, 100) AngularVelocity:-1.3 Color:[UIColor blackColor]];
  [self addBrickWithPosition:CGPointMake(600, 500) Size:CGSizeMake(70, 80) AngularVelocity:-5.3 Color:[UIColor blueColor]];
  [self addBrickWithPosition:CGPointMake(500, 150) Size:CGSizeMake(200, 100) AngularVelocity:-0.3 Color:[UIColor purpleColor]];
  [self addBrickWithPosition:CGPointMake(100, 900) Size:CGSizeMake(300, 50) AngularVelocity:-8.3 Color:[UIColor yellowColor]];
  
  // add falling circles
  [self addCircleWithPosition:CGPointMake(150, 700) Radius:50 AngularVelocity:1.3 Color:[UIColor brownColor]];
  [self addCircleWithPosition:CGPointMake(300, 200) Radius:100 AngularVelocity:0 Color:[UIColor orangeColor]];
  [self addCircleWithPosition:CGPointMake(150, 500) Radius:25 AngularVelocity:10.0 Color:[UIColor blueColor]];
  [self addCircleWithPosition:CGPointMake(450, 500) Radius:35 AngularVelocity:-11.5 Color:[UIColor yellowColor]];
  [self addCircleWithPosition:CGPointMake(600, 500) Radius:75 AngularVelocity:4.2 Color:[UIColor purpleColor]];
  [self addCircleWithPosition:CGPointMake(20, 500) Radius:20 AngularVelocity:-0.4 Color:[UIColor blackColor]];
  
  // setup accelerometer
  [[UIAccelerometer sharedAccelerometer] setDelegate:self];
  [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / FPS)];
  
  // start game loop
  [NSTimer scheduledTimerWithTimeInterval:(1.0/FPS) target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
  [world setGravity:[Vector2D vectorWith:-(acceleration.x * GRAVITY) y:-(acceleration.y * GRAVITY)]];
}

- (void)gameLoop {
  
#if TARGET_IPHONE_SIMULATOR
  switch ([[UIDevice currentDevice] orientation]) {
      
    case UIDeviceOrientationUnknown:  
    case UIDeviceOrientationPortrait:
      [world setGravity:[Vector2D vectorWith:0 y:GRAVITY]];
      break;
      
    case UIDeviceOrientationPortraitUpsideDown:
      [world setGravity:[Vector2D vectorWith:0 y:-GRAVITY]];
      break;
      
    case UIDeviceOrientationLandscapeLeft:
      [world setGravity:[Vector2D vectorWith:GRAVITY y:0]];
      break;
      
    case UIDeviceOrientationLandscapeRight:
      [world setGravity:[Vector2D vectorWith:-GRAVITY y:0]];
      break;
  }
  
#endif
  
  [world simulateTimeStep:(1.0/FPS)];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return NO;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [super dealloc];
}

@end
