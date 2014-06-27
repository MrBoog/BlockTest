//
//  CarUtilities.m
//  blockDemo
//
//  Created by liuHuan on 6/11/14.
//  Copyright (c) 2014 itotem. All rights reserved.
//

#import "CarUtilities.h"

// Private function declaration\
随机取出数组中的一个元素.
static id getRandomItemFromArray(NSArray *anArray);


// Public function implementations
NSString *CUGetRandomMake(NSArray *makes) {
    return getRandomItemFromArray(makes);
}
NSString *CUGetRandomModel(NSArray *models) {
    return getRandomItemFromArray(models);
}
NSString *CUGetRandomMakeAndModel(NSDictionary *makesAndModels) {
    NSArray *makes = [makesAndModels allKeys];
    NSString *randomMake = CUGetRandomMake(makes);//key
    
    NSArray *models = makesAndModels[randomMake];
    NSString *randomModel = CUGetRandomModel(models);//value
    
    return [randomMake stringByAppendingFormat:@" %@", randomModel];
}

// Private function implementation\
随机取出数组中的一个元素.
static id getRandomItemFromArray(NSArray *anArray) {
    int maximum = (int)[anArray count];
    int randomIndex = arc4random_uniform(maximum);
    return anArray[randomIndex];
}




