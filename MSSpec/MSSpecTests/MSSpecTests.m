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
    if (self == [MSSpecTests class]) {
        @autoreleasepool {
            [JSObjection setDefaultInjector:[JSObjection createInjector]];
        }
    }
}

@end
