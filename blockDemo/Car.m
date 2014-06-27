//
//  car.m
//  blockDemo
//
//  Created by liuHuan on 6/12/14.
//  Copyright (c) 2014 itotem. All rights reserved.
//

#import "Car.h"

@implementation Car

- (void)driveForDuration:(double)duration
       withVariableSpeed:(double (^)(double time))speedFunction
                   steps:(int)numSteps {
    double dt = duration / numSteps;
    for (int i=1; i<=numSteps; i++)
    {
        _odometer += speedFunction(i*dt) * dt;
    }
}

- (void)driveForDuration:(double)duration withVariableSpeedBlock:(SpeedBlock)speedFunction steps:(int)numSteps
{
    double dt = duration / numSteps;
    for (int i=1; i<=numSteps; i++)
    {
        _odometer += speedFunction(i*dt) * dt;
    }
}

- (NSString *)model{
    return _model;
}

- (void)startEngine{
    NSLog(@"start engine");
}

@end
