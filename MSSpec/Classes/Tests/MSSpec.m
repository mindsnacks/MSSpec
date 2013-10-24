//
//  MSSpec.m
//  MSSpec
//
//  Created by Nacho Soto on 10/24/13.
//  Copyright (c) 2013 MindSnacks. All rights reserved.
//

#import "MSSpec.h"

#import "JSObjection+MSAddModule.h"

static NSMutableArray *_addedModules;

@interface _MSInjectionModule : JSObjectionModule

@end

@implementation _MSInjectionModule {
    NSArray *_mockedClasses;
    NSMutableDictionary *_mocks;
}

- (id)init {
    return [self initWithMockedClasses:nil];
}

- (id)initWithMockedClasses:(NSArray *)mockedClasses {
    NSParameterAssert(mockedClasses);
    
    if ((self = [super init])) {
        _mockedClasses = [mockedClasses copy];
        _mocks = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)configure {
    [super configure];
    
    for (Class cls in _mockedClasses) {
        [self bindBlock:^id(__unused JSObjectionInjector *context) {
            NSString *const key = NSStringFromClass(cls);
            
            // cache mocks so that the one injected to classes
            // and the one injected to the test is the same one.
            // We can't use `JSObjectionScopeSingleton` because that
            // doesn't seem to work with `bindBlock:`
            if (_mocks[key] == nil) {
                _mocks[key] = [cls mock];
            }
            
            return _mocks[key];
        } toClass:cls];
    }
}

@end

@implementation MSSpec

static JSObjectionInjector *_lastUsedInjector;

+ (void)prepareMocks:(NSArray *)mockedClasses {
    NSAssert(_lastUsedInjector == nil, @"Mocks weren't reset before calling this method again.");
    
    _lastUsedInjector = JSObjection.defaultInjector;
    
    [JSObjection ms_addModule:[[_MSInjectionModule alloc] initWithMockedClasses:mockedClasses]];
}

+ (void)resetMocks {
    [JSObjection setDefaultInjector:_lastUsedInjector];
    
    _lastUsedInjector = nil;
}

@end
