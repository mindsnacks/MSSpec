//
//  MSSpecTests.m
//  MSSpec
//
//  Created by Nacho Soto on 10/24/13.
//  Copyright (c) 2013 MindSnacks. All rights reserved.
//

#import "MSSpecTests.h"

@implementation MSSpecTests

+ (void)load {
    @autoreleasepool {
        [JSObjection setDefaultInjector:[JSObjection createInjector]];
    }
}

@end
