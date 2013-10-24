//
//  JSObjection+MSAddModule.m
//  MSSpec
//
//  Created by Nacho Soto on 10/24/13.
//  Copyright (c) 2013 MindSnacks. All rights reserved.
//

#import "JSObjection+MSAddModule.h"

@implementation JSObjection (MSAddModule)

+ (void)ms_addModule:(JSObjectionModule *)module {
    [self setDefaultInjector:[[self defaultInjector] withModule:module]];
}

@end
