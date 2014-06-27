//
//  car.h
//  blockDemo
//
//  Created by liuHuan on 6/12/14.
//  Copyright (c) 2014 itotem. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef double(^SpeedBlock)(double);


@interface Car : NSObject
{
    NSString *_model;
}
@property (copy) NSString *model;

@property double odometer;



/*
 将block变量作为参数，下面的block没有变量名字。 参数 speedFunction 就是一个block。
 */
- (void)driveForDuration:(double)duration
       withVariableSpeed:(double (^)(double time))speedFunction
                   steps:(int)numSteps;

/*
 typedef double(^SpeedBlock)(double);
 声明SpeedBlock 类型的block，然后传入
 */
- (void)driveForDuration:(double)duration withVariableSpeedBlock:(SpeedBlock)speedFunction steps:(int)numSteps;


// Accessors
- (BOOL)isRunning;
- (void)setRunning:(BOOL)running;
- (NSString *)model;
- (void)setModel:(NSString *)model;

// Calculated values
- (double)maximumSpeed;
- (double)maximumSpeedUsingLocale:(NSLocale *)locale;

// Action methods
- (void)startEngine;
- (void)driveForDistance:(double)theDistance;
- (void)driveFromOrigin:(id)theOrigin toDestination:(id)theDestination;
- (void)turnByAngle:(double)theAngle;
- (void)turnToAngle:(double)theAngle;

// Error handling methods
- (BOOL)loadPassenger:(id)aPassenger error:(NSError **)error;

// Constructor methods
- (id)initWithModel:(NSString *)aModel;
- (id)initWithModel:(NSString *)aModel mileage:(double)theMileage;

// Comparison methods
- (BOOL)isEqualToCar:(Car *)anotherCar;
- (Car *)fasterCar:(Car *)anotherCar;
- (Car *)slowerCar:(Car *)anotherCar;

// Factory methods
+ (Car *)car;
+ (Car *)carWithModel:(NSString *)aModel;
+ (Car *)carWithModel:(NSString *)aModel mileage:(double)theMileage;

// Singleton methods
+ (Car *)sharedCar;

@end
