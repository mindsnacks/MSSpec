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
    NSArray *_mockedProtocols;
    
    // this contains mocks for both classes and protocols
    // which might produce colisions.
    NSMutableDictionary *_mocks;
}

- (id)init {
    return [self initWithMockedClasses:nil protocols:nil];
}

- (id)initWithMockedClasses:(NSArray *)mockedClasses
                  protocols:(NSArray *)mockedProtocols {
    NSParameterAssert(mockedClasses);
    NSParameterAssert(mockedProtocols);
    
    if ((self = [super init])) {
        _mockedClasses = [mockedClasses copy];
        _mockedProtocols = [mockedProtocols copy];
        _mocks = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)configure {
    [super configure];
    
    for (Class cls in _mockedClasses) {
        [self bindBlock:^id(__unused JSObjectionInjector *context) {
            NSString *const key = NSStringFromClass(cls);
            
            if (_mocks[key] == nil) {
                _mocks[key] = [cls mock];
            }
            
            return _mocks[key];
        } toClass:cls];
    }
    
    for (Protocol *protocol in _mockedProtocols) {
        [self bindBlock:^id(__unused JSObjectionInjector *context) {
            NSString *const key = NSStringFromProtocol(protocol);
            
            if (_mocks[key] == nil) {
                _mocks[key] = [KWMock mockForProtocol:protocol];
            }
            
            return _mocks[key];
        } toProtocol:protocol];
    }
}

@end

@implementation MSSpec

static JSObjectionInjector *_lastUsedInjector;

+ (void)prepareMocksForClasses:(NSArray *)mockedClasses
                     protocols:(NSArray *)mockedProtocols {
    NSAssert(_lastUsedInjector == nil, @"Mocks weren't reset before calling this method again.");
    
    _lastUsedInjector = JSObjection.defaultInjector;
    
    [JSObjection ms_addModule:[[_MSInjectionModule alloc] initWithMockedClasses:mockedClasses
                                                                      protocols:mockedProtocols]];
}

+ (void)resetMocks {
    [JSObjection setDefaultInjector:_lastUsedInjector];
    
    _lastUsedInjector = nil;
}

@end
