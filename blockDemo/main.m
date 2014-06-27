//
//  main.m
//  blockDemo
//
//  Created by liuHuan on 6/8/14.
//  Copyright (c) 2014 itotem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CarUtilities.h"
#import "Person.h"
#import "Car.h"


/*
 ignore warning : performSeletor may cause a leak because its selector is unknown
 */
#define NoWarningPerformSelector(target, action, object) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
[target performSelector:action withObject:object]; \
_Pragma("clang diagnostic pop") \



/*
 c语言 函数 getRandomInteger
 
 static 将函数限制在只在本类中使用（否则函数是全局作用域）。static 关键字函数声明和实现时都要加。
 
 返回值          |  函数名    |       参数     |    实现
 return value   |   name    |   parameters  |   associatedBlock
 */
static int getRandomInteger(int minimum, int maximum) {
    //arc4random_uniform 优于     arc4random()
    return arc4random_uniform((maximum - minimum) + 1) + minimum;
}


/*
 objective-c对象的 c语言函数 可在调用前先声明 或者就在调用前实现。
 */
NSString *getRandomMake(NSArray *makes);


//声明c函数
void testBlock();



int main(int argc, const char * argv[]) {
    @autoreleasepool {

        //
        int randomNumber = getRandomInteger(-10, 10);
        NSLog(@"random number is %d", randomNumber);
        
        
        //
        NSArray *makes = @[@"Honda", @"Ford", @"Nissan", @"Porsche"];
        NSLog(@"Selected a %@", getRandomMake(makes));
        
        
        // 面向过程写法，不引入对象。
        NSDictionary *makesAndModels = @{
                                         @"Ford": @[@"Explorer", @"F-150"],
                                         @"Honda": @[@"Accord", @"Civic", @"Pilot"],
                                         @"Nissan": @[@"370Z", @"Altima", @"Versa"],
                                         @"Porsche": @[@"911 Turbo", @"Boxster", @"Cayman S"]
                                         };
        NSString *randomCar = CUGetRandomMakeAndModel(makesAndModels);
        NSLog(@"Selected a %@", randomCar);
        
        
        
        
        
        // 比较copy与strong
        Person *_person = [[Person alloc] init];
        NSMutableString *name = [NSMutableString stringWithString:@"Allen"];
        _person.name = name;
        NSLog(@"%@,%p",_person.name,_person.name);
        [name setString:@"Jhon"];
        NSLog(@"%@,%p",_person.name,name);
        
        NSNumber *number = @90;
        _person.number = number;
        NSLog(@"%@,%p",_person.number,_person.number);
        number = @1;
        NSLog(@"%@,%p",_person.number,number);
        
        NSMutableArray *array = [NSMutableArray arrayWithObject:@9];
        _person.array = array;
        NSLog(@"%@,%p",_person.array,_person.array);
        [array addObject:@0];
        NSLog(@"%@,%p",_person.array,array);
        
        
        /*
         __attribute__((unused)) 去掉 unused variable warning
         */
        Car *porsche = [[Car alloc] init];
        porsche.model = @"Porsche 911 Carrera";
        __attribute__((unused)) SEL stepOne = NSSelectorFromString(@"startEngine");
//      第二种获得SEL的办法：\
        stepOne = @selector(startEngine:);


        
        // This is the same as:\
        [porsche startEngine];
        if ([porsche respondsToSelector:stepOne]) {
            // 一下宏用来替换 [porsche performSelector:stepOne withObject:nil];，去掉警告。
            NoWarningPerformSelector(porsche, stepOne, nil);
        }

        
        //测试一下 block，
        testBlock();
        
    }
    return 0;
}

/*
 实现
 */
NSString *getRandomMake(NSArray *makes) {
    int maximum = (int)[makes count];
    int randomIndex = arc4random_uniform(maximum);//数组中随机抽取
    return makes[randomIndex];
}






#pragma mark - Block -

/*
 返回值类型 | (^ block变量名) | (参数, ... )  = ^ 返回值类型( 参数, ... ){ ... };
 */
