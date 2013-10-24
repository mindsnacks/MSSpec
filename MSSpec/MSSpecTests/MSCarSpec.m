//
//  MSSpecTests.m
//  MSSpecTests
//
//  Created by Nacho Soto on 10/24/13.
//  Copyright (c) 2013 MindSnacks. All rights reserved.
//

#import "MSCar.h"

#import "MSEngine.h"
#import "MSBrakes.h"

MSSPEC_BEGIN(MSCarSpec)

context(@"when created", ^{
    MSMockClass(MSEngine);
    
    __block MSCar *car;
    __block MSEngine *engine;
    
    beforeEach(^{
        car = MSInjectionCreateObject(MSCar);
        engine = MSInjectionCreateObject(MSEngine);
    });
    
    it(@"has an engine", ^{
        [[[car engine] should] beNonNil];
    });
    
    it(@"has breaks", ^{
        [[[car brakes] shouldNot] beNil];
    });
    
it(@"has a configured engine", ^{
    NSString *name = @"name";
    
    [engine stub:@selector(name) andReturn:name];
    
    [[car.engine.name should] equal:name];
});
});

MSSPEC_END