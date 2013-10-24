//
//  MSEngine.m
//  MSSpec
//
//  Created by Nacho Soto on 10/22/13.
//  Copyright (c) 2013 MindSnacks. All rights reserved.
//

#import "MSEngine.h"

@interface MSEngine ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic) CGFloat power;

@end

@implementation MSEngine

MSInjectionDesignatedInitializer(initWithName:power:);

- (id)init {
    return [self initWithName:nil power:0];
}

- (instancetype)initWithName:(NSString *)name power:(CGFloat)power {
    NSParameterAssert(name);
    
    if ((self = [super init])) {
        self.name = name;
        self.power = power;
    }
    
    return self;
}

@end