/*
 下面为 非内联 用法
 */
int(^maxBlk)(int, int) = ^(int m, int n){
    return m > n ? m : n;
};



void testBlock(){
    //The block itself is essentially a function definition—without the function name.
    
    
    /*
     直接调用，最后面的（）相当于直接调用。
     */
    ^{printf("Hello, World!\n"); } ();
    
    
    int i = 1024;
    void(^blk)(void) = ^{ printf("%d\n", i); };
    blk();//调用
    
    
    int foo = maxBlk(11,92);//调用
    printf("foo= %d\n",foo);
    
    
    //注意下面两种写法,都可以 ： \
    1:double (^distanceFromRateAndTime)(double , double ) = ^double(double rate,double time){\
          return rate * time;\
      };\
    2:double (^distanceFromRateAndTime)(double rate, double time);\
      distanceFromRateAndTime = ^double(double rate, double time) {\
          return rate * time;\
      };


    
    // Declare the block variable\
    声明block变量了，并同时确定返回类型，以及参数。就像是在声明函数。
    double (^distanceFromRateAndTime)(double rate, double time);
    
    // Create and assign the block\
    注意等号右边，创建block的时候只有  ： 返回值 参数。没有函数名字，所以其他语言称之为“匿名函数” \
    the return type can be omitted if desired. 即如下的返回值 double 可以省略... ^(double rate,double time){}
    distanceFromRateAndTime = ^double(double rate, double time) {
        return rate * time;
    };
    // Call the block
     __attribute__((unused)) double dx = distanceFromRateAndTime(35, 1.5);
    
    
    
    
    //  Parameterless Blocks | 无参数 block \
    Declare and Create the Parameterless Blocks\
    如果参数是void,也就是没有参数。那么等号后边返回值、参数都可以省略,直接用 ： ^{ ... };
    __attribute__((unused)) double (^distanceFromRate)(void) = ^{ return 90.0; };
    
    
    
    //Closures | 闭包特性 \
    block 区别于函数，拥有闭包特性，可以访问外部变量. 但对于block来说，访问的外部变量是只读的(只是copy到block内部，并且是const)。
    NSString *make = @"Honda";
    NSString *(^getFullCarName)(NSString *) = ^(NSString *model) {
        return [make stringByAppendingFormat:@" %@", model];
    };
    NSLog(@"%@", getFullCarName(@"Accord"));
    
    
    
    //利用id来 接收 block变量。\
    使用copy，将block由 栈中 拷贝至 堆中。
    id block_ = [^{  NSLog(@" it works ! id 接收 并将 block 由 stack copy to heap。");} copy];
    typedef void (^BlockType)(void);
    BlockType blockObject = (BlockType)block_;//id 类型的 block ，强制转换为 BlockType；
    blockObject();//调用
    

    
    //__block storage modifier\
    为了安全起见，外部变量对于block来说是read-only。如果想要在block内部改变外部的变量 需要用__block 修饰符\
    同时在使用中，应该注意 block的循环引用问题（NSTimer也存在，在dealloc里面 invalidate），必要时使用  __weak，如 __weak id weakSelf = self;
    __block NSString *fooStr = @"hi";
    int count = 0;//read only
    NSString *(^testStrBlock)(void) = ^NSString *(void){
        return [fooStr stringByAppendingFormat:@" : %d .",count];
    };
    count++;
    fooStr = @" hi again !";
    NSLog(@"%@",testStrBlock());
    

    
    Car *theCar = [[Car alloc] init];
    
    // Drive for awhile with constant speed of 5.0 m/s
    [theCar driveForDuration:10.0
           withVariableSpeed:^(double time) {
               return 5.0;
           } steps:100];
    NSLog(@"The car has now driven %.2f meters", theCar.odometer);
    
    // Start accelerating at a rate of 1.0 m/s^2
    [theCar driveForDuration:10.0 withVariableSpeedBlock:^double(double time) {
        return  time + 5.0;
    } steps:100];
    NSLog(@"The car has now driven %.2f meters", theCar.odometer);
    
    return;
}







